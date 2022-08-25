# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"


## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

```
Значительно ускоряет процесс подготовки инфраструктуры для разработки, тестирования и масштабирования.
Автоматизация, которая исключает проблемы с ошибками при ручной подготовки сред для работы.
Всегда есть код, который описывает инфраструктуру, можно отследить изменения.
Главное преимущество IaaC является повторямость результата, он должен быть идентичен предущему запуску.
```

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

```
Ansible использует существующую ssh инфраструктуру.
На мой взгляд надежнее pull метод, т.к в случае недоступности клиента метод push завершится с ошибкой, а в случае с pull, он сам заберет изменения когда сможет.
```

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

```
clove@ubu:~/netology.devops$ vboxmanage -v
6.1.36r152435
clove@ubu:~/netology.devops$ vagrant -v
Vagrant 2.3.0
clove@ubu:~/netology.devops$ ansible --version
ansible [core 2.13.3]
  config file = None
  configured module search path = ['/home/clove/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/clove/.local/lib/python3.10/site-packages/ansible
  ansible collection location = /home/clove/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/clove/.local/bin/ansible
  python version = 3.10.4 (main, Jun 29 2022, 12:14:53) [GCC 11.2.0]
  jinja version = 3.1.2
  libyaml = True
```
 ![01](https://github.com/NotClove/netology.devops/blob/master/05-virt-02-iaac/pics/Screenshot%20from%202022-08-25%2016-41-52.png?raw=true)

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
  
```
docker ps
```
 ![02](https://github.com/NotClove/netology.devops/blob/master/05-virt-02-iaac/pics/Screenshot%20from%202022-08-25%2017-25-03.png?raw=true)