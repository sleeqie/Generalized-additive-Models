import pandas as pd
import numpy as np

array = np.array ([ ['Baking'], ['Drying'], ['Microwave drying'], ['Freeze drying'], ['Milling'], 
                   ['Extrusion'], ['Sterilization'], ['Pasteurization'], ['Freezing 20c'], 
                   ['Freezing 30c'], ['Wet fraction'], ['Cutting'], ['Slicing'], 
                    ['Separation and washing'], ['Blanching'], 
                    ['Wet fractionation'], ['Cooling']]) 
df = pd.DataFrame (array, columns = ['Processing'])
df.head(4)
# processing = ['Baking', 'Drying', 'Microwave drying', 'Freeze drying']
user_input = input("Enter a process: ").capitalize()
returnList = np.array([])

def first_process(array):
    for processing in array:
        if user_input in processing:
            for element in array:
                if element == 'Wet fraction':
                    combined_array = np.append(returnList, np.delete(array, 10))  
                    return combined_array
        elif user_input == array[4]:
            for element in array:
                if element == 'Slicing' or element == 'Cutting':
                   combined_array = np.append(returnList, np.delete(array, [11,12]))  
            return combined_array
        elif user_input == array[5]:
            for element in array:
                if element == 'Separation and washing' or element == 'Blanching' or element == 'Cutting' or element == 'Slicing' or element == 'Milling' or element == 'Wet fractionation':
                    combined_array = np.append(returnList, np.delete(array, [4, 11, 12, 13, 14]))
            return combined_array
        elif user_input == array[7]:
            for element in array:
                if element == 'Blanching':
                    combined_array = np.append(returnList, np.delete(array, [14]))  
            return combined_array
        else:
            print("Invalid process")
            break
print(first_process(array))


processing2 = ['Sterilization', 'Freezing 20C', 'Freezing 30C']

def second_process(array):
    for processing2 in array:
        if user_input == processing2[0]:
            for element in array:
                if element == 'Pasteurization':
                    combined_array = np.append(returnList, np.delete(array, [7]))  
                    final_array = np.append(combined_array, 'Pasteurization')
            return final_array
        elif user_input == array[8] or user_input == array[9]:
            for element in array:
                if element == 'Cooling':
                    combined_array = np.append(returnList, np.delete(array, [16]))  
                    final_array = np.append(combined_array, 'Cooling')
            return final_array
print(second_process(array))
