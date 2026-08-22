-- One-time, fingerprint-guarded realignment for Sezon 2026.
-- Generated from the verified read-only planner on 2026-08-22.
-- Applied successfully to the MLPN project on 2026-08-22; retained for audit only.
-- The source-state fingerprints intentionally prevent an accidental rerun.
begin isolation level serializable;

set local lock_timeout = '5s';
set local statement_timeout = '120s';

select pg_advisory_xact_lock(hashtextextended('mlpn:season-2026:league-realignment', 0));

lock table public.matches in share row exclusive mode;
lock table public.season_teams in share row exclusive mode;
lock table public.season_leagues in share row exclusive mode;
lock table public.standings in share row exclusive mode;

create temp table mlpn_desired_schedule (
  league_code text not null,
  round integer not null,
  match_date date not null,
  match_time time not null,
  home_team text not null,
  away_team text not null,
  season_id uuid,
  league_id uuid,
  home_team_id uuid,
  away_team_id uuid,
  pair_key text
) on commit drop;

insert into mlpn_desired_schedule (
  league_code, round, match_date, match_time, home_team, away_team,
  season_id, league_id, home_team_id, away_team_id, pair_key
)
select
  x.league,
  x.round,
  x.match_date,
  x.match_time,
  x.home_team,
  x.away_team,
  s.id,
  l.id,
  ht.id,
  at.id,
  least(ht.id::text, at.id::text) || '::' || greatest(ht.id::text, at.id::text)
from jsonb_to_recordset($fixtures$[{"league":"1st","round":12,"match_date":"2026-08-30","match_time":"17:10","home_team":"1 Warszawska Brygada Pancerna","away_team":"Lider"},{"league":"1st","round":12,"match_date":"2026-08-29","match_time":"19:20","home_team":"Al Mar Wołomin","away_team":"Starszaki"},{"league":"1st","round":12,"match_date":"2026-08-30","match_time":"18:20","home_team":"Elo Melo","away_team":"FC Zieloni"},{"league":"1st","round":12,"match_date":"2026-08-30","match_time":"19:30","home_team":"Fanatycy","away_team":"Rebelianci"},{"league":"1st","round":12,"match_date":"2026-08-31","match_time":"21:00","home_team":"Sportowe Zakapiory","away_team":"Legioholicy"},{"league":"1st","round":13,"match_date":"2026-09-05","match_time":"19:20","home_team":"Al Mar Wołomin","away_team":"Fanatycy"},{"league":"1st","round":13,"match_date":"2026-09-06","match_time":"17:10","home_team":"Elo Melo","away_team":"Sportowe Zakapiory"},{"league":"1st","round":13,"match_date":"2026-09-06","match_time":"18:20","home_team":"FC Zieloni","away_team":"Rebelianci"},{"league":"1st","round":13,"match_date":"2026-09-06","match_time":"19:30","home_team":"Legioholicy","away_team":"Lider"},{"league":"1st","round":13,"match_date":"2026-09-07","match_time":"21:00","home_team":"Starszaki","away_team":"1 Warszawska Brygada Pancerna"},{"league":"1st","round":14,"match_date":"2026-09-12","match_time":"19:20","home_team":"FC Zieloni","away_team":"Al Mar Wołomin"},{"league":"1st","round":14,"match_date":"2026-09-13","match_time":"17:10","home_team":"Legioholicy","away_team":"1 Warszawska Brygada Pancerna"},{"league":"1st","round":14,"match_date":"2026-09-13","match_time":"18:20","home_team":"Lider","away_team":"Elo Melo"},{"league":"1st","round":14,"match_date":"2026-09-13","match_time":"19:30","home_team":"Rebelianci","away_team":"Sportowe Zakapiory"},{"league":"1st","round":14,"match_date":"2026-09-14","match_time":"21:00","home_team":"Starszaki","away_team":"Fanatycy"},{"league":"1st","round":15,"match_date":"2026-09-19","match_time":"19:20","home_team":"1 Warszawska Brygada Pancerna","away_team":"Elo Melo"},{"league":"1st","round":15,"match_date":"2026-09-20","match_time":"17:10","home_team":"FC Zieloni","away_team":"Fanatycy"},{"league":"1st","round":15,"match_date":"2026-09-20","match_time":"18:20","home_team":"Lider","away_team":"Rebelianci"},{"league":"1st","round":15,"match_date":"2026-09-20","match_time":"19:30","home_team":"Sportowe Zakapiory","away_team":"Al Mar Wołomin"},{"league":"1st","round":15,"match_date":"2026-09-21","match_time":"21:00","home_team":"Starszaki","away_team":"Legioholicy"},{"league":"1st","round":16,"match_date":"2026-09-26","match_time":"19:20","home_team":"Al Mar Wołomin","away_team":"Lider"},{"league":"1st","round":16,"match_date":"2026-09-27","match_time":"17:10","home_team":"Elo Melo","away_team":"Legioholicy"},{"league":"1st","round":16,"match_date":"2026-09-27","match_time":"18:20","home_team":"Rebelianci","away_team":"1 Warszawska Brygada Pancerna"},{"league":"1st","round":16,"match_date":"2026-09-27","match_time":"19:30","home_team":"Sportowe Zakapiory","away_team":"Fanatycy"},{"league":"1st","round":16,"match_date":"2026-09-28","match_time":"21:00","home_team":"Starszaki","away_team":"FC Zieloni"},{"league":"1st","round":17,"match_date":"2026-10-03","match_time":"19:20","home_team":"1 Warszawska Brygada Pancerna","away_team":"Al Mar Wołomin"},{"league":"1st","round":17,"match_date":"2026-10-04","match_time":"17:10","home_team":"Elo Melo","away_team":"Starszaki"},{"league":"1st","round":17,"match_date":"2026-10-04","match_time":"18:20","home_team":"Fanatycy","away_team":"Lider"},{"league":"1st","round":17,"match_date":"2026-10-04","match_time":"19:30","home_team":"Legioholicy","away_team":"Rebelianci"},{"league":"1st","round":17,"match_date":"2026-10-05","match_time":"21:00","home_team":"Sportowe Zakapiory","away_team":"FC Zieloni"},{"league":"1st","round":18,"match_date":"2026-10-10","match_time":"19:20","home_team":"Elo Melo","away_team":"Rebelianci"},{"league":"1st","round":18,"match_date":"2026-10-11","match_time":"17:10","home_team":"Fanatycy","away_team":"1 Warszawska Brygada Pancerna"},{"league":"1st","round":18,"match_date":"2026-10-11","match_time":"18:20","home_team":"Legioholicy","away_team":"Al Mar Wołomin"},{"league":"1st","round":18,"match_date":"2026-10-11","match_time":"19:30","home_team":"Lider","away_team":"FC Zieloni"},{"league":"1st","round":18,"match_date":"2026-10-12","match_time":"21:00","home_team":"Sportowe Zakapiory","away_team":"Starszaki"},{"league":"1st","round":19,"match_date":"2026-10-17","match_time":"19:20","home_team":"Al Mar Wołomin","away_team":"Elo Melo"},{"league":"1st","round":19,"match_date":"2026-10-18","match_time":"17:10","home_team":"FC Zieloni","away_team":"1 Warszawska Brygada Pancerna"},{"league":"1st","round":19,"match_date":"2026-10-18","match_time":"18:20","home_team":"Legioholicy","away_team":"Fanatycy"},{"league":"1st","round":19,"match_date":"2026-10-18","match_time":"19:30","home_team":"Rebelianci","away_team":"Starszaki"},{"league":"1st","round":19,"match_date":"2026-10-19","match_time":"21:00","home_team":"Sportowe Zakapiory","away_team":"Lider"},{"league":"1st","round":20,"match_date":"2026-10-24","match_time":"19:20","home_team":"Al Mar Wołomin","away_team":"Rebelianci"},{"league":"1st","round":20,"match_date":"2026-10-25","match_time":"17:10","home_team":"Fanatycy","away_team":"Elo Melo"},{"league":"1st","round":20,"match_date":"2026-10-25","match_time":"18:20","home_team":"Legioholicy","away_team":"FC Zieloni"},{"league":"1st","round":20,"match_date":"2026-10-25","match_time":"19:30","home_team":"Lider","away_team":"Starszaki"},{"league":"1st","round":20,"match_date":"2026-10-26","match_time":"21:00","home_team":"Sportowe Zakapiory","away_team":"1 Warszawska Brygada Pancerna"},{"league":"2nd","round":10,"match_date":"2026-09-05","match_time":"18:10","home_team":"Faludża","away_team":"STM FC"},{"league":"2nd","round":10,"match_date":"2026-09-06","match_time":"13:40","home_team":"FC Ślimak Halinów","away_team":"Tidy Team"},{"league":"2nd","round":10,"match_date":"2026-09-06","match_time":"14:50","home_team":"Gosuansa","away_team":"PJM"},{"league":"2nd","round":10,"match_date":"2026-09-06","match_time":"16:00","home_team":"RKS Pendrachy","away_team":"Rayo Vallerano"},{"league":"2nd","round":10,"match_date":"2026-09-07","match_time":"19:50","home_team":"Tiger Wołomin","away_team":"Joga Finito"},{"league":"2nd","round":11,"match_date":"2026-09-12","match_time":"18:10","home_team":"FC Ślimak Halinów","away_team":"Faludża"},{"league":"2nd","round":11,"match_date":"2026-09-13","match_time":"13:40","home_team":"Joga Finito","away_team":"Gosuansa"},{"league":"2nd","round":11,"match_date":"2026-09-13","match_time":"14:50","home_team":"PJM","away_team":"STM FC"},{"league":"2nd","round":11,"match_date":"2026-09-13","match_time":"16:00","home_team":"Rayo Vallerano","away_team":"Tidy Team"},{"league":"2nd","round":11,"match_date":"2026-09-14","match_time":"19:50","home_team":"RKS Pendrachy","away_team":"Detox"},{"league":"2nd","round":12,"match_date":"2026-09-19","match_time":"18:10","home_team":"Faludża","away_team":"Tidy Team"},{"league":"2nd","round":12,"match_date":"2026-09-20","match_time":"13:40","home_team":"FC Ślimak Halinów","away_team":"PJM"},{"league":"2nd","round":12,"match_date":"2026-09-20","match_time":"14:50","home_team":"Rayo Vallerano","away_team":"Detox"},{"league":"2nd","round":12,"match_date":"2026-09-20","match_time":"16:00","home_team":"STM FC","away_team":"Joga Finito"},{"league":"2nd","round":12,"match_date":"2026-09-21","match_time":"19:50","home_team":"Tiger Wołomin","away_team":"RKS Pendrachy"},{"league":"2nd","round":13,"match_date":"2026-09-26","match_time":"18:10","home_team":"Detox","away_team":"Tidy Team"},{"league":"2nd","round":13,"match_date":"2026-09-27","match_time":"13:40","home_team":"Faludża","away_team":"PJM"},{"league":"2nd","round":13,"match_date":"2026-09-27","match_time":"14:50","home_team":"FC Ślimak Halinów","away_team":"Joga Finito"},{"league":"2nd","round":13,"match_date":"2026-09-27","match_time":"16:00","home_team":"Gosuansa","away_team":"RKS Pendrachy"},{"league":"2nd","round":13,"match_date":"2026-09-28","match_time":"19:50","home_team":"Rayo Vallerano","away_team":"Tiger Wołomin"},{"league":"2nd","round":14,"match_date":"2026-10-03","match_time":"18:10","home_team":"Detox","away_team":"Tiger Wołomin"},{"league":"2nd","round":14,"match_date":"2026-10-04","match_time":"13:40","home_team":"Faludża","away_team":"Joga Finito"},{"league":"2nd","round":14,"match_date":"2026-10-04","match_time":"14:50","home_team":"Rayo Vallerano","away_team":"Gosuansa"},{"league":"2nd","round":14,"match_date":"2026-10-04","match_time":"16:00","home_team":"STM FC","away_team":"RKS Pendrachy"},{"league":"2nd","round":14,"match_date":"2026-10-05","match_time":"19:50","home_team":"Tidy Team","away_team":"PJM"},{"league":"2nd","round":15,"match_date":"2026-10-10","match_time":"18:10","home_team":"FC Ślimak Halinów","away_team":"RKS Pendrachy"},{"league":"2nd","round":15,"match_date":"2026-10-11","match_time":"13:40","home_team":"Gosuansa","away_team":"Detox"},{"league":"2nd","round":15,"match_date":"2026-10-11","match_time":"14:50","home_team":"Joga Finito","away_team":"PJM"},{"league":"2nd","round":15,"match_date":"2026-10-11","match_time":"16:00","home_team":"Rayo Vallerano","away_team":"STM FC"},{"league":"2nd","round":15,"match_date":"2026-10-12","match_time":"19:50","home_team":"Tiger Wołomin","away_team":"Tidy Team"},{"league":"2nd","round":16,"match_date":"2026-10-17","match_time":"18:10","home_team":"Detox","away_team":"STM FC"},{"league":"2nd","round":16,"match_date":"2026-10-18","match_time":"13:40","home_team":"Faludża","away_team":"RKS Pendrachy"},{"league":"2nd","round":16,"match_date":"2026-10-18","match_time":"14:50","home_team":"Gosuansa","away_team":"Tiger Wołomin"},{"league":"2nd","round":16,"match_date":"2026-10-18","match_time":"16:00","home_team":"Rayo Vallerano","away_team":"FC Ślimak Halinów"},{"league":"2nd","round":16,"match_date":"2026-10-19","match_time":"19:50","home_team":"Tidy Team","away_team":"Joga Finito"},{"league":"2nd","round":17,"match_date":"2026-10-24","match_time":"18:10","home_team":"Detox","away_team":"FC Ślimak Halinów"},{"league":"2nd","round":17,"match_date":"2026-10-25","match_time":"13:40","home_team":"Faludża","away_team":"Rayo Vallerano"},{"league":"2nd","round":17,"match_date":"2026-10-25","match_time":"14:50","home_team":"RKS Pendrachy","away_team":"PJM"},{"league":"2nd","round":17,"match_date":"2026-10-25","match_time":"16:00","home_team":"Tidy Team","away_team":"Gosuansa"},{"league":"2nd","round":17,"match_date":"2026-10-26","match_time":"19:50","home_team":"Tiger Wołomin","away_team":"STM FC"},{"league":"2nd","round":18,"match_date":"2026-11-07","match_time":"18:10","home_team":"Faludża","away_team":"Detox"},{"league":"2nd","round":18,"match_date":"2026-11-08","match_time":"13:40","home_team":"PJM","away_team":"Rayo Vallerano"},{"league":"2nd","round":18,"match_date":"2026-11-08","match_time":"14:50","home_team":"RKS Pendrachy","away_team":"Joga Finito"},{"league":"2nd","round":18,"match_date":"2026-11-08","match_time":"16:00","home_team":"STM FC","away_team":"Gosuansa"},{"league":"2nd","round":18,"match_date":"2026-11-09","match_time":"19:50","home_team":"Tiger Wołomin","away_team":"FC Ślimak Halinów"},{"league":"2nd","round":19,"match_date":"2026-11-14","match_time":"18:10","home_team":"Detox","away_team":"PJM"},{"league":"2nd","round":19,"match_date":"2026-11-15","match_time":"13:40","home_team":"Faludża","away_team":"Tiger Wołomin"},{"league":"2nd","round":19,"match_date":"2026-11-15","match_time":"14:50","home_team":"Gosuansa","away_team":"FC Ślimak Halinów"},{"league":"2nd","round":19,"match_date":"2026-11-15","match_time":"16:00","home_team":"Joga Finito","away_team":"Rayo Vallerano"},{"league":"2nd","round":19,"match_date":"2026-11-16","match_time":"19:50","home_team":"Tidy Team","away_team":"STM FC"},{"league":"2nd","round":20,"match_date":"2026-11-21","match_time":"18:10","home_team":"Faludża","away_team":"Gosuansa"},{"league":"2nd","round":20,"match_date":"2026-11-22","match_time":"13:40","home_team":"Joga Finito","away_team":"Detox"},{"league":"2nd","round":20,"match_date":"2026-11-22","match_time":"14:50","home_team":"STM FC","away_team":"FC Ślimak Halinów"},{"league":"2nd","round":20,"match_date":"2026-11-22","match_time":"16:00","home_team":"Tidy Team","away_team":"RKS Pendrachy"},{"league":"2nd","round":20,"match_date":"2026-11-23","match_time":"19:50","home_team":"Tiger Wołomin","away_team":"PJM"}]$fixtures$::jsonb)
  as x(
    league text,
    round integer,
    match_date date,
    match_time time,
    home_team text,
    away_team text
  )
cross join public.seasons s
join public.leagues l on l.code = x.league
join public.teams ht on ht.name = x.home_team
join public.teams at on at.name = x.away_team
where s.year = 2026;

create temp table mlpn_match_plan on commit drop as
select d.*, picked.id as match_id
from mlpn_desired_schedule d
left join lateral (
  select m.id
  from public.matches m
  where m.season_id = d.season_id
    and m.league_id = d.league_id
    and m.round >= case when d.league_code = '1st' then 12 else 10 end
    and m.id not in (
      '34ca790c-9128-48ce-9c74-8c18f069e9f1'::uuid,
      '2a9b5cde-310b-4f5f-adb3-7986658d33d8'::uuid
    )
    and least(m.home_team_id::text, m.away_team_id::text) || '::' ||
        greatest(m.home_team_id::text, m.away_team_id::text) = d.pair_key
    and m.status in ('scheduled', 'postponed', 'cancelled')
  order by m.round, m.match_date, m.match_time, m.id
  limit 1
) picked on true;

create temp table mlpn_delete_ids on commit drop as
select m.id
from public.matches m
join public.seasons s on s.id = m.season_id and s.year = 2026
join public.leagues l on l.id = m.league_id
where (
    (l.code = '1st' and m.round >= 12)
    or
    (l.code = '2nd' and m.round >= 10)
  )
  and m.id not in (
    '34ca790c-9128-48ce-9c74-8c18f069e9f1'::uuid,
    '2a9b5cde-310b-4f5f-adb3-7986658d33d8'::uuid
  )
  and not exists (
    select 1 from mlpn_match_plan p where p.match_id = m.id
  );

do $checks_before$
declare
  v_match_fingerprint text;
  v_membership_fingerprint text;
  v_count bigint;
  v_refs bigint;
begin
  select md5(coalesce(string_agg(
    concat_ws('|',m.id,m.season_id,m.league_id,m.round,m.home_team_id,m.away_team_id,
      coalesce(m.match_date::text,''),coalesce(m.match_time::text,''),m.status,
      coalesce(m.home_goals::text,''),coalesce(m.away_goals::text,''),coalesce(m.notes,'')
    ), E'\n' order by m.id::text),''))
  into v_match_fingerprint
  from public.matches m
  join public.seasons s on s.id=m.season_id and s.year=2026
  join public.leagues l on l.id=m.league_id
  where (
      (l.code='1st' and m.round>=12)
      or (l.code='2nd' and m.round>=10)
      or m.id in (
        '3b9167d4-331a-42ce-9b6e-37706b4934c0'::uuid,
        '316c2f14-5539-4212-b3a2-552aa0145750'::uuid
      )
    );

  if v_match_fingerprint <> 'dab8e1edbaef5e8b6e7f4370ea2bba3c' then
    raise exception 'Terminarz zmienil sie od audytu (fingerprint: %). Przerwano bez zapisu.',
      v_match_fingerprint;
  end if;

  select md5(coalesce(string_agg(
    concat_ws('|',st.id,st.season_id,st.league_id,st.team_id,st.joined_round,
      coalesce(st.left_round::text,''),st.join_reason
    ), E'\n' order by st.id::text),''))
  into v_membership_fingerprint
  from public.season_teams st
  join public.seasons s on s.id=st.season_id and s.year=2026
  join public.leagues l on l.id=st.league_id and l.code in ('1st','2nd');

  if v_membership_fingerprint <> '75c9d3e7acbaf8eebb947776e5a2746e' then
    raise exception 'Sklady lig zmienily sie od audytu (fingerprint: %). Przerwano bez zapisu.',
      v_membership_fingerprint;
  end if;

  select count(*) into v_count from mlpn_desired_schedule;
  if v_count <> 100 then
    raise exception 'Plan ma % rekordow zamiast 100.', v_count;
  end if;

  if exists (
    select 1 from mlpn_desired_schedule
    where season_id is null or league_id is null or home_team_id is null or away_team_id is null
  ) then
    raise exception 'Nie rozwiazano wszystkich identyfikatorow planu.';
  end if;

  if (select count(*) from mlpn_desired_schedule where league_code='1st') <> 45
     or (select count(distinct pair_key) from mlpn_desired_schedule where league_code='1st') <> 45
     or (select count(*) from mlpn_desired_schedule where league_code='2nd') <> 55
     or (select count(distinct pair_key) from mlpn_desired_schedule where league_code='2nd') <> 55 then
    raise exception 'Nieprawidlowa liczba par w planie.';
  end if;

  if exists (
    select 1
    from mlpn_desired_schedule
    group by league_code, round
    having count(*) <> 5
  ) then
    raise exception 'Co najmniej jedna kolejka nie ma dokladnie 5 meczow.';
  end if;

  if exists (
    select 1
    from (
      select league_code, round, home_team as team from mlpn_desired_schedule
      union all
      select league_code, round, away_team from mlpn_desired_schedule
    ) q
    group by league_code, round, team
    having count(*) > 1
  ) then
    raise exception 'Druzyna wystepuje wiecej niz raz w tej samej kolejce.';
  end if;

  if (select count(*) from mlpn_match_plan where match_id is not null) <> 81
     or (select count(*) from mlpn_match_plan where league_code='1st' and match_id is not null) <> 45
     or (select count(*) from mlpn_match_plan where league_code='2nd' and match_id is not null) <> 36
     or (select count(*) from mlpn_match_plan where match_id is null) <> 19 then
    raise exception 'Mapowanie ID nie zgadza sie z audytem.';
  end if;

  if (select count(*) from mlpn_delete_ids) <> 19 then
    raise exception 'Do usuniecia wybrano % rekordow zamiast 19.',
      (select count(*) from mlpn_delete_ids);
  end if;

  if (select count(*)
      from mlpn_delete_ids d
      join public.matches m on m.id=d.id
      join public.teams ht on ht.id=m.home_team_id
      join public.teams at on at.id=m.away_team_id
      where ht.name='Oldrembham Forest' or at.name='Oldrembham Forest') <> 10 then
    raise exception 'Lista usuniec nie zawiera dokladnie 10 rewanzow Oldrembham.';
  end if;

  if (select count(*)
      from mlpn_delete_ids d
      join public.matches m on m.id=d.id
      join public.teams ht on ht.id=m.home_team_id
      join public.teams at on at.id=m.away_team_id
      where ht.name='Nankatsu' or at.name='Nankatsu') <> 9 then
    raise exception 'Lista usuniec nie zawiera dokladnie 9 rewanzow Nankatsu.';
  end if;

  select coalesce(sum(dep_count),0) into v_refs
  from (
    select count(*)::bigint dep_count from public.active_match_assignments where match_id in (select id from mlpn_delete_ids)
    union all select count(*) from public.gallery_albums where match_id in (select id from mlpn_delete_ids)
    union all select count(*) from public.match_events where match_id in (select id from mlpn_delete_ids)
    union all select count(*) from public.match_lineups where match_id in (select id from mlpn_delete_ids)
    union all select count(*) from public.match_result_edits where match_id in (select id from mlpn_delete_ids)
    union all select count(*) from public.news where related_match_id in (select id from mlpn_delete_ids)
    union all select count(*) from public.typer_aggregates where match_id in (select id from mlpn_delete_ids)
    union all select count(*) from public.typer_predictions where match_id in (select id from mlpn_delete_ids)
    union all select count(*) from public.typer_round_config_matches where match_id in (select id from mlpn_delete_ids)
  ) deps;

  if v_refs <> 0 then
    raise exception 'Rekordy do usuniecia maja % powiazan. Przerwano bez zapisu.', v_refs;
  end if;

  if (select count(*) from mlpn_desired_schedule
      where league_code='2nd' and round=10
        and home_team='FC Ślimak Halinów' and away_team='Tidy Team') <> 1 then
    raise exception 'Brak wymaganego meczu Slimak - Tidy w K10.';
  end if;

  if exists (
    select 1 from mlpn_desired_schedule
    where league_code='2nd' and round=17
      and (home_team='Joga Finito' or away_team='Joga Finito')
  ) then
    raise exception 'Joga Finito nie pauzuje w K17.';
  end if;

  if not exists (
    select 1 from mlpn_match_plan
    where match_id='73bed1d3-7159-41be-8ec9-ae4483e81e7d'::uuid
      and round=11 and home_team='PJM' and away_team='STM FC'
  ) then
    raise exception 'Rewanz PJM - STM nie zachowuje wymaganego ID.';
  end if;

  if not exists (
    select 1 from mlpn_match_plan
    where match_id='48b8b90d-5a8c-4817-a6bb-a082a2c75a95'::uuid
  ) then
    raise exception 'Chroniony rekord Starszaki - FC Zieloni nie zachowuje ID.';
  end if;
end
$checks_before$;

update public.season_teams st
set left_round = case t.name
  when 'Oldrembham Forest' then 12
  when 'Nankatsu' then 10
end
from public.teams t, public.seasons s
where st.team_id=t.id
  and st.season_id=s.id
  and s.year=2026
  and t.name in ('Oldrembham Forest','Nankatsu');

insert into public.season_teams (
  season_id, league_id, team_id, joined_round, left_round, join_reason
)
select
  s.id,
  l.id,
  t.id,
  10,
  null,
  'mid_season_join'
from public.seasons s
cross join public.leagues l
join public.teams t on t.name in ('FC Ślimak Halinów','Rayo Vallerano')
where s.year=2026 and l.code='2nd';

update public.matches
set match_date=date '2026-08-25', match_time=time '19:40', updated_at=now()
where id='3b9167d4-331a-42ce-9b6e-37706b4934c0'::uuid;

update public.matches
set match_date=date '2026-08-25', match_time=time '20:50', updated_at=now()
where id='316c2f14-5539-4212-b3a2-552aa0145750'::uuid;

update public.matches
set round=7, match_date=date '2026-09-02', match_time=time '19:20',
    status='scheduled', home_goals=null, away_goals=null,
    notes='[MLPN_SCHEDULE_HIDDEN]', updated_at=now()
where id='34ca790c-9128-48ce-9c74-8c18f069e9f1'::uuid;

update public.matches
set round=7, match_date=date '2026-09-02', match_time=time '18:10',
    status='walkover_home', home_goals=3, away_goals=0,
    video_url=null, gallery_url=null, referee=null, referee_id=null,
    mvp_player_id=null, notes=null, updated_at=now()
where id='2a9b5cde-310b-4f5f-adb3-7986658d33d8'::uuid;

delete from public.matches m
using mlpn_delete_ids d
where m.id=d.id;

update public.matches m
set
  round=p.round,
  home_team_id=p.home_team_id,
  away_team_id=p.away_team_id,
  match_date=p.match_date,
  match_time=p.match_time,
  status='scheduled',
  home_goals=null,
  away_goals=null,
  video_url=null,
  gallery_url=null,
  referee=null,
  referee_id=null,
  mvp_player_id=null,
  notes='[MLPN_SCHEDULE_HIDDEN]',
  updated_at=now()
from mlpn_match_plan p
where p.match_id=m.id;

insert into public.matches (
  season_id, league_id, round, home_team_id, away_team_id,
  match_date, match_time, status, notes
)
select
  season_id, league_id, round, home_team_id, away_team_id,
  match_date, match_time, 'scheduled', '[MLPN_SCHEDULE_HIDDEN]'
from mlpn_match_plan
where match_id is null;

update public.season_leagues sl
set total_rounds=20, updated_at=now()
from public.seasons s, public.leagues l
where sl.season_id=s.id
  and sl.league_id=l.id
  and s.year=2026
  and l.code in ('1st','2nd');

do $checks_after$
declare
  v_season_id uuid;
  v_first_league_id uuid;
  v_second_league_id uuid;
  v_oldrembham_id uuid;
  v_nankatsu_id uuid;
  v_rks_id uuid;
  v_count bigint;
begin
  select id into v_season_id from public.seasons where year=2026;
  select id into v_first_league_id from public.leagues where code='1st';
  select id into v_second_league_id from public.leagues where code='2nd';
  select id into v_oldrembham_id from public.teams where name='Oldrembham Forest';
  select id into v_nankatsu_id from public.teams where name='Nankatsu';
  select id into v_rks_id from public.teams where name='RKS Pendrachy';

  if (select count(*) from public.season_teams
      where season_id=v_season_id and league_id=v_first_league_id) <> 11
     or (select count(*) from public.season_teams
         where season_id=v_season_id and league_id=v_second_league_id) <> 13 then
    raise exception 'Nieprawidlowa historyczna liczba wpisow season_teams.';
  end if;

  if (select count(*) from public.season_teams
      where season_id=v_season_id and league_id=v_first_league_id
        and joined_round<=12 and (left_round is null or left_round>12)) <> 10
     or (select count(*) from public.season_teams
         where season_id=v_season_id and league_id=v_second_league_id
           and joined_round<=10 and (left_round is null or left_round>10)) <> 11 then
    raise exception 'Nieprawidlowa liczba aktywnych druzyn.';
  end if;

  if not exists (
    select 1 from public.season_teams st join public.teams t on t.id=st.team_id
    where st.season_id=v_season_id and t.name='Oldrembham Forest' and st.left_round=12
  ) or not exists (
    select 1 from public.season_teams st join public.teams t on t.id=st.team_id
    where st.season_id=v_season_id and t.name='Nankatsu' and st.left_round=10
  ) then
    raise exception 'Nie zapisano oznaczen wycofania.';
  end if;

  if (select count(*)
      from public.season_teams st join public.teams t on t.id=st.team_id
      where st.season_id=v_season_id and st.league_id=v_second_league_id
        and t.name in ('FC Ślimak Halinów','Rayo Vallerano')
        and st.joined_round=10 and st.left_round is null
        and st.join_reason='mid_season_join') <> 2 then
    raise exception 'Nie zapisano obu nowych druzyn II ligi.';
  end if;

  if (select count(*) from public.matches
      where season_id=v_season_id and league_id=v_first_league_id and round between 12 and 20) <> 45
     or exists (
       select 1 from public.matches
       where season_id=v_season_id and league_id=v_first_league_id and round>20
     ) then
    raise exception 'Finalny etap I ligi nie ma dokladnie 45 meczow K12-K20.';
  end if;

  if (select count(*) from public.matches
      where season_id=v_season_id and league_id=v_second_league_id and round between 10 and 20) <> 55
     or exists (
       select 1 from public.matches
       where season_id=v_season_id and league_id=v_second_league_id and round>20
     ) then
    raise exception 'Finalny etap II ligi nie ma dokladnie 55 meczow K10-K20.';
  end if;

  select count(*) into v_count
  from mlpn_desired_schedule d
  join public.matches m
    on m.season_id=d.season_id
   and m.league_id=d.league_id
   and m.round=d.round
   and m.home_team_id=d.home_team_id
   and m.away_team_id=d.away_team_id
   and m.match_date=d.match_date
   and m.match_time=d.match_time
   and m.status='scheduled'
   and m.notes like '%[MLPN_SCHEDULE_HIDDEN]%';

  if v_count <> 100 then
    raise exception 'W bazie zgadza sie % ze 100 planowanych spotkan.', v_count;
  end if;

  if exists (
    select 1
    from public.matches
    where season_id=v_season_id and league_id=v_first_league_id and round between 12 and 20
    group by round
    having count(*)<>5
  ) or exists (
    select 1
    from public.matches
    where season_id=v_season_id and league_id=v_second_league_id and round between 10 and 20
    group by round
    having count(*)<>5
  ) then
    raise exception 'Co najmniej jedna finalna kolejka nie ma 5 meczow.';
  end if;

  if exists (
    select 1 from public.matches
    where season_id=v_season_id and round>=12
      and (home_team_id=v_oldrembham_id or away_team_id=v_oldrembham_id)
  ) or exists (
    select 1 from public.matches
    where season_id=v_season_id and round>=10
      and (home_team_id=v_nankatsu_id or away_team_id=v_nankatsu_id)
  ) then
    raise exception 'Wycofana druzyna nadal ma mecz w nowym etapie.';
  end if;

  if (select count(*) from public.matches
      where season_id=v_season_id
        and (home_team_id=v_oldrembham_id or away_team_id=v_oldrembham_id)
        and status in ('walkover_home','walkover_away')
        and ((home_team_id=v_oldrembham_id and home_goals=0 and away_goals=3)
          or (away_team_id=v_oldrembham_id and home_goals=3 and away_goals=0))) <> 10 then
    raise exception 'Walkowery Oldrembham nie sa kompletne.';
  end if;

  if (select count(*) from public.matches
      where season_id=v_season_id
        and (home_team_id=v_nankatsu_id or away_team_id=v_nankatsu_id)
        and status in ('completed','walkover_home','walkover_away')) <> 9 then
    raise exception 'Nankatsu nie ma dokladnie 9 zweryfikowanych meczow I rundy.';
  end if;

  if not exists (
    select 1 from public.matches
    where id='2a9b5cde-310b-4f5f-adb3-7986658d33d8'::uuid
      and round=7 and match_date=date '2026-09-02' and match_time=time '18:10'
      and home_team_id=v_rks_id and away_team_id=v_nankatsu_id
      and status='walkover_home' and home_goals=3 and away_goals=0 and notes is null
  ) then
    raise exception 'Walkower RKS - Nankatsu jest nieprawidlowy.';
  end if;

  if not exists (
    select 1 from public.matches
    where id='34ca790c-9128-48ce-9c74-8c18f069e9f1'::uuid
      and round=7 and match_date=date '2026-09-02' and match_time=time '19:20'
      and status='scheduled'
  ) or not exists (
    select 1 from public.matches
    where id='a0f80fe6-9292-4222-bad4-ba0d5b8970cd'::uuid
      and round=7 and match_date=date '2026-09-02' and match_time=time '20:30'
      and status='scheduled'
  ) then
    raise exception 'Zalegle mecze 2 wrzesnia sa nieprawidlowe.';
  end if;

  if not exists (
    select 1 from public.matches m
    join public.teams ht on ht.id=m.home_team_id
    join public.teams at on at.id=m.away_team_id
    where m.season_id=v_season_id and m.league_id=v_second_league_id
      and m.round=10 and ht.name='FC Ślimak Halinów' and at.name='Tidy Team'
  ) then
    raise exception 'Brak Slimak - Tidy w K10.';
  end if;

  if exists (
    select 1 from public.matches m
    join public.teams ht on ht.id=m.home_team_id
    join public.teams at on at.id=m.away_team_id
    where m.season_id=v_season_id and m.league_id=v_second_league_id
      and m.round=17 and (ht.name='Joga Finito' or at.name='Joga Finito')
  ) then
    raise exception 'Joga nie pauzuje w K17.';
  end if;

  if not exists (
    select 1 from public.matches m
    join public.teams ht on ht.id=m.home_team_id
    join public.teams at on at.id=m.away_team_id
    where m.id='73bed1d3-7159-41be-8ec9-ae4483e81e7d'::uuid
      and m.round=11 and ht.name='PJM' and at.name='STM FC'
  ) then
    raise exception 'Rewanz PJM - STM stracil ID lub orientacje.';
  end if;

  if exists (
    select 1
    from public.matches a
    join public.matches b
      on a.id<b.id
     and a.match_date=b.match_date
     and a.match_time=b.match_time
    where a.season_id=v_season_id and b.season_id=v_season_id
      and a.status in ('scheduled','postponed','live')
      and b.status in ('scheduled','postponed','live')
      and (a.league_id in (v_first_league_id,v_second_league_id)
        or b.league_id in (v_first_league_id,v_second_league_id))
  ) then
    raise exception 'Nowy terminarz ma fizyczna kolizje boiska.';
  end if;

  if exists (
    with physical_team_days as (
      select m.league_id,m.match_date,m.home_team_id team_id
      from public.matches m
      where m.season_id=v_season_id and m.status in ('scheduled','postponed','live')
      union all
      select m.league_id,m.match_date,m.away_team_id
      from public.matches m
      where m.season_id=v_season_id and m.status in ('scheduled','postponed','live')
    )
    select 1
    from physical_team_days
    where match_date is not null
    group by match_date,team_id
    having count(*)>1
       and bool_or(league_id in (v_first_league_id,v_second_league_id))
  ) then
    raise exception 'Druzyna ma dwa fizyczne mecze tego samego dnia.';
  end if;

  if (select count(*) from public.standings
      where season_id=v_season_id and league_id=v_first_league_id) <> 11
     or (select count(*) from public.standings
         where season_id=v_season_id and league_id=v_second_league_id) <> 13 then
    raise exception 'Tabela nie zawiera wszystkich historycznych druzyn.';
  end if;

  if not exists (
    select 1 from public.standings
    where season_id=v_season_id and league_id=v_second_league_id
      and team_id=v_nankatsu_id and played=9 and points=4
      and goals_for=11 and goals_against=33
  ) then
    raise exception 'Tabela Nankatsu nie zostala prawidlowo przeliczona.';
  end if;
end
$checks_after$;

commit;

select jsonb_build_object(
  'season', 2026,
  'status', 'applied',
  'memberships', jsonb_build_object(
    'oldrembham_left_round', (
      select st.left_round from public.season_teams st
      join public.seasons s on s.id=st.season_id
      join public.teams t on t.id=st.team_id
      where s.year=2026 and t.name='Oldrembham Forest'
    ),
    'nankatsu_left_round', (
      select st.left_round from public.season_teams st
      join public.seasons s on s.id=st.season_id
      join public.teams t on t.id=st.team_id
      where s.year=2026 and t.name='Nankatsu'
    ),
    'second_league_active', (
      select count(*) from public.season_teams st
      join public.seasons s on s.id=st.season_id
      join public.leagues l on l.id=st.league_id
      where s.year=2026 and l.code='2nd'
        and st.joined_round<=10 and (st.left_round is null or st.left_round>10)
    )
  ),
  'stage_matches', jsonb_build_object(
    'first_league', (
      select count(*) from public.matches m
      join public.seasons s on s.id=m.season_id
      join public.leagues l on l.id=m.league_id
      where s.year=2026 and l.code='1st' and m.round between 12 and 20
    ),
    'second_league', (
      select count(*) from public.matches m
      join public.seasons s on s.id=m.season_id
      join public.leagues l on l.id=m.league_id
      where s.year=2026 and l.code='2nd' and m.round between 10 and 20
    )
  ),
  'walkovers', jsonb_build_object(
    'oldrembham', (
      select count(*) from public.matches m
      join public.seasons s on s.id=m.season_id
      join public.teams ht on ht.id=m.home_team_id
      join public.teams at on at.id=m.away_team_id
      where s.year=2026 and (ht.name='Oldrembham Forest' or at.name='Oldrembham Forest')
        and m.status in ('walkover_home','walkover_away')
    ),
    'nankatsu', (
      select count(*) from public.matches m
      join public.seasons s on s.id=m.season_id
      join public.teams ht on ht.id=m.home_team_id
      join public.teams at on at.id=m.away_team_id
      where s.year=2026 and (ht.name='Nankatsu' or at.name='Nankatsu')
        and m.status in ('walkover_home','walkover_away')
    )
  )
) as result;
