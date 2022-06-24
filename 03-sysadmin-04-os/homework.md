# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    ![01_1](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/01_1.jpg?raw=true)
    ![01_4](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/01_4.jpg?raw=true)
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    ![01_2](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/01_2.jpg?raw=true)
    ![01_3](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/01_3.jpg?raw=true)
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
    ![01_22](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/01_22.jpg?raw=true)

2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
    ```
   для cpu info включил бы метрику --collector.cpu.info
   остальные включены по умолчанию:
   node_cpu_seconds_total counter
   node_memory_MemAvailable
   node_memory_MemFree
   node_memory_MemTotal
   node_disk_io_time
   node_disk_read_time
   node_disk_write_time
   node_network_transmit_bytes
   node_network_transmit_err
   node_network_receive_bytes
   node_network_receive_err
   ```
3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    ![3_2](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/3_2.jpg?raw=true)
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
    ![3_1](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/3_1.jpg?raw=true)

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
   ![04_1](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/4_1.jpg?raw=true)
   ![04_2](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/4_2.jpg?raw=true)
5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

    ![05](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/05.jpg?raw=true)
    ```
    sysctl fs.nr_open - это хард лимит открываемых file descriptors
    его же можно посмотреть командой ulimit -Hn
    кроме того существует софт ограничение, посмотреть лимит ulimit -Sn
    ```


6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
   ![06](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/06.jpg?raw=true)
7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
    ```bash
   :(){ :|:& };: - это замаскированная функция, символ ':' - на самом деле название функции, для простоты понимания, можно разделить на несколько строк изменив название функции:
   fork(){
   fork | fork& 
   }; fork
   Получается зацикленный форк самой себя
   Работу прервал pids controller
   ```
   ![07](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-04-os/pics/7.jpg?raw=true)
    ```
   Лимит запущенных процессов на пользователя можно изменить командой `ulimit -u`
   По умолчанию стоит 7596
   ```
 