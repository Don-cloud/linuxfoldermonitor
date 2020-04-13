#/bin/bash
#author: sajal sachdev
# simple script to move incoming file to azure blob storage
# This scirpt use SAS based authentication 

CONTAINER_URL="<add container URL here + SAS Token>";

#call azcopy to copy the incoming file
ret=`azcopy copy "$1" "$CONTAINER_URL"`;
#echo $ret
result=`echo $ret|grep "0 Failed"`;
echo $result;
if [ "$result"=0 ] ;
   then 
    #if successful move file to processsed directory move file sfrom dir a to b
    mv $1 $PWD/processed;
fi
exit 0;
