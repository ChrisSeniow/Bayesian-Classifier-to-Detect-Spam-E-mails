import csv
import string
import sys
from pyswip import Prolog

prolog = Prolog()
prolog.consult("finalProject.pl")

whitelist = set('abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789')

with open('data.csv', 'r') as csvfile:
    csvReader = csv.reader(csvfile)


    for row in csvReader:
        row[0] = row[0].lower()
        alphanumeric_filter = filter(whitelist.__contains__, row[0])
        alphanumeric_string = "".join(alphanumeric_filter)

        if row[1] == '1':
            sp = "spam"
        else:
            sp = "not"

        line = "email(["+ ','.join(alphanumeric_string.split()) + "]," + sp + ")"
        prolog.assertz(line)

f = open(sys.argv[1])

#print(f.read())
words = f.read().lower()
alphanumeric_filter2 = filter(whitelist.__contains__, words)
alphanumeric_string2 = "".join(alphanumeric_filter2)

query = "isSpam([" + ','.join(alphanumeric_string2.split()) + "],P1,P2)"


for i in prolog.query(query):
    #print(i["P1"])
    #print(i["P2"])
    if float(i["P1"]) > float(i["P2"]):
        print("Spam")
    else:
        print("Not Spam")
