import random
import os
import pprint

f = open('rng_bday_list.txt', 'w')

bday_amount = 60
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

print("\Bday List:")
pp = pprint.PrettyPrinter(indent=4, compact = True)
pp.pprint(bday_list)

f.close()
