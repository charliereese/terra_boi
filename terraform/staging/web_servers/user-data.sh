#!/bin/bash

cat > index.html <<EOF
<h1>${server_text}</h1>
<p>DB port: ${db_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} &

# <p>DB address: ${db_address}</p>