import random
import os
import pprint

f = open('no_repeat_rng_list.txt', 'w')

nusp_amount = 60
cpf_amount = 60
nusp_list = []
cpf_list = []

f.write("Number of NUSPs: " + str(nusp_amount)+ '\n')

while len(nusp_list) < nusp_amount:
    tempNum = random.randrange(100000000,999999999)
    if tempNum not in nusp_list:
        nusp_list.append(tempNum)
        f.write(str(tempNum) + '\n')

print("\nNUSP List:")
pp = pprint.PrettyPrinter(indent=4, compact = True)
pp.pprint(nusp_list)


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

print("CPF List:")
pp.pprint(string_cpfs)

f.close()
