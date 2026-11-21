-- Read-only verification for Księga MLPN. Snapshot: 2026-11-21.
-- No mutation, migration or credentials. Registration is not proof of appearance.
-- Match goal rankings exclude own goals and include only completed games.
-- Historical scoring records must not be inferred from this snapshot.

-- 1. Most distinct seasons in registered squads, with all ties at fifth place.
with totals as (
 select p.id,concat_ws(' ',p.first_name,p.last_name) player,count(distinct s.year)::int seasons,
 array_agg(distinct s.year order by s.year) years
 from public.team_players tp join public.players p on p.id=tp.player_id join public.seasons s on s.id=tp.season_id
 where s.year between 2003 and 2026 group by p.id
), ranked as (select *,rank() over(order by seasons desc) place from totals)
select * from ranked where place <= 5 order by place,player;

-- 2. Most recorded goals by a player in one match, with all ties at fifth place.
with totals as (
 select p.id player_id,concat_ws(' ',p.first_name,p.last_name) player,m.id match_id,m.match_date,
 ht.name home,at.name away,m.home_goals,m.away_goals,count(*)::int goals
 from public.match_events e join public.players p on p.id=e.player_id
 join public.matches m on m.id=e.match_id join public.seasons s on s.id=m.season_id
 join public.teams ht on ht.id=m.home_team_id join public.teams at on at.id=m.away_team_id
 where s.year=2026 and m.status='completed' and e.event_type='GOAL' and not coalesce(e.is_own_goal,false)
 group by p.id,m.id,ht.name,at.name
), ranked as(select *,rank() over(order by goals desc) place from totals)
select * from ranked where place<=5 order by place,match_date,player;

-- 3. Goals, assists and their total in completed matches in 2026.
with contributions as (
 select e.player_id,1 goals,0 assists from public.match_events e join public.matches m on m.id=e.match_id join public.seasons s on s.id=m.season_id
 where s.year=2026 and m.status='completed' and e.event_type='GOAL' and not coalesce(e.is_own_goal,false)
 union all
 select e.assist_player_id,0,1 from public.match_events e join public.matches m on m.id=e.match_id join public.seasons s on s.id=m.season_id
 where s.year=2026 and m.status='completed' and e.event_type='GOAL' and not coalesce(e.is_own_goal,false) and e.assist_player_id is not null
), totals as(select c.player_id,concat_ws(' ',p.first_name,p.last_name) player,sum(goals)::int goals,sum(assists)::int assists,sum(goals+assists)::int total from contributions c join public.players p on p.id=c.player_id group by c.player_id,p.first_name,p.last_name)
select * from totals order by total desc limit 10;

-- 4. Completeness of scorer attribution in played matches (expected: 22, 78).
with scores as (
 select m.id,m.home_goals+m.away_goals result_goals,
 count(e.id) filter(where e.event_type='GOAL') event_goals,
 count(e.id) filter(where e.event_type='GOAL' and e.player_id is not null) named_goals
 from public.matches m join public.seasons s on s.id=m.season_id
 left join public.match_events e on e.match_id=m.id
 where s.year=2026 and m.status='completed' group by m.id
)
select count(*) completed,
 count(*) filter(where event_goals>0) with_events,
 count(*) filter(where result_goals>named_goals) incomplete_names,
 sum(greatest(0,result_goals-named_goals)) unnamed_goals
from scores;

-- 5. Why career scoring records cannot yet be trusted (expected: 1586).
-- This diagnostic is restricted to completed matches, not administrative scores.
with totals as (
 select e.match_id,e.player_id,e.team_id,count(*) goals
 from public.match_events e join public.matches m on m.id=e.match_id
 join public.seasons s on s.id=m.season_id
 where s.year between 2004 and 2025 and m.status='completed'
 and e.event_type='GOAL' and not coalesce(e.is_own_goal,false)
 and e.player_id is not null
 group by e.match_id,e.player_id,e.team_id
)
select count(*) overcounts from totals t join public.matches m on m.id=t.match_id
where t.goals > case when t.team_id=m.home_team_id then m.home_goals
 when t.team_id=m.away_team_id then m.away_goals end;
