#using package names from https://treyhunner.com/2013/02/random-name-generator/
import names
import os
import pprint

f = open('no_repeat_name_list.txt', 'w')

names_amount = 60
male_names = 30
male_namelist = []
female_namelist = []

if male_names < names_amount:
    female_names = names_amount - male_names 
else: #default
    names_amount = 60
    male_names = 30
    female_names = names_amount - male_names 


f.write("Male Names: " + str(male_names)+ '\n')

while len(male_namelist) < male_names:
    temp_name = names.get_full_name(gender="male")
    if temp_name not in male_namelist:
        male_namelist.append(temp_name)
        f.write(temp_name + '\n')

print("\nMale names:")
pp = pprint.PrettyPrinter(indent=4, compact = True)
pp.pprint(male_namelist)


f.write("\nFemale Names: " + str(female_names)+ '\n')

while len(female_namelist) < female_names:
    temp_name = names.get_full_name(gender="female")
    if temp_name not in female_namelist:
        female_namelist.append(temp_name)
        f.write(temp_name + '\n')

print("\nFemale names:")
pp = pprint.PrettyPrinter(indent=4, compact = True)
pp.pprint(female_namelist)
