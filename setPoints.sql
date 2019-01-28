update games ax 
set points = 1
from games b 
where ax.season=b.season and ax.gameweek=b.gameweek and ax.gameno=b.gameno
and ax.team!=b.team and ax.goal=b.goal;
select * from games order by (season,gameweek,gameno)
