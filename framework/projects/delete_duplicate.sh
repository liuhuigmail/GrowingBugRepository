cd ./Math/patches #need modify
old_nums=106 #need modify
new_nums=292 #need modify
#temp=4;
#for((i=1;i<=106;i++));  
#do    
#`expr $i + 1`
#   for((j=107;j<=292;j++)); 
#   do
   #var=`grep -wvf $i.src.patch $j.src.patch -c `
#   if [ `diff -bBw $i.src.patch $j.src.patch | wc  -l` -eq $temp ]
#   then
#    echo -e "$i.src.patch and $j.src.patch"
#   fi
#   done
#done   
#for((i=1;i<=$new_nums;i++));  
#do 
#	for((j=`expr $i + 1`;j<=$new_nums;j++));
#	do
for((i=1;i<=$old_nums;i++));  
do 
	for((j=`expr $old_nums + 1`;j<=$new_nums;j++));
	do
	       	if [ ! -f "$i.src.patch" -o  ! -f "$j.src.patch"  ]
	   	then
		 	continue
	   	fi
		cp $i.src.patch $i.src.temp.patch
		cp $j.src.patch $j.src.temp.patch
		#delete line 2
		#sed -i '2d' $i.src.temp.patch $j.src.temp.patch
		#delete index xxx....
		sed -i '/^index ./d' $i.src.temp.patch $j.src.temp.patch 
		sed -i 's/^@@ .* @@/@@ @@/g' $i.src.temp.patch $j.src.temp.patch
		sed -i 's/^[+-][ \t]*@/@/g' $i.src.temp.patch $j.src.temp.patch
		sed -i '/^[+-][ \t]*$/d' $i.src.temp.patch $j.src.temp.patch
		sed -i 's/^[+-][ \t]*\//\//g' $i.src.temp.patch $j.src.temp.patch
		sed -i 's/^[+-][ \t]*\*/\*/g' $i.src.temp.patch $j.src.temp.patch
		sed -i 's/^\([+-]\)[ \t]*/\1/' $i.src.temp.patch $j.src.temp.patch 
		sed -i 's/^[ \t]*//' $i.src.temp.patch $j.src.temp.patch 
		#cat $i.src.temp.patch $j.src.temp.patch 
		#exit
		#sed -i 's/^[+-]//g' $i.src.temp.patch $j.src.temp.patch
		#sed -i 's/^[+-] *\/\//\/\//g' $i.src.temp.patch $j.src.temp.patch
		#judge $j is $i's subset ? if return 0,then it is true 
		#the return value is the new lines('+') numbers,namely, is the new line numbers of $j version
		first_cmp=$(diff --unchanged-line-format= --old-line-format= --new-line-format='%L' "$i.src.temp.patch" "$j.src.temp.patch" -bBw | wc -l)
		first_cmp=1
		#judge $i is $j's subset ? if return 0,then it is true
		second_cmp=$(diff --unchanged-line-format= --old-line-format= --new-line-format='%L' "$j.src.temp.patch" "$i.src.temp.patch" -bBw | wc -l)
		#second_cmp=1
		if [ "$first_cmp" -eq "0" -o "$second_cmp" -eq "0" ]
		then
		    echo -e "$i and $j are duplicate"
		#else
		    #echo "Not subset"
		fi
		rm $i.src.temp.patch $j.src.temp.patch
	done
done 
rm -rf ./sed*
cd ../
cp -r patches new_patches
rm -rf patches
mv new_patches patches
cd ../
