from random import choices
import numpy as np

def numGoals(chances):
    i = 0
    numG = []
    tempOld = 0
    tempCur = 0
    for s in chances:
        if i==0:
            numG.append(1-s)
            numG.append(s)
        else:
            tempOld = numG[0]
            #print(tempOld)
            numG[0] = tempOld * (1-s)
            for j in range (1,i+1):
                tempCur = numG[j]
                #print(tempCur)
                numG[j] = tempOld*s + tempCur*(1-s)
                tempOld = tempCur
            numG.append(tempOld*chances[i])
        i = i+1
        #print(numG)
    return numG        


def numGoalsTime(chances):
    if (chances ==[]):
        return[1]
    i = 0
    pgoals = 0
    timeOld = 0
    timeCur = 0
    numG = []
    tempOld = 0
    tempCur = 0
    scored = 0
    notscored = 0
    scoredholding = []
    notscoredholding = []
    timeOld = chances[0][0]
    for (t,p) in chances:
        timeCur = t
        if timeCur != timeOld:
            timeOld = timeCur
            pgoals +=1
            notscored = 1
            scored = 0
            for s in scoredholding:
                notscored = (1-s)*notscored
            scored = 1-notscored
            if pgoals==1:
                numG.append(notscored)
                numG.append(scored)
            else:
                tempOld = numG[0]
                numG[0] = tempOld * notscored
                for j in range (1,pgoals):
                    tempCur = numG[j]
                    #print(tempCur)
                    numG[j] = tempOld*scored + tempCur*notscored
                    tempOld = tempCur    
                numG.append(tempOld*scored)
            scoredholding = []
        scoredholding.append(p)
    if len(scoredholding)>0:
        timeOld = timeCur
        pgoals +=1
        notscored = 1
        scored = 0
        for s in scoredholding:
            notscored = (1-s)*notscored
        scored=1-notscored
        if pgoals==1:
            numG.append(notscored)
            numG.append(scored)
        else:
            tempOld = numG[0]
            numG[0] = tempOld * notscored
            for j in range (1,pgoals):
                tempCur = numG[j]
                #print(tempCur)
                numG[j] = tempOld*scored + tempCur*notscored
                tempOld = tempCur    
            numG.append(tempOld*scored)
        scoredholding = []
    return numG       
    
def scoreProb(T,O):
    #TG = numGoals(T)
    TG = numGoalsTime(T)
    #OG = numGoals(O)
    OG = numGoalsTime(O)
    scores =[]
    for g in TG:
        score = []
        for h in OG:
            score.append(g*h)
        scores.append(score)
    return scores


def resultProb(T,O):
    s = scoreProb(T,O)
    tw = 0
    d = 0
    tl = 0
    i = 0
    j = 0
    for a in s:
        j = 0
        for b in a:
            if i > j:
                tw = tw +b
            if i == j:
                d = d + b
            if i < j:
                tl = tl + b
            j+=1
        i+=1
    return [tw,d,tl]

def exPoint(T,O):
    r = resultProb(T,O)
    e = r[0]*3+r[1]*1+r[2]*0
    return e

