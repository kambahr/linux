
# One-click installation of Awall on Alpine linux

## Installation and configuration of firewall

Run the <em>**install_awall.sh**</em> on your Alpine linux. It will 

- install Awall package and load Linux kernel drivers,
- create basic (inbound/outbound) rules (ping, http, ssh, dsn, ntp, smtp),
- create a rule for blocking offenders.

### Rules

<ul>
    <li>os</li>
    <ul>
        <li>The most basic, dns, ntp, smtp, rules are placed into os.json file.</li>
    </ul>
    <li>ping, ssh, http</li>
    <ul>
        <li>The rules are placed into separate files.</li>
    </ul>
    <li>block</li>
    <ul>
        <li>        
            <p>To block offenderes, place ip addresses in the src[] array in /etc/awall/optional/block.json - as 
            the following example:
            <div style="backroun-color:iory">
            "action":"reject",
            "src":["555.123.1.2","555.123.1.3"]
            </p>
            <p>IP addresses in the src[] array will be blocked from connecting to all ports (inbound/outbound).</p>
            </div>            
        </li>
        <li>Please, note that block rule must be disabled, if there is no ip address in its src":[] array or there will be an error when activating the rule.</li>
    </ul>
</ul>

#### List Rules
```
~# awall list
block    disabled  block offenders
default  enabled   default deny all
http     enabled   allow inbound/outbound http/https
os       enabled   allow inbound/outbound dns, ntp, smtp
ping     enabled   allow ping
ssh      enabled   allow ssh
```
#### Enable Rule
``` 
awall enable block
awall activate -f
```
Note that you must activate (awall activate -f) a rule, before it can be applied.

### DOCKER
Add the following to the docker file... and all the firewall will be ready for use.
``` 
COPY install_awall.sh .
CMD ["./install_awall.sh"]
```
#### References
Siegel, Zac. "Configuring Awall on Alpine Linux." 13 Jan. 2022. [www.zsiegel.com/2022/01/13/configuring-alpine-linux-firewall-with-docker](https://www.zsiegel.com/2022/01/13/configuring-alpine-linux-firewall-with-docker). Accessed 5 Feb 2023.

Alpine Linux. "How-To Alpine Wall."  23 Jul. 2021. [wiki.alpinelinux.org/wiki/How-To_Alpine_Wall](https://wiki.alpinelinux.org/wiki/How-To_Alpine_Wall). Accessed 5 Feb 2023.

