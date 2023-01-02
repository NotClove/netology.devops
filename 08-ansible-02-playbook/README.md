# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.

    Дополнил существующий [prod.yml](./playbook/inventory/prod.yml)

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).

    Сделал соседний play - [vector.yml](./playbook/vector.yml)

3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```
Привел плейбук к состоянию без ошибок:
playbook git:(master) ✗ ansible-lint vector.yml 
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: vector.yml

Passed with production profile: 0 failure(s), 0 warning(s) on 1 files.
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```bash
В данном случае будет ошибка, т.к не созданы директории для таски
playbook git:(master) ✗ ansible-playbook -i inventory/prod.yml vector.yml --check

PLAY [Install Vector] ********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [ubuntu]

TASK [Get Vector distrib] ****************************************************************************************************************************
changed: [ubuntu]

TASK [Create directory for Vector] *******************************************************************************************************************
changed: [ubuntu]

TASK [Extract Vector] ********************************************************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoneType: None
fatal: [ubuntu]: FAILED! => {"changed": false, "msg": "dest '/etc/vector' must be an existing dir"}

PLAY RECAP *******************************************************************************************************************************************
ubuntu                     : ok=3    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```bash
playbook git:(master) ✗ ansible-playbook -i inventory/prod.yml vector.yml --diff 

PLAY [Install Vector] ********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [ubuntu]

TASK [Get Vector distrib] ****************************************************************************************************************************
changed: [ubuntu]

TASK [Create directory for Vector] *******************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/etc/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [ubuntu]

TASK [Extract Vector] ********************************************************************************************************************************
changed: [ubuntu]

TASK [Environment Vector] ****************************************************************************************************************************
--- before
+++ after: /Users/clove/.ansible/tmp/ansible-local-88964c7duzluc/tmp7tdhj_ug/vector.sh.j2
@@ -0,0 +1,4 @@
+#!/usr/bin/env bash
+export VECTOR_DIR=/etc/vector
+export PATH=$PATH:$VECTOR_DIR/bin
+.vector --config /etc/vector/config/vector.toml
\ No newline at end of file

changed: [ubuntu]

PLAY RECAP *******************************************************************************************************************************************
ubuntu                     : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```bash
playbook git:(master) ✗ ansible-playbook -i inventory/prod.yml vector.yml --diff

PLAY [Install Vector] ********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [ubuntu]

TASK [Get Vector distrib] ****************************************************************************************************************************
ok: [ubuntu]

TASK [Create directory for Vector] *******************************************************************************************************************
ok: [ubuntu]

TASK [Extract Vector] ********************************************************************************************************************************
skipping: [ubuntu]

TASK [Environment Vector] ****************************************************************************************************************************
ok: [ubuntu]

PLAY RECAP *******************************************************************************************************************************************
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

