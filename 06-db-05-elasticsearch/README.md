# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch

```docker
FROM centos:centos7

RUN groupadd --gid 1000 elasticsearch && \
        adduser --uid 1000 --gid 1000 --home /usr/share/elasticsearch elasticsearch && \
        mkdir /var/lib/elasticsearch/ && \
        chown -R 1000:1000 /var/lib/elasticsearch/

USER 1000:1000

WORKDIR /usr/share/elasticsearch

COPY ./elasticsearch-8.5.3-linux-x86_64.tar.gz .

RUN tar -xzf elasticsearch-8.5.3-linux-x86_64.tar.gz && \
    cp -rp elasticsearch-8.5.3/* ./ && \
    rm -rf elasticsearch-8.5.3* && \
    echo "node.name: netology_node" >> /usr/share/elasticsearch/config/elasticsearch.yml;\
    echo "network.host: 0.0.0.0" >> /usr/share/elasticsearch/config/elasticsearch.yml;\
    echo "discovery.type: single-node" >> /usr/share/elasticsearch/config/elasticsearch.yml;\
    echo "path.repo: /var/lib/elasticsearch" >> /usr/share/elasticsearch/config/elasticsearch.yml;

EXPOSE 9200

ENTRYPOINT ["bin/elasticsearch"]
```

- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий


[Dockerhub link](https://hub.docker.com/repository/docker/notclove/elastic)

```js
curl --insecure -u elastic:ydX8peqO5O+xcfk-lj_U https://localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "eFk4VRhXTfGg63WoWHjSkA",
  "version" : {
    "number" : "8.5.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "4ed5ee9afac63de92ec98f404ccbed7d3ba9584e",
    "build_date" : "2022-12-05T18:22:22.226119656Z",
    "build_snapshot" : false,
    "lucene_version" : "9.4.2",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```js
curl -X PUT --insecure -u elastic "https://localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,
      "number_of_replicas": 0
    }
  }
}
'
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
curl -X PUT --insecure -u elastic "https://localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 2,
      "number_of_replicas": 1
    }
  }
}
'
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
curl -X PUT --insecure -u elastic "https://localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 4,
      "number_of_replicas": 2
    }
  }
}
'
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}
```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```js
clove@ub1:~$ curl -X GET --insecure -u elastic "https://localhost:9200/_cat/indices?v=true"
Enter host password for user 'elastic':
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 zJNH3N9kS5KVJXkt7MLBNw   1   0          0            0       225b           225b
yellow open   ind-3 1fAv5VfJR46GBlUoaUv-UQ   4   2          0            0       900b           900b
yellow open   ind-2 qsQyfoTEReqNDZqO6IPzkQ   2   1          0            0       450b           450b
```

Получите состояние кластера `elasticsearch`, используя API.

```js
curl -X GET --insecure -u elastic:ydX8peqO5O+xcfk-lj_U "https://localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 47.368421052631575
}
```


Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

```
У нас в кластере "unassigned_shards" : 10
```

Удалите все индексы.

```js
curl -X DELETE --insecure -u elastic:ydX8peqO5O+xcfk-lj_U "https://localhost:9200/ind-1?pretty"
{
  "acknowledged" : true
}
curl -X DELETE --insecure -u elastic:ydX8peqO5O+xcfk-lj_U "https://localhost:9200/ind-2?pretty"
{
  "acknowledged" : true
}
curl -X DELETE --insecure -u elastic:ydX8peqO5O+xcfk-lj_U "https://localhost:9200/ind-3?pretty"
{
  "acknowledged" : true
}
```


## Задача 3

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

```js 
curl -X PUT --insecure -u elastic:ydX8peqO5O+xcfk-lj_U https://localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d' { "type": "fs", "settings": { "location": "/var/lib/elasticsearch/snapshots"}}'
{
  "acknowledged" : true
}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```js
curl -X PUT --insecure -u elastic:ydX8peqO5O+xcfk-lj_U 'https://localhost:9200/test?pretty' -H 'Content-Type: application/json' -d'{"settings" : {"index" : {"number_of_shards" : 1, "number_of_replicas" : 0 }}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}

curl -X GET --insecure -u elastic:ydX8peqO5O+xcfk-lj_U "https://localhost:9200/_cat/indices?v=true"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  gzdAHGwiRjS10J9-2ORrHw   1   0          0            0       225b           225b
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

```js
curl -X PUT --insecure -u elastic:ydX8peqO5O+xcfk-lj_U "https://localhost:9200/_snapshot/netology_backup/test_backup?pretty"
{
  "accepted" : true
}

[elasticsearch@96a7fe1dadb6 snapshots]$ ll
total 36
-rw-r--r-- 1 elasticsearch elasticsearch  1097 Jan  1 19:02 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Jan  1 19:02 index.latest
drwxr-xr-x 5 elasticsearch elasticsearch  4096 Jan  1 19:02 indices
-rw-r--r-- 1 elasticsearch elasticsearch 18679 Jan  1 19:02 meta-PI_BChVCSwqSXIFlvQpjiA.dat
-rw-r--r-- 1 elasticsearch elasticsearch   390 Jan  1 19:02 snap-PI_BChVCSwqSXIFlvQpjiA.da
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```js
curl -X DELETE --insecure -u elastic:ydX8peqO5O+xcfk-lj_U "https://localhost:9200/test?pretty"
{
  "acknowledged" : true
}
curl -X PUT --insecure -u elastic:ydX8peqO5O+xcfk-lj_U 'https://localhost:9200/test2?pretty' -H 'Content-Type: application/json' -d'{"settings" : {"index" : {"number_of_shards" : 1, "number_of_replicas" : 0 }}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test2"
}

curl -X GET --insecure -u elastic:ydX8peqO5O+xcfk-lj_U "https://localhost:9200/_cat/indices?v=true"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test2 FCybysEqR7idMdg9thFJIg   1   0          0            0       225b           225b
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```js
curl -X GET --insecure -u elastic:ydX8peqO5O+xcfk-lj_U "https://localhost:9200/_snapshot/netology_backup/*?verbose=false&pretty"
{
  "snapshots" : [
    {
      "snapshot" : "test_backup",
      "uuid" : "c0Qp3EN4TMKsKurNQgIKYg",
      "repository" : "netology_backup",
      "indices" : [
        ".geoip_databases",
        ".security-7",
        "test"
      ],
      "data_streams" : [ ],
      "state" : "SUCCESS"
    }
  ],
  "total" : 1,
  "remaining" : 0
}

curl -X POST --insecure -u elastic:ydX8peqO5O+xcfk-lj_U "https://localhost:9200/_snapshot/netology_backup/test_backup/_restore?pretty" -H 'Content-Type: application/json' -d'
{
  "indices": "*",
  "include_global_state": true
}
'
{
  "accepted" : true
}

curl -X GET --insecure -u elastic:ydX8peqO5O+xcfk-lj_U "https://localhost:9200/_cat/indices?v=true"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test2 FCybysEqR7idMdg9thFJIg   1   0          0            0       225b           225b
green  open   test  It0T6ilFQ-GNe8QSDmRXDw   1   0          0            0       225b           225b
```
