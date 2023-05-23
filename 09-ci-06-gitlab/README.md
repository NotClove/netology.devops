# Домашнее задание к занятию 12 «GitLab»

## Подготовка к выполнению

1. Подготовьте к работе GitLab [по инструкции](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/gitlab-containers).
2. Создайте свой новый проект.
3. Создайте новый репозиторий в GitLab, наполните его [файлами](./repository).
4. Проект должен быть публичным, остальные настройки по желанию.

## Основная часть

### DevOps

В репозитории содержится код проекта на Python. Проект — RESTful API сервис. Ваша задача — автоматизировать сборку образа с выполнением python-скрипта:

1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated).
2. Python версии не ниже 3.7.
3. Установлены зависимости: `flask` `flask-jsonpify` `flask-restful`.
4. Создана директория `/python_api`.
5. Скрипт из репозитория размещён в /python_api.
6. Точка вызова: запуск скрипта.
7. При комите в любую ветку должен собираться docker image с форматом имени hello:gitlab-$CI_COMMIT_SHORT_SHA . Образ должен быть выложен в Gitlab registry или yandex registry.   
8.* (задание необязательное к выполению) При комите в ветку master после сборки должен подняться pod в kubernetes. Примерный pipeline для push в kubernetes по [ссылке](https://github.com/awertoss/devops-netology/blob/main/09-ci-06-gitlab/gitlab-ci.yml).
Если вы еще не знакомы с k8s - автоматизируйте сборку и деплой приложения в docker на виртуальной машине.


### Product Owner

Вашему проекту нужна бизнесовая доработка: нужно поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:

1. Какой метод необходимо исправить.
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`.
3. Issue поставить label: feature.

### Developer

Пришёл новый Issue на доработку, вам нужно:

1. Создать отдельную ветку, связанную с этим Issue.
2. Внести изменения по тексту из задания.
3. Подготовить Merge Request, влить необходимые изменения в `master`, проверить, что сборка прошла успешно.


### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:

1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность.
2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый.

## Итог

В качестве ответа пришлите подробные скриншоты по каждому пункту задания:

- файл gitlab-ci.yml;
- Dockerfile; 
- лог успешного выполнения пайплайна;
- решённый Issue.

## Ответ:

<details>
    <summary>.gitlab-ci.yml</summary>

```
stages:
  - build
  - deploy

build:
  stage: build
  image:
    name: gcr.io/kaniko-project/executor:debug
    entrypoint: [""]
  script:
    - mkdir -p /kaniko/.docker
    # Install jq.
    - wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && chmod +x ./jq && cp jq /kaniko
    # Get a service account token from metadata.
    - wget --header Metadata-Flavor:Google 169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token && cp token /kaniko
    - echo "{\"auths\":{\"cr.yandex\":{\"auth\":\"$(printf "%s:%s" "iam" "$(cat /kaniko/token | ./jq -r '.access_token')" | base64 | tr -d '\n')\"}}}" > /kaniko/.docker/config.json
    - >-
      /kaniko/executor
      --context "${CI_PROJECT_DIR}"
      --dockerfile "${CI_PROJECT_DIR}/Dockerfile"
      --destination "cr.yandex/crpspv2cvcvvjucql1i1/hello:gitlab-$CI_COMMIT_SHORT_SHA"
    # Delete the metadata file.
    - rm /kaniko/token

deploy:
  image: gcr.io/cloud-builders/kubectl:latest
  stage: deploy
  script:
    - kubectl config set-cluster k8s --server="$KUBE_URL" --insecure-skip-tls-verify=true
    - kubectl config set-credentials admin --token="$KUBE_TOKEN"
    - kubectl config set-context default --cluster=k8s --user=admin
    - kubectl config use-context default
    - sed -i "s/__VERSION__/hello:gitlab-$CI_COMMIT_SHORT_SHA/" k8s.yaml
    - kubectl apply -f k8s.yaml
```
</details><br>

<details>
    <summary>dockerfile</summary>

```dockerfile
FROM centos:7

RUN yum install -y python3 python3-pip

RUN pip3 install flask flask-jsonpify flask-restful

COPY python-api.py /python_api/python-api.py

CMD ["python3", "/python_api/python-api.py"]
```
</details><br>

<details>
    <summary>build pipeline</summary>

```
Running with gitlab-runner 15.8.1 (f86890c6)
  on gitlab-runner-7c9dd68c59-gtgl9 51Vssbmt, system ID: r_NcOTWk9lmf9s
Preparing the "kubernetes" executor
00:00
Using Kubernetes namespace: default
Using Kubernetes executor with image gcr.io/kaniko-project/executor:debug ...
Using attach strategy to execute scripts...
Preparing environment
00:04
Waiting for pod default/runner-51vssbmt-project-2-concurrent-0gsdww to be running, status is Pending
	ContainersNotInitialized: "containers with incomplete status: [init-permissions]"
	ContainersNotReady: "containers with unready status: [build helper]"
	ContainersNotReady: "containers with unready status: [build helper]"
Running on runner-51vssbmt-project-2-concurrent-0gsdww via gitlab-runner-7c9dd68c59-gtgl9...
Getting source from Git repository
00:00
Fetching changes with git depth set to 20...
Initialized empty Git repository in /builds/netology/09-ci-06-gitlab/.git/
Created fresh repository.
Checking out b7b3de2e as main...
Skipping Git submodules setup
Executing "step_script" stage of the job script
00:44
$ mkdir -p /kaniko/.docker
$ wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && chmod +x ./jq && cp jq /kaniko
Connecting to github.com (140.82.121.3:443)
wget: note: TLS certificate validation not implemented
Connecting to objects.githubusercontent.com (185.199.108.133:443)
saving to 'jq'
jq                    10% |***                             |  318k  0:00:08 ETA
jq                   100% |********************************| 2956k  0:00:00 ETA
'jq' saved
$ wget --header Metadata-Flavor:Google 169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token && cp token /kaniko
Connecting to 169.254.169.254 (169.254.169.254:80)
saving to 'token'
token                100% |********************************|   247  0:00:00 ETA
'token' saved
$ echo "{\"auths\":{\"cr.yandex\":{\"auth\":\"$(printf "%s:%s" "iam" "$(cat /kaniko/token | ./jq -r '.access_token')" | base64 | tr -d '\n')\"}}}" > /kaniko/.docker/config.json
$ /kaniko/executor --context "${CI_PROJECT_DIR}" --dockerfile "${CI_PROJECT_DIR}/Dockerfile" --destination "cr.yandex/crpspv2cvcvvjucql1i1/hello:gitlab-$CI_COMMIT_SHORT_SHA"
INFO[0000] Retrieving image manifest centos:7           
INFO[0000] Retrieving image centos:7 from registry index.docker.io 
INFO[0001] Built cross stage deps: map[]                
INFO[0001] Retrieving image manifest centos:7           
INFO[0001] Returning cached image manifest              
INFO[0001] Executing 0 build triggers                   
INFO[0001] Building stage 'centos:7' [idx: '0', base-idx: '-1'] 
INFO[0001] Unpacking rootfs as cmd RUN yum install -y python3 python3-pip requires it. 
INFO[0005] RUN yum install -y python3 python3-pip       
INFO[0005] Initializing snapshotter ...                 
INFO[0005] Taking snapshot of full filesystem...        
INFO[0009] Cmd: /bin/sh                                 
INFO[0009] Args: [-c yum install -y python3 python3-pip] 
INFO[0009] Running: [/bin/sh -c yum install -y python3 python3-pip] 
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: mirrors.datahouse.ru
 * extras: mirror.yandex.ru
 * updates: mirror.yandex.ru
Resolving Dependencies
--> Running transaction check
---> Package python3.x86_64 0:3.6.8-18.el7 will be installed
--> Processing Dependency: python3-libs(x86-64) = 3.6.8-18.el7 for package: python3-3.6.8-18.el7.x86_64
--> Processing Dependency: python3-setuptools for package: python3-3.6.8-18.el7.x86_64
--> Processing Dependency: libpython3.6m.so.1.0()(64bit) for package: python3-3.6.8-18.el7.x86_64
---> Package python3-pip.noarch 0:9.0.3-8.el7 will be installed
--> Running transaction check
---> Package python3-libs.x86_64 0:3.6.8-18.el7 will be installed
--> Processing Dependency: libtirpc.so.1()(64bit) for package: python3-libs-3.6.8-18.el7.x86_64
---> Package python3-setuptools.noarch 0:39.2.0-10.el7 will be installed
--> Running transaction check
---> Package libtirpc.x86_64 0:0.2.4-0.16.el7 will be installed
--> Finished Dependency Resolution
Dependencies Resolved
================================================================================
 Package                  Arch         Version              Repository     Size
================================================================================
Installing:
 python3                  x86_64       3.6.8-18.el7         updates        70 k
 python3-pip              noarch       9.0.3-8.el7          base          1.6 M
Installing for dependencies:
 libtirpc                 x86_64       0.2.4-0.16.el7       base           89 k
 python3-libs             x86_64       3.6.8-18.el7         updates       6.9 M
 python3-setuptools       noarch       39.2.0-10.el7        base          629 k
Transaction Summary
================================================================================
Install  2 Packages (+3 Dependent packages)
Total download size: 9.3 M
Installed size: 48 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/libtirpc-0.2.4-0.16.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for libtirpc-0.2.4-0.16.el7.x86_64.rpm is not installed
Public key for python3-3.6.8-18.el7.x86_64.rpm is not installed
--------------------------------------------------------------------------------
Total                                               35 MB/s | 9.3 MB  00:00     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-9.2009.0.el7.centos.x86_64 (@CentOS)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : libtirpc-0.2.4-0.16.el7.x86_64                               1/5 
  Installing : python3-setuptools-39.2.0-10.el7.noarch                      2/5
 
  Installing : python3-pip-9.0.3-8.el7.noarch                               3/5 
  Installing : python3-3.6.8-18.el7.x86_64                                  4/5
 
  Installing : python3-libs-3.6.8-18.el7.x86_64                             5/5
 
  Verifying  : libtirpc-0.2.4-0.16.el7.x86_64                               1/5 
  Verifying  : python3-setuptools-39.2.0-10.el7.noarch                      2/5 
  Verifying  : python3-libs-3.6.8-18.el7.x86_64                             3/5 
  Verifying  : python3-3.6.8-18.el7.x86_64                                  4/5 
  Verifying  : python3-pip-9.0.3-8.el7.noarch                               5/5 
Installed:
  python3.x86_64 0:3.6.8-18.el7         python3-pip.noarch 0:9.0.3-8.el7        
Dependency Installed:
  libtirpc.x86_64 0:0.2.4-0.16.el7           python3-libs.x86_64 0:3.6.8-18.el7 
  python3-setuptools.noarch 0:39.2.0-10.el7 
Complete!
INFO[0020] Taking snapshot of full filesystem...        
INFO[0027] RUN pip3 install flask flask-jsonpify flask-restful 
INFO[0027] Cmd: /bin/sh                                 
INFO[0027] Args: [-c pip3 install flask flask-jsonpify flask-restful] 
INFO[0027] Running: [/bin/sh -c pip3 install flask flask-jsonpify flask-restful] 
WARNING: Running pip install with root privileges is generally not a good idea. Try `pip3 install --user` instead.
Collecting flask
  Downloading https://files.pythonhosted.org/packages/cd/77/59df23681f4fd19b7cbbb5e92484d46ad587554f5d490f33ef907e456132/Flask-2.0.3-py3-none-any.whl (95kB)
Collecting flask-jsonpify
  Downloading https://files.pythonhosted.org/packages/60/0f/c389dea3988bffbe32c1a667989914b1cc0bce31b338c8da844d5e42b503/Flask-Jsonpify-1.5.0.tar.gz
Collecting flask-restful
  Downloading https://files.pythonhosted.org/packages/d7/7b/f0b45f0df7d2978e5ae51804bb5939b7897b2ace24306009da0cc34d8d1f/Flask_RESTful-0.3.10-py2.py3-none-any.whl
Collecting click>=7.1.2 (from flask)
  Downloading https://files.pythonhosted.org/packages/4a/a8/0b2ced25639fb20cc1c9784de90a8c25f9504a7f18cd8b5397bd61696d7d/click-8.0.4-py3-none-any.whl (97kB)
Collecting itsdangerous>=2.0 (from flask)
  Downloading https://files.pythonhosted.org/packages/9c/96/26f935afba9cd6140216da5add223a0c465b99d0f112b68a4ca426441019/itsdangerous-2.0.1-py3-none-any.whl
Collecting Jinja2>=3.0 (from flask)
  Downloading https://files.pythonhosted.org/packages/20/9a/e5d9ec41927401e41aea8af6d16e78b5e612bca4699d417f646a9610a076/Jinja2-3.0.3-py3-none-any.whl (133kB)
Collecting Werkzeug>=2.0 (from flask)
  Downloading https://files.pythonhosted.org/packages/f4/f3/22afbdb20cc4654b10c98043414a14057cd27fdba9d4ae61cea596000ba2/Werkzeug-2.0.3-py3-none-any.whl (289kB)
Collecting aniso8601>=0.82 (from flask-restful)
  Downloading https://files.pythonhosted.org/packages/e3/04/e97c12dc034791d7b504860acfcdd2963fa21ae61eaca1c9d31245f812c3/aniso8601-9.0.1-py2.py3-none-any.whl (52kB)
Collecting six>=1.3.0 (from flask-restful)
  Downloading https://files.pythonhosted.org/packages/d9/5a/e7c31adbe875f2abbb91bd84cf2dc52d792b5a01506781dbcf25c91daf11/six-1.16.0-py2.py3-none-any.whl
Collecting pytz (from flask-restful)
  Downloading https://files.pythonhosted.org/packages/7f/99/ad6bd37e748257dd70d6f85d916cafe79c0b0f5e2e95b11f7fbc82bf3110/pytz-2023.3-py2.py3-none-any.whl (502kB)
Collecting importlib-metadata; python_version < "3.8" (from click>=7.1.2->flask)
  Downloading https://files.pythonhosted.org/packages/a0/a1/b153a0a4caf7a7e3f15c2cd56c7702e2cf3d89b1b359d1f1c5e59d68f4ce/importlib_metadata-4.8.3-py3-none-any.whl
Collecting MarkupSafe>=2.0 (from Jinja2>=3.0->flask)
  Downloading https://files.pythonhosted.org/packages/fc/d6/57f9a97e56447a1e340f8574836d3b636e2c14de304943836bd645fa9c7e/MarkupSafe-2.0.1-cp36-cp36m-manylinux1_x86_64.whl
Collecting dataclasses; python_version < "3.7" (from Werkzeug>=2.0->flask)
  Downloading https://files.pythonhosted.org/packages/fe/ca/75fac5856ab5cfa51bbbcefa250182e50441074fdc3f803f6e76451fab43/dataclasses-0.8-py3-none-any.whl
Collecting zipp>=0.5 (from importlib-metadata; python_version < "3.8"->click>=7.1.2->flask)
  Downloading https://files.pythonhosted.org/packages/bd/df/d4a4974a3e3957fd1c1fa3082366d7fff6e428ddb55f074bf64876f8e8ad/zipp-3.6.0-py3-none-any.whl
Collecting typing-extensions>=3.6.4; python_version < "3.8" (from importlib-metadata; python_version < "3.8"->click>=7.1.2->flask)
  Downloading https://files.pythonhosted.org/packages/45/6b/44f7f8f1e110027cf88956b59f2fad776cca7e1704396d043f89effd3a0e/typing_extensions-4.1.1-py3-none-any.whl
Installing collected packages: zipp, typing-extensions, importlib-metadata, click, itsdangerous, MarkupSafe, Jinja2, dataclasses, Werkzeug, flask, flask-jsonpify, aniso8601, six, pytz, flask-restful
  Running setup.py install for flask-jsonpify: started
    Running setup.py install for flask-jsonpify: finished with status 'done'
Successfully installed Jinja2-3.0.3 MarkupSafe-2.0.1 Werkzeug-2.0.3 aniso8601-9.0.1 click-8.0.4 dataclasses-0.8 flask-2.0.3 flask-jsonpify-1.5.0 flask-restful-0.3.10 importlib-metadata-4.8.3 itsdangerous-2.0.1 pytz-2023.3 six-1.16.0 typing-extensions-4.1.1 zipp-3.6.0
INFO[0035] Taking snapshot of full filesystem...        
INFO[0037] COPY python-api.py /python_api/python-api.py 
INFO[0037] Taking snapshot of files...                  
INFO[0037] CMD ["python3", "/python_api/python-api.py"] 
INFO[0037] Pushing image to cr.yandex/crpspv2cvcvvjucql1i1/hello:gitlab-b7b3de2e 
INFO[0042] Pushed cr.yandex/crpspv2cvcvvjucql1i1/hello@sha256:58ddacd6cec2a19e34e4c4b7b7048c3c8cdbbe2111a0b972682488a0fb76c5c3 
$ rm /kaniko/token
Cleaning up project directory and file based variables
00:00
Job succeeded
```

</details><br>

<details>
    <summary>deploy pipeline</summary>

deploy:
```
Running with gitlab-runner 15.8.1 (f86890c6)
  on gitlab-runner-7c9dd68c59-gtgl9 51Vssbmt, system ID: r_NcOTWk9lmf9s
Preparing the "kubernetes" executor
00:00
Using Kubernetes namespace: default
Using Kubernetes executor with image gcr.io/cloud-builders/kubectl:latest ...
Using attach strategy to execute scripts...
Preparing environment
00:07
Waiting for pod default/runner-51vssbmt-project-2-concurrent-0k6tw9 to be running, status is Pending
Waiting for pod default/runner-51vssbmt-project-2-concurrent-0k6tw9 to be running, status is Pending
	ContainersNotReady: "containers with unready status: [build helper]"
	ContainersNotReady: "containers with unready status: [build helper]"
Running on runner-51vssbmt-project-2-concurrent-0k6tw9 via gitlab-runner-7c9dd68c59-gtgl9...
Getting source from Git repository
00:01
Fetching changes with git depth set to 20...
Initialized empty Git repository in /builds/netology/09-ci-06-gitlab/.git/
Created fresh repository.
Checking out b7b3de2e as main...
Skipping Git submodules setup
Executing "step_script" stage of the job script
00:02
$ kubectl config set-cluster k8s --server="$KUBE_URL" --insecure-skip-tls-verify=true
Cluster "k8s" set.
$ kubectl config set-credentials admin --token="$KUBE_TOKEN"
User "admin" set.
$ kubectl config set-context default --cluster=k8s --user=admin
Context "default" created.
$ kubectl config use-context default
Switched to context "default".
$ sed -i "s/__VERSION__/hello:gitlab-$CI_COMMIT_SHORT_SHA/" k8s.yaml
$ kubectl apply -f k8s.yaml
namespace/default unchanged
deployment.apps/python-api-deployment configured
Cleaning up project directory and file based variables
00:00
Job succeeded
```
</details><br>

---

Запросы к приложению, до и после issue:<br>

![pics](./pics/Screenshot%202023-05-23%20%D0%B2%2022.46.04.png)

![pics2](./pics/Screenshot%202023-05-23%20%D0%B2%2022.55.55.png)
<br>

issue:<br>

![pics3](./pics/Screenshot%202023-05-23%20%D0%B2%2022.56.27.png)

![pics4](./pics/Screenshot%202023-05-23%20%D0%B2%2022.57.35.png)
<br>

Работа pipeline:<br>

![pics5](./pics/Screenshot%202023-05-23%20%D0%B2%2022.58.26.png)
<br>

Работа pod python-api в kubernetes:<br>

![pics6](./pics/Screenshot%202023-05-23%20%D0%B2%2023.01.43.png)

