# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

   ```commandline
   Хорошее решение для того, что бы разметить файлы заранее, при этом не занимая реального места на жестком диске.
   В повседневной жизний используется часто, например на виртуалках или базы данных.
   ```

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

   ```commandline
   Не могут, т.к эти файлы имеют ссылку на одинаковый инод   
   ```

4. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

5. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

6. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

7. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

8. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

9. Создайте 2 независимых PV на получившихся md-устройствах.

10. Создайте общую volume-group на этих двух PV.

11. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

12. Создайте `mkfs.ext4` ФС на получившемся LV.

13. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

14. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

15. Прикрепите вывод `lsblk`.

16. Протестируйте целостность файла:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```

17. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

18. Сделайте `--fail` на устройство в вашем RAID1 md.

19. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

20. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```

21. Погасите тестовый хост, `vagrant destroy`.
