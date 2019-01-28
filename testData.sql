with t as 
      (select season,gameweek,gameno,tname,team,position,goal,points 
      from games 
      where gameweek = %s and season=%s ),
     d as 
       (select t.gameno,t.team,t.tname,l.form as lf,tot.form as tf,t.position as pos, l.txS, lo.txc, t.goal as g,t.points as p 
       from t,
            (select tname,sum(points) as form,avg(xg) as txS 
            from (select ga.gameweek,ga.gameno,ga.tname,ga.points,ga.xg,row_number() over(partition by ga.tname order by ga.gameweek desc,ga.gameno desc ) as rn 
                  from games ga,t  
                  where ga.gameweek<t.gameweek and ga.tname=t.tname and ga.team=t.team and ga.season=t.season) as a 
             where rn<=5 group by tname) as l,
             
             (select tname,avg(xg) as txc 
             from (select ga.gameweek,ga.gameno,gb.tname,ga.xg,row_number() over(partition by gb.tname order by ga.gameweek desc,ga.gameno desc ) as rn 
                  from games ga,games gb, t  
                  where gb.gameweek<t.gameweek and gb.tname=t.tname and gb.team=t.team and ga.gameweek=gb.gameweek and ga.gameno=gb.gameno and ga.team!=gb.team and ga.season=gb.season and gb.season=t.season) as a 
             where rn<=5 group by tname) as lo,
             
             (select tname,sum(points) as form 
             from (select ga.gameweek,ga.gameno,ga.tname,ga.points,row_number() over(partition by ga.tname order by ga.gameweek desc,ga.gameno desc ) as rn 
                  from games ga,t  
                  where ga.gameweek<t.gameweek and ga.tname=t.tname and ga.season=t.season) as a 
             where rn<=5 group by tname) as tot 
          
         where t.tname=l.tname and t.tname=tot.tname and t.tname=lo.tname order by gameno,team desc) , 
       glist as 
         (select a.gameno,a.tname as h,b.tname as a,(a.goal,b.goal) as sRes,a.points as pres 
         from games a,games b 
         where a.gameweek=b.gameweek and a.gameno=b.gameno and a.team='H' and b.team='A' and a.gameweek=%s and a.season=b.season and a.season=%s)
         
select glist.gameno, glist.h,glist.a,coalesce(a.hlf,0),coalesce(a.htf,0),coalesce(a.hpos,0),coalesce(a.htxs,0),coalesce(a.htxc,0),coalesce(a.alf,0),coalesce( a.atf,0),coalesce(a.apos,0),coalesce(a.atxs,0),coalesce(a.atxc,0),glist.sRes,glist.pres 
from glist 
left join(select h.gameno, h.tname as hn, a.tname as an, h.lf as hlf, h.tf as htf,h.pos as hpos,h.txs as htxs,h.txc as htxc,a.lf as alf, a.tf as atf,a.pos as apos,a.txs as atxs,a.txc as atxc 
          from d as h, d as a 
          where h.gameno=a.gameno and h.team='H'and a.team='A' order by gameno) as a 
      on glist.gameno=a.gameno and glist.h=a.hn and glist.a=a.an order by glist.gameno
