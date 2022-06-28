# Дополнение к заданию "3.4. Операционные системы, лекция 2"

1. Предлагаю уточнить как именно в службу будут передаваться дополнительные опции. Примеры можно посмотреть вот здесь:
https://www.freedesktop.org/software/systemd/man/systemd.service.html#ExecStart=
https://unix.stackexchange.com/questions/323914/dynamic-variables-in-systemd-service-unit-files
https://stackoverflow.com/questions/48843949/systemd-use-variables-in-a-unit-file
Замечу, что речь идёт не о переменных окружения, а об опциях (параметрах) запуска службы.


- Примеры для создания unit-файла и environment-файла подсмотрены [тут](https://github.com/prometheus/node_exporter/tree/master/examples/systemd)

    В случае с node_exporter переменные передавались через файл EnvironmentFile, я его не показал в дз, думал что раз переменная у службы есть, значит этого не нужно)

    