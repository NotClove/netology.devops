# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"


1. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?
    ```commandline
    cpu: 2
    memory: 1024mb
    hdd: 64gb
    ```
2. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: [документация](https://www.vagrantup.com/docs/providers/virtualbox/configuration.html). Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
    ```commandline
    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.provider :virtualbox do |v|
            v.memory = 2048
            v.cpus = 3
        end
     end
    ```
3. Ознакомиться с разделами `man bash`, почитать о настройках самого bash:
    * какой переменной можно задать длину журнала `history`, и на какой строчке manual это описывается?
   ```
   Номера строчек отдельная история, на разных расширениях экрана, отображаются разные номера строк
   данная нумерация взята из man bash и внутри введена команда -N
   ```
    ```
       1968        On  startup, the history is initialized from the file named by the variable HISTFILE (default ~/.bash_history).  The file named by the value of HISTFILE is truncated, if neces-
       1969        sary, to contain no more than the number of lines specified by the value of HISTFILESIZE.  When an interactive shell exits, the last $HISTSIZE lines are copied from the history
       1970        list  to  $HISTFILE.   If  the histappend shell option is enabled (see the description of shopt under SHELL BUILTIN COMMANDS below), the lines are appended to the history file,
       1971        otherwise the history file is overwritten.  If HISTFILE is unset, or if the history file is unwritable, the history is not saved.  After saving the history, the history file is
       1972        truncated to contain no more than HISTFILESIZE lines.  If HISTFILESIZE is not set, no truncation is performed.
    ```
    * что делает директива `ignoreboth` в bash?
    ```
      HISTCONTROL
   A colon-separated list of values controlling how commands are saved on the history list.  If the list of values includes ignorespace, lines  which  begin  with  a  space
   character are not saved in the history list.  A value of ignoredups causes lines matching the previous history entry to not be saved.  A value of ignoreboth is shorthand
   for ignorespace and ignoredups.
   ```
4. В каких сценариях использования применимы скобки `{}` и на какой строчке `man bash` это описано?
   ```
   Глобально {} - это зарезервированные слова, которые могут участвовать в различных сценариях, далее по заданию в следующем пункте будет отличный пример формирования списков через фигурные скобки
    198        { list; }
    199        list  is simply executed in the current shell environment.  list must be terminated with a newline or semicolon.  This is known as a group command.  The return status is
    200        the exit status of list.  Note that unlike the metacharacters ( and ), { and } are reserved words and must occur where a reserved word is  permitted  to  be  recognized.
    201        Since they do not cause a word break, they must be separated from list by whitespace. 
   
   ```
5. С учётом ответа на предыдущий вопрос, как создать однократным вызовом `touch` 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?
    ```bash
   touch filename{1..100000}
   ```
   ```
   При попытке создать 300000 файлов появится ошибка:
   -bash: /usr/bin/touch: Argument list too long
   так происходит по причине что линукс исполняет команду в формате:
   touch filename1 touch filename2 touch filename3...
   команда выходит за максимальную длину аргумента, посмотреть это значение можно командой: getconf ARG_MAX
   ```
6. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`
   ```
   Возвращает значение 0 или 1 для выражения в скобках, в данном случае команда служит для проверки наличия каталога /tmp
   например: [[ -d /tmpc ]] && echo "+"
   ```
7. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:

    ```bash
    bash is /tmp/new_path_directory/bash
    bash is /usr/local/bin/bash
    bash is /bin/bash
    ```

    (прочие строки могут отличаться содержимым и порядком)
    В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.
   ```
   mkdir /tmp/new_path_directory
   cp /bin/bash /tmp/new_path_directory/
   PATH=/tmp/new_path_directory/:$PATH
   ```

9. Чем отличается планирование команд с помощью `batch` и `at`?
   ```commandline
   batch - используется для выполнения разовой задачи, когда значение _LOADAVG_MX падает до (1.5)
   at    - выполняет задачу в конкретное время
   ```