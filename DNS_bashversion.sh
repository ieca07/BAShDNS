#!/bin/bash

function banner {
echo " ____  _  _  ___       ____    __    ___  _   _  _  _  ___ " 
echo "(  _ \( \( )/ __)     (  _ \  /__\  / __)( )_( )( \/ )(__ \ "
echo " )(_) ))  ( \__ \ ___  ) _ < /(__)\ \__ \ ) _ (  \  /  / _/ "
echo "(____/(_)\_)(___/(___)(____/(__)(__)(___/(_) (_)  \/  (____) "
echo "      [*] developed by IECA [INDIAN ERROR CYBER ARMY]       "
echo 
echo 

}  
function random {
ip1=$(($RANDOM%255))
ip2=$(($RANDOM%255))
ip3=$(($RANDOM%255))
ip4=$(($RANDOM%255))
echo "here is your RandomIP = $ip1.$ip2.$ip3.$ip4"
ip_address="$ip1.$ip2.$ip3.$ip4"

if domain_name=$(host "$ip1.$ip2.$ip3.$ip4" | awk '{print $NF}' | sed 's/\.$//'); then
    echo "Domain name: $domain_name"
else
    echo "No domain name found for $ip1.$ip2.$ip3.$ip4"
fi   
 
 
}

function usage {
  clear
  banner 
  echo "Usage: $0 [-h] [-d domain] [--random]"
  echo "Perform DNS reconnaissance on a target domain"
  echo ""
  echo "Options:"
  echo "  -h          Display this help message"
  echo "  -d domain   Specify the target domain"
  echo "  -r random   Its take Random 'IP' and gives you domain" 
}

while getopts ":hd:r" opt; do
  case ${opt} in
    h )
      usage
      exit 0
      ;;
    d )
      domain=$OPTARG
      ;;
    r )
     random
     exit 0 
     ;;   
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      exit 1
      ;;
    : )
      echo "Option -$OPTARG requires an argument" 1>&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$domain" ]]; then
  echo "Please specify a domain using the -d option"
  exit 1
fi

echo "[*]Performing DNS reconnaissance on $domain..."
echo 
echo "[*]Running dnsrecon..."
echo 
if ! command -v dnsrecon &> /dev/null; then
  echo "dnsrecon not found. Skipping..."
else
  dnsrecon -d "$domain"
fi
echo
echo "[*]Running dnswalk..."
echo 
if ! command -v dnswalk &> /dev/null; then
  echo "dnswalk not found. Skipping..."
else
  dnswalk "$domain."
fi
echo 
echo "[*]Running Fierce..."
echo 
if ! command -v fierce &> /dev/null; then
  echo "fierce not found. Skipping..."
else
  fierce --domain "$domain"
fi
echo 
echo "[*]Running DNSenum..."
echo 
if ! command -v dnsenum &> /dev/null; then
  echo "dnsenum not found. Skipping..."
else
  dnsenum --enum "$domain"
fi
echo 
echo "[*]Running Dnsmap..."
echo 
if ! command -v dnsmap &> /dev/null; then
  echo "dnsmap not found. Skipping..."
else
  dnsmap "$domain"
fi
echo 
echo "******DNS reconnaissance complete*******"

  





