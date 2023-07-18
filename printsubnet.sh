#!/bin/bash
#  print out all IPs of a subnet.
#  Adopted from https://www.unix.com/shell-programming-and-scripting/228663-get-all-ip-address-subnet-mask.html

printsubnet() {
        local OLDIFS="$IFS"
        local SUB=${1/\/*/}
        local MASK=$(( 1 << ( 32 - ${1/*\//} )))

        IFS="."
                set -- $SUB
                IPS=$((0x$(printf "%02x%02x%02x%02x\n" $1 $2 $3 $4)))
        IFS="$OLDIFS"

        for ((N=0; N<MASK; N++))
        {
                VAL=$((IPS|N))

                printf "nslookup %d.%d.%d.%d\n"                  \
                        $(( (VAL >> 24) & 255 ))        \
                        $(( (VAL >> 16) & 255 ))        \
                        $(( (VAL >> 8 ) & 255 ))        \
                        $(( (VAL)       & 255 ))
        }
}

if [ $# -ne 1 ] ; then
   echo "Usage $0 your-subnet"
   echo "   $0 172.20.30.1/25"
   exit 1
fi

printsubnet $1
