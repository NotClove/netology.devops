# Домашнее задание к занятию "3. Использование Yandex Cloud"

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

![screen](./pics/2023-01-16%20%D0%B2%2023.07.00.png)

Ссылка на репозиторий LightHouse: https://github.com/VKCOM/lighthouse

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.

[lighthouse](./playbook/lighthouse.yml)

2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.
4. Приготовьте свой собственный inventory файл `prod.yml`.

[prod.yml](./playbook/inventory/prod.yml)

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```bash
playbook git:(master) ✗ ansible-lint clickhouse.yml 
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: clickhouse.yml

Passed with production profile: 0 failure(s), 0 warning(s) on 1 files.
➜  playbook git:(master) ✗ ansible-lint lighthouse.yml 
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: lighthouse.yml

Passed with production profile: 0 failure(s), 0 warning(s) on 1 files.
➜  playbook git:(master) ✗ ansible-lint vector.yml    
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: vector.yml

Passed with production profile: 0 failure(s), 0 warning(s) on 1 files.
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```bash
playbook git:(master) ✗ ansible-playbook -i inventory/prod.yml lighthouse.yml --check

PLAY [Install lighthouse] ****************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Install git] **********************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighhouse | Install nginx] *********************************************************************************************************************
changed: [lighthouse-01]

TASK [Lighthouse | Apply nginx config] ***************************************************************************************************************
changed: [lighthouse-01]

TASK [Lighthouse | Clone repository] *****************************************************************************************************************
changed: [lighthouse-01]

TASK [Lighthouse | Apply config] *********************************************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [Nginx reload] ***********************************************************************************************************************
fatal: [lighthouse-01]: FAILED! => {"changed": false, "msg": "Could not find the requested service nginx: host"}

NO MORE HOSTS LEFT ***********************************************************************************************************************************

PLAY RECAP *******************************************************************************************************************************************
lighthouse-01              : ok=6    changed=4    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```bash
ansible-playbook -i inventory/prod.yml lighthouse.yml --diff

PLAY [Install lighthouse] ****************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Install git] **********************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighhouse | Install nginx] *********************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Apply nginx config] ***************************************************************************************************************
--- before: /etc/nginx/nginx.conf
+++ after: /Users/clove/.ansible/tmp/ansible-local-42999umm1ln7a/tmpxvgfombh/nginx.conf.j2
@@ -1,83 +1,32 @@
-user www-data;
+user root;
 worker_processes auto;
+error_log /var/log/nginx/error.log;
 pid /run/nginx.pid;
-include /etc/nginx/modules-enabled/*.conf;
+
+include /usr/share/nginx/modules/*.conf;
 
 events {
-       worker_connections 768;
-       # multi_accept on;
+    worker_connections 1024;
 }
 
 http {
+    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
+                      '$status $body_bytes_sent "$http_referer" '
+                      '"$http_user_agent" "$http_x_forwarded_for"';
 
-       ##
-       # Basic Settings
-       ##
+    access_log  /var/log/nginx/access.log  main;
 
-       sendfile on;
-       tcp_nopush on;
-       types_hash_max_size 2048;
-       # server_tokens off;
+    sendfile            on;
+    tcp_nopush          on;
+    tcp_nodelay         on;
+    keepalive_timeout   65;
+    types_hash_max_size 2048;
 
-       # server_names_hash_bucket_size 64;
-       # server_name_in_redirect off;
+    include             /etc/nginx/mime.types;
+    default_type        application/octet-stream;
 
-       include /etc/nginx/mime.types;
-       default_type application/octet-stream;
-
-       ##
-       # SSL Settings
-       ##
-
-       ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
-       ssl_prefer_server_ciphers on;
-
-       ##
-       # Logging Settings
-       ##
-
-       access_log /var/log/nginx/access.log;
-       error_log /var/log/nginx/error.log;
-
-       ##
-       # Gzip Settings
-       ##
-
-       gzip on;
-
-       # gzip_vary on;
-       # gzip_proxied any;
-       # gzip_comp_level 6;
-       # gzip_buffers 16 8k;
-       # gzip_http_version 1.1;
-       # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
-
-       ##
-       # Virtual Host Configs
-       ##
-
-       include /etc/nginx/conf.d/*.conf;
-       include /etc/nginx/sites-enabled/*;
-}
-
-
-#mail {
-#      # See sample authentication script at:
-#      # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
-#
-#      # auth_http localhost/auth.php;
-#      # pop3_capabilities "TOP" "USER";
-#      # imap_capabilities "IMAP4rev1" "UIDPLUS";
-#
-#      server {
-#              listen     localhost:110;
-#              protocol   pop3;
-#              proxy      on;
-#      }
-#
-#      server {
-#              listen     localhost:143;
-#              protocol   imap;
-#              proxy      on;
-#      }
-#}
+    # Load modular configuration files from the /etc/nginx/conf.d directory.
+    # See http://nginx.org/en/docs/ngx_core_module.html#include
+    # for more information.
+    include /etc/nginx/conf.d/*.conf;
+}
\ No newline at end of file

changed: [lighthouse-01]

TASK [Lighthouse | Clone repository] *****************************************************************************************************************
>> Newly checked out d701335c25cd1bb9b5155711190bad8ab852c2ce
changed: [lighthouse-01]

TASK [Lighthouse | Apply config] *********************************************************************************************************************
--- before
+++ after: /Users/clove/.ansible/tmp/ansible-local-42999umm1ln7a/tmpbr7ke9uf/lighthouse_nginx.conf.j2
@@ -0,0 +1,10 @@
+server {
+    listen    80;
+       server_name localhost;
+       location / {
+
+           root /home/ubuntu/lighthouse;
+               index index.html;
+
+       }
+}
\ No newline at end of file

changed: [lighthouse-01]

RUNNING HANDLER [Nginx reload] ***********************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP *******************************************************************************************************************************************
lighthouse-01              : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```bash
ansible-playbook -i inventory/prod.yml lighthouse.yml --diff

PLAY [Install lighthouse] ****************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Install git] **********************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighhouse | Install nginx] *********************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Apply nginx config] ***************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Clone repository] *****************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Apply config] *********************************************************************************************************************
ok: [lighthouse-01]

PLAY RECAP *******************************************************************************************************************************************
lighthouse-01              : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

[README.md](./playbook/README.md)

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---
