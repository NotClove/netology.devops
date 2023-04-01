Роль для установки Lighthouse 

Role Variables
--------------

| vars | Description | Value | Location |
|------|------------|---|---|
| lighthouse_url | Lighthouse URL | https://github.com/VKCOM/lighthouse.git | group_vars/lighthouse/vars.yml |
| lighthouse_dir | Lighthouse dir | /home/ubuntu/lighthouse | group_vars/lighthouse/vars.yml |
| lighthouse_nginx_user | Lighthouse nginx user | root | group_vars/lighthouse/vars.yml |
| lighthouse_nginx_template | lighthouse template for nginx | | templates/nginx.conf.j2 |
| lighthouse_template | nginx config | | templates/lighthouse_nginx.conf.j2 |
