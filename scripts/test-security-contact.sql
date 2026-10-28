-- Run as the database owner after 20261027113141_secure_admin_rpc_and_contact_inbox.sql.
-- Every fixture, Auth user, temporary helper and mutation is rolled back.
-- No Auth API calls, outbound email, real inbox payloads or real user changes.
-- Any unexpected success/error aborts the transaction immediately.
BEGIN;
SET LOCAL statement_timeout = '60s';
SET LOCAL lock_timeout = '5s';

CREATE TEMP TABLE security_test_checks (label text PRIMARY KEY) ON COMMIT DROP;
CREATE TEMP TABLE security_test_actors (
  label text PRIMARY KEY, id uuid NOT NULL DEFAULT gen_random_uuid(),
  app_role text NOT NULL DEFAULT 'viewer', status text NOT NULL DEFAULT 'active',
  permissions jsonb NOT NULL DEFAULT '{}'
) ON COMMIT DROP;
INSERT INTO security_test_actors(label,app_role,status,permissions) VALUES
  ('viewer','viewer','active','{}'),
  ('admin','admin','active','{}'),
  ('editor','editor','active','{}'),
  ('schedule','viewer','active','{"schedule":{"edit":true}}'),
  ('season','viewer','active','{"seasons":{"generate":true}}'),
  ('banned','admin','banned','{"schedule":{"edit":true}}'),
  ('suspended','editor','suspended','{"seasons":{"generate":true}}'),
  ('users_edit','viewer','active','{"users":{"edit":true,"create":true}}'),
  ('grant_only','viewer','active','{"users":{"permissions":{"grant":true}},"schedule":{"edit":true},"contact":{"read":true}}'),
  ('revoke_only','viewer','active','{"users":{"permissions":{"revoke":true}}}'),
  ('target','viewer','active','{}'),
  ('contact_reader','viewer','active','{"contact":{"read":true}}'),
  ('contact_manager','viewer','active','{"contact":{"manage":true}}');

CREATE TEMP TABLE security_test_context AS SELECT
  gen_random_uuid() AS run_id, gen_random_uuid() AS league_id,
  gen_random_uuid() AS team_a, gen_random_uuid() AS team_b,
  gen_random_uuid() AS player_id, gen_random_uuid() AS submission_id;
CREATE TEMP TABLE security_test_seasons AS
SELECT a.label, gen_random_uuid() AS id,
       ((SELECT COALESCE(max(year),2026) FROM public.seasons) + 1000 + row_number() OVER (ORDER BY a.label))::integer AS year
FROM security_test_actors a WHERE label IN ('admin','editor','schedule','season');
GRANT SELECT ON security_test_actors, security_test_context, security_test_seasons TO anon,authenticated,service_role;
GRANT INSERT,SELECT ON security_test_checks TO anon,authenticated,service_role;

CREATE FUNCTION pg_temp.check_true(p_ok boolean,p_label text) RETURNS void
LANGUAGE plpgsql SECURITY INVOKER AS $$
BEGIN
  IF p_ok IS DISTINCT FROM true THEN RAISE EXCEPTION 'TEST FAILED: %',p_label; END IF;
  INSERT INTO pg_temp.security_test_checks VALUES(p_label);
END;
$$;
CREATE FUNCTION pg_temp.expect_error(p_sql text,p_state text,p_label text,p_message text DEFAULT NULL)
RETURNS void LANGUAGE plpgsql SECURITY INVOKER AS $$
DECLARE actual_state text; actual_message text;
BEGIN
  BEGIN
    EXECUTE p_sql;
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS actual_state=RETURNED_SQLSTATE,actual_message=MESSAGE_TEXT;
    IF actual_state<>p_state OR (p_message IS NOT NULL AND actual_message<>p_message) THEN
      RAISE EXCEPTION 'TEST FAILED: %; expected SQLSTATE % / %, got % / %',p_label,p_state,p_message,actual_state,actual_message;
    END IF;
    PERFORM pg_temp.check_true(true,p_label);
    RETURN;
  END;
  RAISE EXCEPTION 'TEST FAILED: %; operation unexpectedly succeeded',p_label;
END;
$$;
CREATE FUNCTION pg_temp.actor(p_label text) RETURNS void
LANGUAGE plpgsql SECURITY INVOKER AS $$
DECLARE actor_id uuid;
BEGIN
  SELECT id INTO actor_id FROM pg_temp.security_test_actors WHERE label=p_label;
  IF p_label IS NOT NULL AND actor_id IS NULL THEN RAISE EXCEPTION 'Unknown test actor'; END IF;
  PERFORM set_config('request.jwt.claim.sub',COALESCE(actor_id::text,''),true);
  PERFORM set_config('request.jwt.claims',jsonb_build_object('sub',actor_id,'role',current_user)::text,true);
END;
$$;

-- Signup must still run the nested profile trigger under trusted maintenance.
INSERT INTO auth.users(id,email,raw_user_meta_data)
SELECT id,'rollback-'||id::text||'@example.invalid',jsonb_build_object('display_name','MLPN regression fixture')
FROM security_test_actors;
SELECT pg_temp.check_true(
  (SELECT count(*) FROM public.profiles p JOIN security_test_actors a ON a.id=p.id)=13,
  'Auth signup generated every fixture profile');
UPDATE public.profiles p SET role=a.app_role,account_status=a.status,permissions=a.permissions
FROM security_test_actors a WHERE p.id=a.id;
INSERT INTO public.players(id,first_name,last_name,position)
SELECT player_id,'Regression','Fixture','POM' FROM security_test_context;
INSERT INTO public.leagues(id,code,name)
SELECT league_id,'rollback-'||run_id::text,'Rollback regression league' FROM security_test_context;
INSERT INTO public.teams(id,name,abbreviation)
SELECT team_a,'Rollback A '||run_id::text,'A-'||run_id::text FROM security_test_context
UNION ALL SELECT team_b,'Rollback B '||run_id::text,'B-'||run_id::text FROM security_test_context;
INSERT INTO public.seasons(id,year,name,status,is_current)
SELECT id,year,'Rollback regression '||label,'planned',false FROM security_test_seasons;
INSERT INTO public.season_leagues(season_id,league_id)
SELECT s.id,c.league_id FROM security_test_seasons s CROSS JOIN security_test_context c;
INSERT INTO public.season_teams(season_id,league_id,team_id)
SELECT s.id,c.league_id,team_id FROM security_test_seasons s CROSS JOIN security_test_context c
CROSS JOIN LATERAL unnest(ARRAY[c.team_a,c.team_b]) team_id;

SET LOCAL ROLE anon;
DO $$ BEGIN
  PERFORM pg_temp.actor(NULL);
  PERFORM pg_temp.expect_error('SELECT public.exec_sql(''SELECT 1'')','42501','anon cannot exec_sql');
  PERFORM pg_temp.expect_error('SELECT public.generate_round_robin(NULL,NULL,CURRENT_DATE)','42501','anon cannot generate schedule');
  PERFORM pg_temp.expect_error('SELECT public.initialize_standings(NULL,NULL)','42501','anon cannot initialize standings');
END $$;
RESET ROLE;
SET LOCAL ROLE service_role;
DO $$ BEGIN
  PERFORM public.exec_sql('SELECT 1');
  PERFORM pg_temp.check_true(true,'service_role retains harmless exec_sql');
END $$;
RESET ROLE;

SET LOCAL ROLE authenticated;
DO $$
DECLARE actor_label text;
BEGIN
  PERFORM pg_temp.actor(NULL);
  PERFORM pg_temp.check_true(auth.uid() IS NULL,'identityless authenticated fixture has no uid');
  PERFORM pg_temp.expect_error('SELECT public.generate_round_robin(NULL,NULL,CURRENT_DATE)','42501','identityless cannot generate','SCHEDULE_ACCESS_DENIED');
  PERFORM pg_temp.expect_error('SELECT public.initialize_standings(NULL,NULL)','42501','identityless cannot initialize','SCHEDULE_ACCESS_DENIED');
  FOREACH actor_label IN ARRAY ARRAY['viewer','banned','suspended'] LOOP
    PERFORM pg_temp.actor(actor_label);
    PERFORM pg_temp.expect_error('SELECT public.generate_round_robin(NULL,NULL,CURRENT_DATE)','42501',actor_label||' cannot generate','SCHEDULE_ACCESS_DENIED');
    PERFORM pg_temp.expect_error('SELECT public.initialize_standings(NULL,NULL)','42501',actor_label||' cannot initialize','SCHEDULE_ACCESS_DENIED');
  END LOOP;
  PERFORM pg_temp.actor('viewer');
  PERFORM pg_temp.expect_error('SELECT public.exec_sql(''SELECT 1'')','42501','viewer cannot exec_sql');
END $$;

-- Each authorized actor owns a separate two-team season; insertion fires real standings triggers.
DO $$
DECLARE s record; league uuid; generated record; initialized integer;
BEGIN
  SELECT league_id INTO league FROM pg_temp.security_test_context;
  FOR s IN SELECT * FROM pg_temp.security_test_seasons ORDER BY label LOOP
    PERFORM pg_temp.actor(s.label);
    SELECT public.initialize_standings(s.id,league) INTO initialized;
    PERFORM pg_temp.check_true(initialized=2,s.label||' initializes two standings');
    PERFORM pg_temp.check_true(public.initialize_standings(s.id,league)=0,s.label||' initialization is idempotent');
    SELECT * INTO generated FROM public.generate_round_robin(s.id,league,CURRENT_DATE+30);
    PERFORM pg_temp.check_true(generated.matches_created=2 AND generated.rounds_total=2,s.label||' generates home and away matches');
    PERFORM pg_temp.check_true((SELECT count(*) FROM public.matches WHERE season_id=s.id)=2,s.label||' persisted exactly two matches');
    PERFORM pg_temp.check_true((SELECT count(DISTINCT home_team_id) FROM public.matches WHERE season_id=s.id)=2,s.label||' home and away swap');
    PERFORM pg_temp.check_true((SELECT total_rounds FROM public.season_leagues WHERE season_id=s.id AND league_id=league)=2,s.label||' updates league rounds');
    PERFORM pg_temp.check_true((SELECT count(*) FROM public.standings WHERE season_id=s.id AND played=0)=2,s.label||' nested standings trigger succeeds');
    PERFORM pg_temp.check_true(public.initialize_standings(s.id,league)=0,s.label||' initialization stays idempotent after generation');
  END LOOP;
  PERFORM pg_temp.actor('admin');
  UPDATE public.matches SET home_goals=2,away_goals=0,status='completed'
  WHERE season_id=(SELECT id FROM pg_temp.security_test_seasons WHERE label='admin') AND round=1;
  PERFORM pg_temp.check_true((SELECT sum(played)=2 AND sum(points)=3 FROM public.standings
    WHERE season_id=(SELECT id FROM pg_temp.security_test_seasons WHERE label='admin')),
    'nested result update recalculates two standings');
END $$;

DO $$
DECLARE actor_id uuid; target_id uuid; player uuid; row_count integer;
BEGIN
  PERFORM pg_temp.actor('viewer');
  actor_id:=auth.uid();
  SELECT id INTO target_id FROM pg_temp.security_test_actors WHERE label='target';
  SELECT player_id INTO player FROM pg_temp.security_test_context;
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET permissions=%L::jsonb WHERE id=%L','{"schedule":{"edit":true}}',actor_id),'42501','self permissions denied','PROFILE_SELF_GRANT_DENIED');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET role=''admin'' WHERE id=%L',actor_id),'42501','self admin role denied','PROFILE_ADMIN_REQUIRED');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET account_status=''suspended'' WHERE id=%L',actor_id),'42501','self status denied','PROFILE_STATUS_DENIED');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET player_id=%L WHERE id=%L',player,actor_id),'42501','self player link denied','PROFILE_LINK_DENIED');
  UPDATE public.profiles SET display_name='Allowed fixture display' WHERE id=actor_id;
  GET DIAGNOSTICS row_count=ROW_COUNT;
  PERFORM pg_temp.check_true(row_count=1 AND (SELECT display_name='Allowed fixture display' FROM public.profiles WHERE id=actor_id),'self display name allowed');
  PERFORM pg_temp.actor('banned');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET account_status=''active'' WHERE id=%L',auth.uid()),'42501','banned admin cannot reactivate self','PROFILE_ACCESS_DENIED');
  PERFORM pg_temp.actor('suspended');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET account_status=''active'' WHERE id=%L',auth.uid()),'42501','suspended editor cannot reactivate self','PROFILE_ACCESS_DENIED');

  PERFORM pg_temp.actor('users_edit');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET role=''admin'' WHERE id=%L',target_id),'42501','users.edit cannot grant admin','PROFILE_ADMIN_REQUIRED');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET permissions=%L::jsonb WHERE id=%L','{"schedule":{"edit":true}}',target_id),'42501','users.edit alone cannot grant permissions','PROFILE_GRANT_DENIED');
  PERFORM pg_temp.expect_error(format('INSERT INTO public.profiles(id,role,permissions) VALUES(%L,''viewer'',%L::jsonb) ON CONFLICT(id) DO UPDATE SET permissions=EXCLUDED.permissions',auth.uid(),'{"schedule":{"edit":true}}'),'42501','self upsert cannot grant permissions','PROFILE_SELF_GRANT_DENIED');
  UPDATE public.profiles SET display_name='Delegated fixture display' WHERE id=target_id;
  GET DIAGNOSTICS row_count=ROW_COUNT;
  PERFORM pg_temp.check_true(row_count=1,'users.edit can edit another display name');

  PERFORM pg_temp.actor('grant_only');
  UPDATE public.profiles SET permissions='{"schedule":{"edit":true},"contact":{"read":true}}' WHERE id=target_id;
  GET DIAGNOSTICS row_count=ROW_COUNT;
  PERFORM pg_temp.check_true(row_count=1 AND (SELECT permissions#>>'{schedule,edit}'='true' FROM public.profiles WHERE id=target_id),'bounded held permissions can be granted');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET permissions=permissions || %L::jsonb WHERE id=%L','{"users":{"edit":true}}',target_id),'42501','cannot delegate users authority','PROFILE_GRANT_DENIED');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET permissions=permissions || %L::jsonb WHERE id=%L','{"users":{"permissions":{"grant":true}}}',target_id),'42501','cannot delegate held permission-granting authority','PROFILE_GRANT_DENIED');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET permissions=permissions || %L::jsonb WHERE id=%L','{"users":{"*":true}}',target_id),'42501','cannot delegate users wildcard','PROFILE_GRANT_DENIED');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET permissions=permissions || %L::jsonb WHERE id=%L','{"players":{"delete":true}}',target_id),'42501','cannot grant unheld permission','PROFILE_GRANT_DENIED');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET permissions=''{}''::jsonb WHERE id=%L',target_id),'42501','grant-only cannot revoke','PROFILE_REVOKE_DENIED');
  UPDATE public.profiles SET permissions=permissions || '{"players":{"delete":false}}' WHERE id=target_id;
  PERFORM pg_temp.check_true((SELECT permissions#>>'{players,delete}'='false' FROM public.profiles WHERE id=target_id),'false permission leaf is not a grant');

  PERFORM pg_temp.actor('revoke_only');
  UPDATE public.profiles SET permissions='{}' WHERE id=target_id;
  GET DIAGNOSTICS row_count=ROW_COUNT;
  PERFORM pg_temp.check_true(row_count=1 AND (SELECT permissions='{}' FROM public.profiles WHERE id=target_id),'revoke-only removes permissions');
  PERFORM pg_temp.expect_error(format('UPDATE public.profiles SET permissions=%L::jsonb WHERE id=%L','{"schedule":{"edit":true}}',target_id),'42501','revoke-only cannot grant','PROFILE_GRANT_DENIED');
END $$;
RESET ROLE;

-- These addresses are reserved invalid-domain fixtures, never real recipients.
SET LOCAL ROLE anon;
DO $$
DECLARE sid uuid; email text; result_id uuid; invalid_input record;
BEGIN
  PERFORM pg_temp.actor(NULL);
  SELECT submission_id,'rollback-'||run_id::text||'@example.invalid' INTO sid,email FROM pg_temp.security_test_context;
  result_id:=public.submit_contact_message('  Fixture sender  ',' '||upper(email)||' ','  Fixture subject  ','  Synthetic rollback message only.  ','',sid);
  PERFORM pg_temp.check_true(result_id=sid,'anon validated submission returns requested UUID');
  PERFORM pg_temp.check_true(public.submit_contact_message('Fixture sender',email,'Fixture subject','Synthetic rollback message only.','',sid)=sid,'normalized exact retry returns same UUID');
  PERFORM pg_temp.expect_error(format('SELECT public.submit_contact_message(%L,%L,%L,%L,%L,%L::uuid)','Fixture sender',email,'Conflicting subject','Synthetic rollback message only.','',sid),'22023','same UUID with changed payload rejected','CONTACT_SUBMISSION_CONFLICT');
  FOR invalid_input IN SELECT * FROM (VALUES
    ('short name','X',email,'Fixture subject','Synthetic rollback message only.',''),
    ('invalid email','Fixture sender','invalid-address','Fixture subject','Synthetic rollback message only.',''),
    ('short subject','Fixture sender',email,'Hi','Synthetic rollback message only.',''),
    ('short message','Fixture sender',email,'Fixture subject','Short',''),
    ('honeypot','Fixture sender',email,'Fixture subject','Synthetic rollback message only.','bot.invalid'),
    ('null name',NULL,email,'Fixture subject','Synthetic rollback message only.',''),
    ('long name',repeat('x',121),email,'Fixture subject','Synthetic rollback message only.',''),
    ('long subject','Fixture sender',email,repeat('x',161),'Synthetic rollback message only.',''),
    ('long message','Fixture sender',email,'Fixture subject',repeat('x',5001),'')
  ) AS cases(label,name,address,subject,message,website) LOOP
    PERFORM pg_temp.expect_error(format('SELECT public.submit_contact_message(%L,%L,%L,%L,%L,%L::uuid)',invalid_input.name,invalid_input.address,invalid_input.subject,invalid_input.message,invalid_input.website,gen_random_uuid()),'22023','contact rejects '||invalid_input.label,'CONTACT_INVALID_INPUT');
  END LOOP;
  PERFORM pg_temp.expect_error(format('SELECT public.submit_contact_message(%L,%L,%L,%L,'''',NULL)','Fixture sender',email,'Fixture subject','Synthetic rollback message only.'),'22023','contact requires submission UUID','CONTACT_INVALID_INPUT');
  PERFORM pg_temp.expect_error('SELECT count(*) FROM public.contact_messages','42501','anon cannot read inbox');
  PERFORM pg_temp.expect_error(format('INSERT INTO public.contact_messages(sender_name,sender_email,subject,message) VALUES(%L,%L,%L,%L)','Fixture sender',email,'Direct insert','Synthetic rollback message only.'),'42501','anon cannot bypass RPC with direct insert');
  PERFORM pg_temp.expect_error(format('UPDATE public.contact_messages SET status=''read'' WHERE id=%L',sid),'42501','anon cannot update inbox');
  PERFORM public.submit_contact_message('Fixture sender',email,'Second fixture','Synthetic rollback message only.','',gen_random_uuid());
  PERFORM public.submit_contact_message('Fixture sender',email,'Third fixture','Synthetic rollback message only.','',gen_random_uuid());
  PERFORM pg_temp.expect_error(format('SELECT public.submit_contact_message(%L,%L,%L,%L,'''',%L::uuid)','Fixture sender',email,'Fourth fixture','Synthetic rollback message only.',gen_random_uuid()),'P0001','fourth submission per email rate-limited','CONTACT_RATE_LIMIT');
  PERFORM pg_temp.check_true(public.submit_contact_message('Fixture sender',email,'Fixture subject','Synthetic rollback message only.','',sid)=sid,'retry remains idempotent at rate limit');
END $$;
RESET ROLE;
SELECT pg_temp.check_true((SELECT count(*) FROM public.contact_messages WHERE id=(SELECT submission_id FROM security_test_context))=1,'duplicate submission created one inbox row');
SELECT pg_temp.check_true((SELECT sender_name='Fixture sender' AND sender_email='rollback-'||(SELECT run_id::text FROM security_test_context)||'@example.invalid' AND subject='Fixture subject' AND message='Synthetic rollback message only.' AND status='new' AND NOT is_read
  FROM public.contact_messages WHERE id=(SELECT submission_id FROM security_test_context)),'stored contact payload normalized and initially unread');

SET LOCAL ROLE authenticated;
DO $$
DECLARE sid uuid; row_count integer; payload_before jsonb; forbidden_column record;
BEGIN
  SELECT submission_id INTO sid FROM pg_temp.security_test_context;
  PERFORM pg_temp.actor('viewer');
  PERFORM pg_temp.check_true((SELECT count(*) FROM public.contact_messages)=0,'authenticated viewer sees no inbox rows');
  PERFORM pg_temp.check_true(public.submit_contact_message('Fixture sender','authenticated-'||gen_random_uuid()::text||'@example.invalid','Authenticated fixture','Synthetic rollback message only.','',gen_random_uuid()) IS NOT NULL,'authenticated viewer may submit through validated RPC');
  UPDATE public.contact_messages SET status='read' WHERE id=sid;
  GET DIAGNOSTICS row_count=ROW_COUNT;
  PERFORM pg_temp.check_true(row_count=0,'viewer cannot update hidden inbox row');
  PERFORM pg_temp.actor('contact_reader');
  PERFORM pg_temp.check_true((SELECT count(*) FROM public.contact_messages WHERE id=sid)=1,'contact.read sees inbox fixture');
  UPDATE public.contact_messages SET status='read' WHERE id=sid;
  GET DIAGNOSTICS row_count=ROW_COUNT;
  PERFORM pg_temp.check_true(row_count=0 AND (SELECT status='new' FROM public.contact_messages WHERE id=sid),'contact.read cannot change status');
  PERFORM pg_temp.actor('contact_manager');
  SELECT jsonb_build_array(sender_name,sender_email,subject,message,created_at) INTO payload_before FROM public.contact_messages WHERE id=sid;
  UPDATE public.contact_messages SET status='read' WHERE id=sid;
  GET DIAGNOSTICS row_count=ROW_COUNT;
  PERFORM pg_temp.check_true(row_count=1 AND (SELECT is_read AND status='read' AND updated_at IS NOT NULL FROM public.contact_messages WHERE id=sid),'contact.manage updates status and nested read flag');
  UPDATE public.contact_messages SET status='archived' WHERE id=sid;
  PERFORM pg_temp.check_true((SELECT is_read AND status='archived' FROM public.contact_messages WHERE id=sid),'manager can archive');
  UPDATE public.contact_messages SET status='new' WHERE id=sid;
  PERFORM pg_temp.check_true((SELECT NOT is_read AND status='new' FROM public.contact_messages WHERE id=sid),'manager can mark unread');
  PERFORM pg_temp.expect_error(format('UPDATE public.contact_messages SET status=''deleted'' WHERE id=%L',sid),'23514','invalid inbox status rejected');
  PERFORM pg_temp.expect_error(format('UPDATE public.contact_messages SET message=''Changed fixture payload'' WHERE id=%L',sid),'42501','manager cannot mutate message payload');
  PERFORM pg_temp.expect_error(format('UPDATE public.contact_messages SET sender_email=''other@example.invalid'' WHERE id=%L',sid),'42501','manager cannot mutate sender');
  PERFORM pg_temp.expect_error(format('UPDATE public.contact_messages SET is_read=true WHERE id=%L',sid),'42501','manager cannot bypass status via read flag');
  FOR forbidden_column IN SELECT * FROM (VALUES
    ('sender_name','''Changed fixture'''),('subject','''Changed subject'''),
    ('created_at','now()'),('updated_at','now()'),('id','gen_random_uuid()')
  ) AS columns(name,expression) LOOP
    PERFORM pg_temp.expect_error(format('UPDATE public.contact_messages SET %I=%s WHERE id=%L',forbidden_column.name,forbidden_column.expression,sid),'42501','manager cannot mutate '||forbidden_column.name);
  END LOOP;
  PERFORM pg_temp.expect_error(format('DELETE FROM public.contact_messages WHERE id=%L',sid),'42501','manager cannot delete immutable inbox payload');
  PERFORM pg_temp.check_true((SELECT jsonb_build_array(sender_name,sender_email,subject,message,created_at)=payload_before FROM public.contact_messages WHERE id=sid),'status edits preserve original payload');
END $$;
RESET ROLE;

-- Reach the global cap using only new synthetic rows; never edit existing messages.
DO $$
DECLARE existing_count integer;
BEGIN
  SELECT count(*) INTO existing_count FROM public.contact_messages WHERE created_at>now()-interval '1 hour';
  IF existing_count>100 THEN RAISE EXCEPTION 'TEST PRECONDITION: inbox already exceeds the global cap'; END IF;
  INSERT INTO public.contact_messages(sender_name,sender_email,subject,message)
  SELECT 'Fixture sender','global-'||gen_random_uuid()::text||'@example.invalid','Global cap fixture','Synthetic rollback message only.'
  FROM generate_series(1,100-existing_count);
END $$;
SET LOCAL ROLE anon;
DO $$ BEGIN
  PERFORM pg_temp.actor(NULL);
  PERFORM pg_temp.expect_error(format('SELECT public.submit_contact_message(%L,%L,%L,%L,'''',%L::uuid)','Fixture sender','global-'||gen_random_uuid()::text||'@example.invalid','Global cap fixture','Synthetic rollback message only.',gen_random_uuid()),'P0001','global hourly submission cap enforced','CONTACT_RATE_LIMIT');
END $$;
RESET ROLE;
SELECT count(*) AS passed_assertions FROM security_test_checks;
ROLLBACK;
SELECT 'PASS: RPC, profile authority, bounded delegation and private contact inbox; every fixture rolled back' AS result;
