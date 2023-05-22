# Домашнее задание к занятию "5. Тестирование roles"

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.5.2"`
2. Выполните `docker pull aragast/netology:latest` -  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри

## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert'ов в verify.yml файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

<details>
    <summary>Лог тестирования molecule</summary>

```bash
clove@ansible:~/netology-ansible-vector/vector-role$ molecule test
WARNING  Driver docker does not provide a schema.
INFO     default scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/clove/.cache/ansible-compat/f5bcd7/modules:/home/clove/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/clove/.cache/ansible-compat/f5bcd7/collections:/home/clove/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/clove/.cache/ansible-compat/f5bcd7/roles:/home/clove/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/clove/.cache/ansible-compat/f5bcd7/roles/vectorclove.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=instance)
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/clove/netology-ansible-vector/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None)
skipping: [localhost] => (item=None)
skipping: [localhost] => (item=None)
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/quay.io/centos/centos:stream8)
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8)
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest)
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j251869988984.135403', 'results_file': '/home/clove/.ansible_async/j251869988984.135403', 'changed': True, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j94860181584.135429', 'results_file': '/home/clove/.ansible_async/j94860181584.135429', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j215934204491.135461', 'results_file': '/home/clove/.ansible_async/j215934204491.135461', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [instance]
ok: [centos8]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Get Vector distrib] ****************************************
changed: [centos8]
changed: [ubuntu]
changed: [instance]

TASK [vector-role : Create directory for Vector] *******************************
changed: [ubuntu]
changed: [centos8]
changed: [instance]

TASK [vector-role : Extract Vector] ********************************************
changed: [centos8]
changed: [ubuntu]
changed: [instance]

TASK [vector-role : Environment Vector] ****************************************
changed: [ubuntu]
changed: [centos8]
changed: [instance]

PLAY RECAP *********************************************************************
centos8                    : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance                   : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [instance]
ok: [centos8]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Get Vector distrib] ****************************************
ok: [ubuntu]
ok: [instance]
ok: [centos8]

TASK [vector-role : Create directory for Vector] *******************************
ok: [ubuntu]
ok: [centos8]
ok: [instance]

TASK [vector-role : Extract Vector] ********************************************
skipping: [centos8]
skipping: [instance]
skipping: [ubuntu]

TASK [vector-role : Environment Vector] ****************************************
ok: [ubuntu]
ok: [instance]
ok: [centos8]

PLAY RECAP *********************************************************************
centos8                    : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Get Vector version] ******************************************************
ok: [centos8]
ok: [ubuntu]
ok: [instance]

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (299 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (298 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (297 retries left).
changed: [localhost] => (item=instance)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

</details><br>

[ссылка на репозиторий с тегом - 0.26.2](https://github.com/NotClove/netology-ansible-vector/releases/tag/0.26.2)<br>

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Ссылка на репозиторий являются ответами на домашнее задание. Не забудьте указать в ответе теги решений Tox и Molecule заданий.

<details>
    <summary>Лог тестирования tox</summary>

```bash
[root@6afb82c2e95c vector-role]# tox
py38-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==2.1.0,ansible-lint==5.1.1,arrow==1.2.2,attrs==21.4.0,bcrypt==3.2.2,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.0,chardet==4.0.0,charset-normalizer==2.0.12,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==37.0.2,distro==1.7.0,enrich==1.2.7,idna==3.3,importlib-resources==5.8.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.6.0,lxml==4.9.0,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.9.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.12.0,PyNaCl==1.5.0,pyparsing==3.0.9,pyrsistent==0.18.1,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.0,rich==12.4.4,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,typing_extensions==4.2.0,urllib3==1.26.9,wcmatch==8.4,yamllint==1.20.0,zipp==3.8.0
py38-ansible210 run-test-pre: PYTHONHASHSEED='3033535262'
py38-ansible210 run-test: commands[0] | molecule test -s centos-podman --destroy always
INFO     centos-podman scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/my_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running centos-podman > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running centos-podman > lint
INFO     Lint is disabled.
INFO     Running centos-podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos-podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '8692410052.26853', 'results_file': '/root/.ansible_async/8692410052.26853', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running centos-podman > syntax

playbook: /opt/vector-role/molecule/centos-podman/converge.yml
INFO     Running centos-podman > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running centos-podman > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running centos-podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector-role : Vector | install Vector distrib | CentOS] ******************
changed: [instance]

TASK [vector-role : Vector | install Vector distrib | Ubuntu] ******************
skipping: [instance]

TASK [vector-role : Vector | Create directory for Vector logs] *****************
changed: [instance]

TASK [vector-role : Vector | Template config] **********************************
changed: [instance]

TASK [vector-role : Vector | create systemd unit] ******************************
changed: [instance]

TASK [vector-role : Vector | Start service] ************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running centos-podman > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector-role : Vector | install Vector distrib | CentOS] ******************
ok: [instance]

TASK [vector-role : Vector | install Vector distrib | Ubuntu] ******************
skipping: [instance]

TASK [vector-role : Vector | Create directory for Vector logs] *****************
ok: [instance]

TASK [vector-role : Vector | Template config] **********************************
ok: [instance]

TASK [vector-role : Vector | create systemd unit] ******************************
ok: [instance]

TASK [vector-role : Vector | Start service] ************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running centos-podman > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running centos-podman > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Get Vector version] ******************************************************
ok: [instance]

TASK [Assert Vector instalation] ***********************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validate vector config file] *********************************************
ok: [instance]

TASK [Assert Vector validate config] *******************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running centos-podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos-podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '768068472003.29369', 'results_file': '/root/.ansible_async/768068472003.29369', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py38-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==2.1.0,ansible-lint==5.1.1,arrow==1.2.2,attrs==21.4.0,bcrypt==3.2.2,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.0,chardet==4.0.0,charset-normalizer==2.0.12,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==37.0.2,distro==1.7.0,enrich==1.2.7,idna==3.3,importlib-resources==5.8.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.6.0,lxml==4.9.0,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.9.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.12.0,PyNaCl==1.5.0,pyparsing==3.0.9,pyrsistent==0.18.1,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.0,rich==12.4.4,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,typing_extensions==4.2.0,urllib3==1.26.9,wcmatch==8.4,yamllint==1.20.0,zipp==3.8.0
py38-ansible30 run-test-pre: PYTHONHASHSEED='3033535262'
py38-ansible30 run-test: commands[0] | molecule test -s centos-podman --destroy always
INFO     centos-podman scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/my_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running centos-podman > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running centos-podman > lint
INFO     Lint is disabled.
INFO     Running centos-podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos-podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '753532873525.29538', 'results_file': '/root/.ansible_async/753532873525.29538', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running centos-podman > syntax

playbook: /opt/vector-role/molecule/centos-podman/converge.yml
INFO     Running centos-podman > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running centos-podman > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running centos-podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector-role : Vector | install Vector distrib | CentOS] ******************
changed: [instance]

TASK [vector-role : Vector | install Vector distrib | Ubuntu] ******************
skipping: [instance]

TASK [vector-role : Vector | Create directory for Vector logs] *****************
changed: [instance]

TASK [vector-role : Vector | Template config] **********************************
changed: [instance]

TASK [vector-role : Vector | create systemd unit] ******************************
changed: [instance]

TASK [vector-role : Vector | Start service] ************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running centos-podman > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector-role : Vector | install Vector distrib | CentOS] ******************
ok: [instance]

TASK [vector-role : Vector | install Vector distrib | Ubuntu] ******************
skipping: [instance]

TASK [vector-role : Vector | Create directory for Vector logs] *****************
ok: [instance]

TASK [vector-role : Vector | Template config] **********************************
ok: [instance]

TASK [vector-role : Vector | create systemd unit] ******************************
ok: [instance]

TASK [vector-role : Vector | Start service] ************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running centos-podman > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running centos-podman > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Get Vector version] ******************************************************
ok: [instance]

TASK [Assert Vector instalation] ***********************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validate vector config file] *********************************************
ok: [instance]

TASK [Assert Vector validate config] *******************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running centos-podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos-podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '324282506583.32042', 'results_file': '/root/.ansible_async/324282506583.32042', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==2.1.0,ansible-lint==5.1.1,arrow==1.2.2,attrs==21.4.0,bcrypt==3.2.2,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.0,chardet==4.0.0,charset-normalizer==2.0.12,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==37.0.2,distro==1.7.0,enrich==1.2.7,idna==3.3,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.6.0,lxml==4.9.0,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.9.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.12.0,PyNaCl==1.5.0,pyparsing==3.0.9,pyrsistent==0.18.1,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.0,rich==12.4.4,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,urllib3==1.26.9,wcmatch==8.4,yamllint==1.20.0
py39-ansible210 run-test-pre: PYTHONHASHSEED='3033535262'
py39-ansible210 run-test: commands[0] | molecule test -s centos-podman --destroy always
INFO     centos-podman scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/my_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running centos-podman > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running centos-podman > lint
INFO     Lint is disabled.
INFO     Running centos-podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos-podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '266176068356.32193', 'results_file': '/root/.ansible_async/266176068356.32193', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running centos-podman > syntax

playbook: /opt/vector-role/molecule/centos-podman/converge.yml
INFO     Running centos-podman > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running centos-podman > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running centos-podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector-role : Vector | install Vector distrib | CentOS] ******************
changed: [instance]

TASK [vector-role : Vector | install Vector distrib | Ubuntu] ******************
skipping: [instance]

TASK [vector-role : Vector | Create directory for Vector logs] *****************
changed: [instance]

TASK [vector-role : Vector | Template config] **********************************
changed: [instance]

TASK [vector-role : Vector | create systemd unit] ******************************
changed: [instance]

TASK [vector-role : Vector | Start service] ************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running centos-podman > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector-role : Vector | install Vector distrib | CentOS] ******************
ok: [instance]

TASK [vector-role : Vector | install Vector distrib | Ubuntu] ******************
skipping: [instance]

TASK [vector-role : Vector | Create directory for Vector logs] *****************
ok: [instance]

TASK [vector-role : Vector | Template config] **********************************
ok: [instance]

TASK [vector-role : Vector | create systemd unit] ******************************
ok: [instance]

TASK [vector-role : Vector | Start service] ************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running centos-podman > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running centos-podman > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Get Vector version] ******************************************************
ok: [instance]

TASK [Assert Vector instalation] ***********************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validate vector config file] *********************************************
ok: [instance]

TASK [Assert Vector validate config] *******************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running centos-podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos-podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (298 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '568106563800.34674', 'results_file': '/root/.ansible_async/568106563800.34674', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==2.1.0,ansible-lint==5.1.1,arrow==1.2.2,attrs==21.4.0,bcrypt==3.2.2,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.0,chardet==4.0.0,charset-normalizer==2.0.12,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==37.0.2,distro==1.7.0,enrich==1.2.7,idna==3.3,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.6.0,lxml==4.9.0,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.9.0,pluggy==0.13.1,pycparser==2.21,Pygments==2.12.0,PyNaCl==1.5.0,pyparsing==3.0.9,pyrsistent==0.18.1,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.0,rich==12.4.4,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,urllib3==1.26.9,wcmatch==8.4,yamllint==1.20.0
py39-ansible30 run-test-pre: PYTHONHASHSEED='3033535262'
py39-ansible30 run-test: commands[0] | molecule test -s centos-podman --destroy always
INFO     centos-podman scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/my_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running centos-podman > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running centos-podman > lint
INFO     Lint is disabled.
INFO     Running centos-podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos-podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '228796587171.34835', 'results_file': '/root/.ansible_async/228796587171.34835', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running centos-podman > syntax

playbook: /opt/vector-role/molecule/centos-podman/converge.yml
INFO     Running centos-podman > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running centos-podman > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running centos-podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector-role : Vector | install Vector distrib | CentOS] ******************
changed: [instance]

TASK [vector-role : Vector | install Vector distrib | Ubuntu] ******************
skipping: [instance]

TASK [vector-role : Vector | Create directory for Vector logs] *****************
changed: [instance]

TASK [vector-role : Vector | Template config] **********************************
changed: [instance]

TASK [vector-role : Vector | create systemd unit] ******************************
changed: [instance]

TASK [vector-role : Vector | Start service] ************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running centos-podman > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector-role : Vector | install Vector distrib | CentOS] ******************
ok: [instance]

TASK [vector-role : Vector | install Vector distrib | Ubuntu] ******************
skipping: [instance]

TASK [vector-role : Vector | Create directory for Vector logs] *****************
ok: [instance]

TASK [vector-role : Vector | Template config] **********************************
ok: [instance]

TASK [vector-role : Vector | create systemd unit] ******************************
ok: [instance]

TASK [vector-role : Vector | Start service] ************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running centos-podman > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running centos-podman > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Get Vector version] ******************************************************
ok: [instance]

TASK [Assert Vector instalation] ***********************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validate vector config file] *********************************************
ok: [instance]

TASK [Assert Vector validate config] *******************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running centos-podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos-podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '612360123510.37314', 'results_file': '/root/.ansible_async/612360123510.37314', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
________________________________________________________________________________ summary ________________________________________________________________________________
  py38-ansible210: commands succeeded
  py38-ansible30: commands succeeded
  py39-ansible210: commands succeeded
  py39-ansible30: commands succeeded
  congratulations :)
```

</details><br>

[ссылка на репозиторий с тегом - 0.26.3](https://github.com/NotClove/netology-ansible-vector/releases/tag/0.26.3)
