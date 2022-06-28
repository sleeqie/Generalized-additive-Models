import pandas as pd
import numpy as np

#ARRAY OF PROCESSES
array = np.array ([ ['Baking'], ['Drying'], ['Microwave drying'], ['Freeze drying'], ['Milling'], 
                   ['Extrusion'], ['Sterilization'],['Pasteurization'] , ['Freezing 20C'], 
                   ['Freezing 30C'], ['Wet fraction'], ['Cutting'], ['Slicing'], 
                    ['Separation and washing'], ['Blanching'], 
                    ['Wet fractionation'], ['Cooling']]) 


df = pd.DataFrame (array, columns = ['Processing'])

df.head()

def funct1(array):
    call = input().title().strip()
    if (call == 'Baking') or (call == 'Drying') or (call == 'Microwave Drying') or (call == 'Freeze Drying'):
        array = np.delete(array,10)
        
    elif (call == 'Milling'):
        array = np.delete(array,(11,12))

    elif (call == 'Sterilization') or (call == 'Pasteurization'):
        array = np.delete(array,(14))
    for element in array: 
                print(element)

def funct2(array):
    call = input().title().strip()
    if (call == 'Sterilization'):
        array[[2, 7]] = array[[7, 2]]
        for element in array: 
                print(element)
    elif (call == 'Freezing 20C') or (call == 'Freezing 30C'):
        #array[[2, 7]] = array[[7, 2]]
        for element in array: 
                print(element)





