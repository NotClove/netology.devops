# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательные задания

1. Есть скрипт:
    ```bash
    a=1
    b=2
    c=a+b
    d=$a+$b
    e=$(($a+$b))
    ```
    * Какие значения переменным c,d,e будут присвоены?
	
	![01](https://github.com/NotClove/netology.devops/blob/master/04-script-01-bash/pics/01.jpg?raw=true)

    * Почему?

	```
	Конструкция (( выражение )) позволяет вычислить арифметическое выражение
	```

2. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
    ```bash
    while ((1==1)
    do
    curl https://localhost:4757
    if (($? != 0))
    then
    date >> curl.log
    fi
    done
    ```
	```bash
    Если сайт доступен, скрит пропускает шаг и ничего не делает: если не доступен, записывает дату в файл curl.log, проверка происходит каждые 10 секунд.
	Рабочий скрипт:
 	while ((1==1))
    do
    	curl https://localhost:4757
    	if (($? != 0))
    	then
    		date >> curl.log
        else :
    	fi
 		sleep 10
    done
	```   


3. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.

    ```bash
    #!/bin/bash
        
    target=(192.168.0.1 173.194.222.113 87.250.250.242)
    port=80
    timeout=5
   
    for i in ${target[@]}
    do
      for k in {1..5}
      do
            echo "LOOP #$k ---------------- checking $i"
            curl --connect-timeout $timeout $i:$port
            if [[ "$?" -eq 28 ]]; then
                    echo "`date` :: $i is timeout" >> result.log
                    echo "timeout"
            else
                    echo "`date` :: $i is ok" >> result.log
                    echo "ok"
            fi
      done
    done
    ```

4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается

    ```bash
    #!/bin/bash

    target=(192.168.0.1 173.194.222.113 87.250.250.242)
    port=80
    timeout=5

    while (( 1 == 1 ))
    do
        for i in ${target[@]}
        do
                echo "---------------- checking $i"
                curl --connect-timeout $timeout $i:$port
                if [[ "$?" -eq 0 ]]; then
                        echo "$i is ok"
                else
                        echo "`date` :: ERROR - $i is not available" >> result.log
                        echo "ERROR - $i is not available, exiting"
                exit
                fi
        done
        sleep 10
    done
    ```
