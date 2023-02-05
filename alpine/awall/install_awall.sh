# References
# Siegel, Zac. "Configuring Awall on Alpine Linux." 13 Jan. 2022. www.zsiegel.com/2022/01/13/configuring-alpine-linux-firewall-with-docker. Accessed 5 Feb 2023.
# Alpine Linux. "How-To Alpine Wall."  23 Jul. 2021. wiki.alpinelinux.org/wiki/How-To_Alpine_Wall. Accessed 5 Feb 2023.

DIR_AWALL_OPTIONAL=/etc/awall/optional
RULE_DEFAULT=default.json
RULE_PING=ping.json
RULE_SSH=ssh.json
RULE_HTTP=http.json
RULE_OS=os.json
RULE_BLOCK=block.json

# install packages
apk update && apk upgrade
apk add ip6tables iptables
apk add -u awall
apk version awall

# Loading Linux kernel drivers
modprobe -v ip_tables  
modprobe -v ip6_tables
modprobe -v iptable_nat

# ----------------------------------
#       create the rule files
# ----------------------------------
# create the default rule
if [ -f "$DIR_AWALL_OPTIONAL/$RULE_DEFAULT" ]; then
    rm $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
fi
touch $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
echo -e '{' >> $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
echo -e '  "description": "default deny all",' >> $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
echo -e '  "variable":{"internet_if": ["eth0","inet","inet6"]},' >> $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
echo -e '  "zone": {' >> $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
echo -e '    "internet":{"iface": "$internet_if"}' >> $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
echo -e '    },' >> $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
echo -e '    "policy": [' >> $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
echo -e '      {"in": "internet", "action": "drop"},' >> $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
echo -e '      {"action": "reject"}' >> $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
echo -e '    ]' >> $DIR_AWALL_OPTIONAL/$RULE_DEFAULT
echo -e '}' >> $DIR_AWALL_OPTIONAL/$RULE_DEFAULT

# create ping rule
if [ -f "$DIR_AWALL_OPTIONAL/$RULE_PING" ]; then
    rm $DIR_AWALL_OPTIONAL/$RULE_PING
fi
touch $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '{' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '  "description": "allow ping",' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '  "filter":[' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '   {' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '     "in":"internet",' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '     "out": "_fw",' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '     "service": ["ping"],' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '     "action": "accept",' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '     "flow-limit": {"count": 10, "interval": 6}' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '   },' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '   {' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '    "in":"internet",' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '    "out": "_fw",' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '    "service": ["ping"],' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '    "action": "accept",' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '    "flow-limit": {"count": 10, "interval": 6}' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '    }' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '  ] ' >> $DIR_AWALL_OPTIONAL/$RULE_PING
echo -e '}' >> $DIR_AWALL_OPTIONAL/$RULE_PING

# create ssh rule
if [ -f "$DIR_AWALL_OPTIONAL/$RULE_PING" ]; then
    rm $DIR_AWALL_OPTIONAL/$RULE_SSH
fi
touch $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '{' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '  "description": "allow ssh",' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '  "filter":[' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '   {' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '     "in":"internet",' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '     "out": "_fw",' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '     "service": "ssh",' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '     "action": "accept",' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '     "conn-limit": { "count": 3, "interval": 60}' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '   },' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '   {' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '    "in":"_fw",' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '    "out": "internet",' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '    "service": "ssh",' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '    "action": "accept",' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '    "conn-limit": { "count": 3, "interval": 60}' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '    } ' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '  ] ' >> $DIR_AWALL_OPTIONAL/$RULE_SSH
echo -e '}' >> $DIR_AWALL_OPTIONAL/$RULE_SSH

# create http rules
if [ -f "$DIR_AWALL_OPTIONAL/$RULE_HTTP" ]; then
    rm $DIR_AWALL_OPTIONAL/$RULE_HTTP
fi
touch $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '{' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '  "description": "allow inbound/outbound http/https",' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '  "filter": [' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    {' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    "in":"internet",' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    "out": "_fw",' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    "service": ["http", "https"],' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    "action": "accept"' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    },' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    {' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    "in":"_fw",' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    "out": "internet",' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    "service": ["http", "https"],' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    "action": "accept"' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '    }' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '  ]' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP
echo -e '}' >> $DIR_AWALL_OPTIONAL/$RULE_HTTP

# create os rules
if [ -f "$DIR_AWALL_OPTIONAL/$RULE_OS" ]; then
    rm $DIR_AWALL_OPTIONAL/$RULE_OS
fi
touch $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '{' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '  "description": "allow inbound/outbound dns, ntp, smtp",' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '  "filter": [' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    {' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    "in":"internet",' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    "out": "_fw",' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    "service": ["dns", "smtp", "ntp"],' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    "action": "accept"' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    },' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    {' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    "in":"_fw",' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    "out": "internet",' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    "service": ["dns", "smtp", "ntp"],' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    "action": "accept"' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '    }' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '  ]' >> $DIR_AWALL_OPTIONAL/$RULE_OS
echo -e '}' >> $DIR_AWALL_OPTIONAL/$RULE_OS

# create block rule
if [ -f "$DIR_AWALL_OPTIONAL/$RULE_BLOCK" ]; then
    rm $DIR_AWALL_OPTIONAL/$RULE_BLOCK
fi
touch $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '{' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '  "description": "block offenders",' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '  "filter":[' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '   {' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '     "in":"internet",' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '     "out": "_fw",' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '     "action": "reject",' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '     "src" : []' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '   },' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '   {' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '    "in":"_fw",' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '    "out": "internet",' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '    "action": "reject",' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '    "src" : []' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
echo -e '    }' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK   
echo -e '  ]' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK 
echo -e '}' >> $DIR_AWALL_OPTIONAL/$RULE_BLOCK
# -------------------------------------------------------------------

# create rules
awall enable default
awall enable ping
awall enable http
awall enable ssh
awall enable os

# do not enable block at first; as if the src[] is empty. awall
# will throw an error. You must enable the block fule if there
# at least one ip address to block.
awall disable block

# prepare the services
rc-update add iptables
rc-update add ip6tables
/etc/init.d/iptables save
/etc/init.d/ip6tables save
rc-service iptables save
rc-service ip6tables save
awall activate -f

# these are the "firewall" services; you can just stop them
# if you need open your server to all traffic (i.e. testing/config).
rc-service iptables start
rc-service ip6tables start

awall list
