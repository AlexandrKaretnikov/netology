#!/bin/bash
PREFIX="${1:-NOT_SET}"
INTERFACE="$2"
SUBNET="${3:-NOT_SET}"
HOST="${4:-NOT_SET}"

# перехватчик сигнала
trap 'echo "Ping exit (Ctrl-C)"; exit 1' 2
###################

# проверка на root
username=`id -nu`
if [ "$username" != "root" ]
then
        echo "Must be root to run \"`basename $0`\"."
        exit 1
fi
###################

# прверка пользовательских данных
[[ "$PREFIX" = "NOT_SET" ]] && { echo "\$PREFIX must be passed as first positional argument"; exit 1; }
if [[ -z "$INTERFACE" ]]; then
    echo "\$INTERFACE must be passed as second positional argument"
    exit 1
fi

if ! [[ "$PREFIX" =~ ^(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$ ]]; then
        echo "\$PREFIX is entered incorrectly. Please enter \$PREFIX in the format [0-255].[0-255]"
        exit 1
fi

if [[ "$SUBNET" != "NOT_SET" ]] && ! [[ "$SUBNET" =~ ^(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$ ]]; then
        echo "\$SUBNET is entered incorrectly. Please enter \$SUBNET in the range from 0 to 255"
        exit 1
fi

if [[ "$HOST" != "NOT_SET" ]] && ! [[ "$HOST" =~ ^(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$ ]]; then
        echo "\$HOST is entered incorrectly. Please enter \$HOST in the range from 0 to 255"
        exit 1
fi
##################



if [[ "$SUBNET" == "NOT_SET" && "$HOST" == "NOT_SET" ]]; then
        for SUBNET in {1..255}
        do
                for HOST in {1..255}
                do
                        echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
                        arping -c 3 -i "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null
                done
        done
elif [[ "$SUBNET" != "NOT_SET" && "$HOST" == "NOT_SET" ]]; then
        for HOST in {1..255}
        do
                echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
                arping -c 3 -i "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null
        done
else
        echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
        arping -c 3 -i "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null
fi;