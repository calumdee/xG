import psycopg2
import matplotlib.pyplot as plt

conn = psycopg2.connect(config)

cur = conn.cursor()

totpoints=[0] * 20

finishes =[[0 for i in range (20)]for j in range(20)]
points = [(3,0),(1,1),(0,3)]
for r in range(0,1000):
    cpoints =[0]*20
    for i in range(1,39):
        cur.execute("select max(gameno) from games where season=17 and gameweek=%s ",(i,))
        max = cur.fetchone()[0]
        #print(max)
        for j in range(1,max+1):
    
            cur.execute("select time,xg from shots where season=17 and gameweek=%s and gameno=%s and team='H'",(i,j,))
            H = cur.fetchall()
            cur.execute("select time,xg from shots where season=17 and gameweek=%s and gameno=%s and team='A'",(i,j,))
            A = cur.fetchall()
            x = resultProb(H,A)
            #print(x)
            p = choices(points,x)[0]
            
            cur.execute("select tname from games where season=17 and gameweek=%sand gameno=%s order by team desc",(i,j,))
            tnames = cur.fetchall()
            h = teams.index(tnames[0][0])
            a = teams.index(tnames[1][0])
            
            cpoints[h]+= p[0]
            cpoints[a]+= p[1]

    for i in range(0,20):
        totpoints[i]+=cpoints[i]
    temp =sorted(cpoints)
    pos = [20-temp.index(v) for v in cpoints]
    for i in range(0,20):
        finishes[i][pos[i]-1]+=1

print (finishes)

cur.close()

if conn is not None:
    conn.close()
    print('Database connection closed.')
