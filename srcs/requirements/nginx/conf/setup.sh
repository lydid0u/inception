#!/bin/bash

# Replace domain name in the nginx config
sed -i "s/\${DOMAIN_NAME}/$DOMAIN_NAME/g" /etc/nginx/sites-available/default

# Start NGINX in foreground
nginx -g "daemon off;"