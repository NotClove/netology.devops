# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.

   ![01](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-03-os/pics/01.jpg?raw=true)

2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

   ![02](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-03-os/pics/02.jpg?raw=true)

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

   ![03](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-03-os/pics/03.jpg?raw=true)

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

   ```
   Зомби процессы не занимают ресурсов т.к их функция уже выполнилась и они находятся в состоянии wait()
   ```

5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

   ![05](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-03-os/pics/05.jpg?raw=true)

6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

   ![06_1](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-03-os/pics/06_1.jpg?raw=true)
   ![06_2](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-03-os/pics/06_2.jpg?raw=true)
   ![06_3](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-03-os/pics/06_3.jpg?raw=true)

7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?

   ```bash 
   && - выполняется в случае успешного выполнения команды, ; - выполняется всегда
   Совместное использование && и set -e не имеет смысла, т.к они выполняются при одинаковых условиях и в случае ошибки, обе прекратят дальнейшее выполнение команды
   set -e  Exit immediately if a command exits with a non-zero status. 
   ```

8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

   ```
   -e Exit immediately if a command exits with a non-zero status.
   -u Treat unset variables as an error when substituting.
   -x Print commands and their arguments as they are executed.
   -o pipefail the return value of a pipeline is the status of
                           the last command to exit with a non-zero status,
                           or zero if no command exited with a non-zero status
   Команда повышает детализацию логов и контролирует выполнение всей цепочки, если в процессе выполнения возникнут ошибки, то работа сценария прекратится.
   ```

9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
   
   ![09](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-03-os/pics/09.jpg?raw=true)