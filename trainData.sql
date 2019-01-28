with t as 
      (select season,gameweek,gameno,tname,team,position,goal,points 
      from games 
      where gameweek < %s and season=%s ), 
    d as 
      (select t.gameweek,t.gameno,t.team,t.tname,l.form as lf,tot.form as tf,t.position as pos, l.txS, lo.txc, t.goal as g,t.points as p 
      from t, 
          (select g,tname,sum(points) as form,avg(xg) as txS 
           from (select t.gameweek as g,ga.gameweek,ga.gameno,ga.tname,ga.points,ga.xg,row_number() over(partition by t.gameweek,ga.tname order by ga.gameweek desc,ga.gameno desc ) as rn 
                from games ga,t 
                where ga.gameweek<t.gameweek and ga.tname=t.tname and ga.team=t.team and ga.season=t.season) as a 
           where rn<=5 group by g,tname) as l, 
           
          (select g,tname,avg(xg) as txc 
          from (select t.gameweek as g,ga.gameweek,ga.gameno,gb.tname,ga.xg,row_number() over(partition by t.gameweek,gb.tname order by ga.gameweek desc,ga.gameno desc ) as rn 
                from games ga,games gb, t 
                where gb.gameweek<t.gameweek and gb.tname=t.tname and gb.team=t.team and ga.gameweek=gb.gameweek and ga.gameno=gb.gameno and ga.team!=gb.team and ga.season=gb.season and t.season=gb.season) as a 
          where rn<=5 group by g,tname) as lo, 
          
          (select g,tname,sum(points) as form 
          from (select t.gameweek as g,ga.gameweek,ga.gameno,ga.tname,ga.points,row_number() over(partition by t.gameweek,ga.tname order by ga.gameweek desc,ga.gameno desc ) as rn 
                from games ga,t 
                where ga.gameweek<t.gameweek and ga.tname=t.tname and ga.season=t.season) as a 
          where rn<=5 group by g,tname) as tot 
          
      where t.tname=l.tname and t.gameweek = l.g and t.tname=tot.tname and t.gameweek=tot.g and t.tname=lo.tname and t.gameweek=lo.g order by gameno,team desc) 

select h.gameweek,h.gameno, h.tname as hn, a.tname as an, h.lf as hlf, h.tf as htf,h.pos as hpos,h.txs as htxs,h.txc as htxc,a.lf as alf, a.tf as atf,a.pos as apos,a.txs as atxs,a.txc as atxc, (h.g,a.g) as sRes,h.p as oRes 
from d as h, d as a 
where h.gameweek=a.gameweek and h.gameno=a.gameno and h.team='H'and a.team='A' order by gameweek,gameno



    
