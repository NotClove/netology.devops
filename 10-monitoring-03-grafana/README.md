# Домашнее задание к занятию 14 «Средство визуализации Grafana»

## Задание повышенной сложности

**При решении задания 1** не используйте директорию [help](./help) для сборки проекта. Самостоятельно разверните grafana, где в роли источника данных будет выступать prometheus, а сборщиком данных будет node-exporter:

- grafana;
- prometheus-server;
- prometheus node-exporter.

За дополнительными материалами можете обратиться в официальную документацию grafana и prometheus.

В решении к домашнему заданию также приведите все конфигурации, скрипты, манифесты, которые вы 
использовали в процессе решения задания.

**При решении задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например, Telegram или email, и отправить туда тестовые события.

В решении приведите скриншоты тестовых событий из каналов нотификаций.

## Обязательные задания

### Задание 1

1. Используя директорию [help](./help) внутри этого домашнего задания, запустите связку prometheus-grafana.
1. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.
1. Подключите поднятый вами prometheus, как источник данных.
1. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

## Задание 2

Изучите самостоятельно ресурсы:

1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
1. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
1. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).

Создайте Dashboard и в ней создайте Panels:

- утилизация CPU для nodeexporter (в процентах, 100-idle);
- CPULA 1/5/15;
- количество свободной оперативной памяти;
- количество места на файловой системе.

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

## Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
1. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

## Задание 4

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
1. В качестве решения задания приведите листинг этого файла.

---

# Ответ:

## Задание повышенной сложности

[docker-compose file](./conf/docker-compose.yml)

[prometheus config](./conf/prometheus/prometheus.yml)

[prometheus alert](./conf/prometheus/alert.yml)

[alertmanager](./conf/alertmanager/alertmanager.yml)

## Задание 1

![grafana](./pics/Screenshot%202023-05-26%20%D0%B2%2001.20.20.png)

## Задание 2

![!dashboard](./pics/Screenshot%202023-05-26%20%D0%B2%2000.47.31.png)

- утилизация CPU для node_exporter (в процентах, 100-idle);

```
avg by(instance)(rate(node_cpu_seconds_total{job="node-exporter",mode="idle"}[$__rate_interval])) * 100
```

- CPULA 1/5/15;

```
avg by (instance)(rate(node_load1{}[$__rate_interval]))
avg by (instance)(rate(node_load5{}[$__rate_interval]))
avg by (instance)(rate(node_load15{}[$__rate_interval]))
```

- количество свободной оперативной памяти;

```
node_memory_MemFree_bytes{instance="node_exporter:9100", job="node-exporter"}
node_memory_MemTotal_bytes{instance="node_exporter:9100"} - node_memory_MemFree_bytes{instance="node_exporter:9100"} - node_memory_Cached_bytes{instance="node_exporter:9100"} - node_memory_Buffers_bytes{instance="node_exporter:9100"}

```

- количество места на файловой системе.

```
node_filesystem_size_bytes{fstype="ext4",instance="node_exporter:9100"}
node_filesystem_free_bytes{fstype="ext4",instance="node_exporter:9100"}
```

## Задание 3

![dashalerts](./pics/Screenshot%202023-05-26%20%D0%B2%2001.17.55.png)

![alerttelegram](./pics/Screenshot%202023-05-26%20%D0%B2%2000.50.54.png)

![alertprom](./pics/Screenshot%202023-05-26%20%D0%B2%2000.51.09.png)

## Задание 4

[dashboard.json](dashboard.json)