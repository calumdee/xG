WITH RECURSIVE t(v) AS (
  SELECT 1     
  UNION ALL
  SELECT v + 1 
  FROM t
  where v<38
)
update games ga set position = x.pos
from 
(select 
a.tname, t.v as played,
row_number() OVER(partition by a.season,t.v ORDER BY sum(a.points) desc, sum(a.goal-b.goal) desc ) as pos
from games a, games b,t
where 
a.season = b.season and a.gameweek=b.gameweek and a.gameno=b.gameno and a.team!=b.team
and a.gameweek<=t.v
group by a.season,a.tname,t.v
order by played, pos) as x
where ga.tname=x.tname and ga.season=x.season and ga.gameweek=played+1
