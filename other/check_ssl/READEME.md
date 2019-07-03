The Script can deal with these options:
    -H
    Sets the value for the hostname. e.g adfinis-sygroup.ch
    -I
    Sets an optional value for an IP to connect. e.g 127.0.0.1
    -p
    Sets the value for the port. e.g 443
    -P
    Sets an optional value for an TLS protocol. e.g xmpp
    -w
    Sets the value for the days before warning. Default is 30
    -c
    Sets the value for the days before critical. Default is 5
    -h
Example
    ./check_ssl.sh -H adfinis-sygroup.ch -p 443 -w 40
    Or
    ./check_ssl.sh -H jabber.adfinis-sygroup.ch -p 5222 -P xmpp -w 30 -c 5
