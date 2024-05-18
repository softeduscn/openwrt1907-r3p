#!/bin/bash

cd /etc/ipset-rules
rm ipv*.sh
echo "Download delegated-apnic-latest...">/tmp/update_chnlist
wget -c http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest
echo "Make ipv4_CN...">/tmp/update_chnlist
cat delegated-apnic-latest | awk -F '|' '/CN/&&/ipv4/ {print "ipset add ipv4_CN " $4 "/" 32-log($5)/log(2)}' | cat > ipv4_CN.sh
sed -i '1s/^/#!\/bin\/bash\nipset create ipv4_CN hash:net hashsize 16384\n/' ipv4_CN.sh
chmod +x ipv4_CN.sh
echo "Make ipv6_CN...">/tmp/update_chnlist
cat delegated-apnic-latest | awk -F '|' '/CN/&&/ipv6/ {print "ipset add ipv6_CN " $4 "/" $5}' | cat > ipv6_CN.sh
sed -i '1s/^/#!\/bin\/bash\nipset create ipv6_CN hash:net family inet6 hashsize 4096\n/' ipv6_CN.sh
chmod +x ipv6_CN.sh
rm delegated*
echo "Ipset ipv4_CN...">/tmp/update_chnlist
ipset flush ipv4_CN
./ipv4_CN.sh
echo "Ipset ipv6_CN...">/tmp/update_chnlist
ipset flush ipv6_CN
./ipv6_CN.sh
echo "Restart mwan3...">/tmp/update_chnlist
/etc/init.d/mwan3 reload
rm /tmp/update_chnlist
