import psycopg2
import matplotlib.pyplot as plt

def calcfinish(teams,season,week,xgtype):
    conn = psycopg2.connect(config)

    cur = conn.cursor()

    totpoints=[0] * 20

    finishes =[[0 for i in range (20)]for j in range(20)]
    points = [(1,1),(3,0),(0,3)]
    for r in range(0,1000):
        cpoints =[0]*20
        for i in range(1,week+1):
            cur.execute("select max(gameno) from games where season=%s and gameweek=%s ",(season,i,))
            max = cur.fetchone()[0]
            #print(max)
            for j in range(1,max+1):
        
                
                if xgtype=='shot':
                    cur.execute("select time,xg from shots where season=%s and gameweek=%s and gameno=%s and team='H'",(season,i,j,))
                    H = cur.fetchall()
                    cur.execute("select time,xg from shots where season=%s and gameweek=%s and gameno=%s and team='A'",(season,i,j,))
                    A = cur.fetchall()
                    x = resultProb(H,A)
                    p = choices(points,x)[0]
                if xgtype=='overall':
                    cur.execute("select xg from games where season=%s and gameweek=%s and gameno=%s and team='H'",(season,i,j,))
                    H = cur.fetchall()
                    cur.execute("select xg from games where season=%s and gameweek=%s and gameno=%s and team='A'",(season,i,j,))
                    A = cur.fetchall()
                    
                    gd = np.random.poisson(H)[0][0]-np.random.poisson(A)[0][0]
                    
                    p = points[np.sign(gd)]
                #print(x)
                
            
                cur.execute("select tname from games where season=%s and gameweek=%sand gameno=%s order by team desc",(season,i,j,))
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
    return finishes
