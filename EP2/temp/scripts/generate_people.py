# This file encapsulates all the scripts and generates a file to use in the DML file.
# generating .txt files is used as a way to debug data if necessary.

# Change these numbers to change the number of generated people:
total_people = 40
total_males = 20


### GENERATING NAMES ###
#using package names from https://treyhunner.com/2013/02/random-name-generator/
import names
import os
import pprint
import random

f = open('no_repeat_name_list.txt', 'w')

names_amount = total_people
male_names = total_males
male_namelist = []
female_namelist = []

if male_names < names_amount:
    female_names = names_amount - male_names 
else: #default is 50/50
    names_amount = total_people
    male_names = total_males / 2
    female_names = names_amount - male_names 


f.write("Male Names: " + str(male_names)+ '\n')

while len(male_namelist) < male_names:
    temp_name = names.get_full_name(gender="male")
    if temp_name not in male_namelist:
        male_namelist.append(temp_name)
        f.write(temp_name + '\n')

#print("\nMale names:")
#pp = pprint.PrettyPrinter(indent=4, compact = True)
#pp.pprint(male_namelist)


f.write("\nFemale Names: " + str(female_names)+ '\n')

while len(female_namelist) < female_names:
    temp_name = names.get_full_name(gender="female")
    if temp_name not in female_namelist:
        female_namelist.append(temp_name)
        f.write(temp_name + '\n')

#print("\nFemale names:")
#pp = pprint.PrettyPrinter(indent=4, compact = True)
#pp.pprint(female_namelist)

### GENERATING NUMBERS ###
f = open('no_repeat_rng_list.txt', 'w')

nusp_amount = total_people
cpf_amount = total_people
nusp_list = []
cpf_list = []

f.write("Number of NUSPs: " + str(nusp_amount)+ '\n')

while len(nusp_list) < nusp_amount:
    tempNum = random.randrange(100000000,999999999)
    if tempNum not in nusp_list:
        nusp_list.append(tempNum)
        f.write(str(tempNum) + '\n')

#print("\nNUSP List:")
#pp.pprint(nusp_list)


f.write("\nNumber of CPFs: " + str(cpf_amount)+ '\n')

while len(cpf_list) < cpf_amount:
    tempNum = random.randrange(10000000000,99999999999)
    if tempNum not in cpf_list:
        cpf_list.append(tempNum)
        #f.write(str(tempNum) + '\n')

string_cpfs = []
for cpf in cpf_list:
    temp_str = str(cpf)
    new_str = temp_str[0:3] + '.' + temp_str[3:6] + '.' + temp_str[6:9] + '-' + temp_str[9:]
    string_cpfs.append(new_str)
    f.write(new_str + '\n')

#print("CPF List:")
#pp.pprint(string_cpfs)

f.close()

### GENERATING DATES ###
f = open('rng_bday_list.txt', 'w')

bday_amount = total_people
bday_list = []

# Going to generate any date between 1950 and 2000.
# No real reason to pick these intervals other than making them 18+.
# Using format DD-MM-YYYY because we're in Brazil.


f.write("Number of bdays: " + str(bday_amount)+ '\n')

while len(bday_list) < bday_amount:
    date = random.randrange(1,31)
    month = random.randrange(1,12)
    year = random.randrange(1950 ,2000)

    temp_bday = str(date) + '-' + str(month) + '-' + str(year)
    bday_list.append(temp_bday)

    f.write(temp_bday + '\n')

#print("\nBday List:")
#pp.pprint(bday_list)

f.close()

### GENERATING THE FULL LINE FOR THE DML FILE ###
# Format: (NUSP, CPF, PNome, SNome, Bday, Sexo)
# male_namelist
# female_namelist
# nusp_list
# string_cpfs
# bday_list

f = open('rng_person.txt', 'w')

end_list = []

while nusp_list:
    temp_nusp = nusp_list.pop()
    temp_cpf = string_cpfs.pop()
    
    if male_namelist:
        temp_nome = male_namelist.pop()
        temp_pnome = temp_nome.split()[0]
        temp_snome = temp_nome.split()[1]
        temp_sexo = 'M'

    #When there are no more male names
    else:
        temp_nome = female_namelist.pop()
        temp_pnome = temp_nome.split()[0]
        temp_snome = temp_nome.split()[1]
        temp_sexo = 'F'

    temp_bday = bday_list.pop()

    temp_person = '(' + str(temp_nusp) + ',\'' + str(temp_cpf) + '\',\'' + temp_pnome + '\',\'' + temp_snome + '\',\'' + \
                str(temp_bday) + '\',\'' + temp_sexo + '\')'

    #print(temp_person)
    end_list.append(temp_person)

#mixin male and female names
random.shuffle(end_list)

for x in end_list:
    f.write(x + '\n')

pp = pprint.PrettyPrinter(indent=4, compact = True)
pp.pprint(end_list)

f.close()

print("\n Number of people: " + str(total_people))
print(" Generated list has been saved in the file rng_person.txt.")
