import sys
import getopt
import csv
import pandas as pd

def merge(csv_list,output_file):
    with open(output_file,"w") as csvfile: 
        writer = csv.writer(csvfile)
        writer.writerow(['bug.id','revision.id.buggy','revision.id.fixed','report.id','report.url']) 
    for inputfile in csv_list:
        f=open(inputfile)
        data=pd.read_csv(f).astype(str)
        data.to_csv(output_file,mode='a',index=False,header=None)

def remove(file):
    df = pd.read_csv(file).astype(str)
    datalist = df.drop_duplicates(subset=['revision.id.buggy','revision.id.fixed'],keep='first',inplace=False)
    datalist.to_csv(file,index = False)

def resort(file): 
    df = pd.read_csv(file,header=0).astype(str)
    datalist=df.drop(['bug.id'],axis=1)
    datalist.insert(0,'bug.id',range(1,df.shape[0]+1))
    datalist.to_csv(file,index = False)



if __name__=="__main__":

    #input arguments
    input_file1 = None
    input_file2 = None
    output_file = None
    try:
        opts, args = getopt.getopt(sys.argv[1:],"hp:f:s:o:")
    except getopt.GetoptError:
        print("duplicate_removal.py -f <first_file> -s <second_file> -o <outputfile>")
    for opt, arg in opts:
        if opt in ['-f']:
            first_file = arg
        elif opt in ['-s']:
            second_file = arg
        elif opt in ['-o']:
            output_file = arg
        elif opt in ['-h']:
            print("duplicate_removal.py -f <first_file> -s <second_file> -o <outputfile>")
            sys.exit()
    merge([first_file,second_file],output_file)
    remove(output_file)
    resort(output_file)