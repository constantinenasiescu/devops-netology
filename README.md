# devops-netology

## Домашнее задание к занятию "6.5. Elasticsearch"

1) Выполнено. Докерфайл.

```dockerfile
FROM centos:7

LABEL ElasticSearch Centos 7

USER root

ENV USER_HOME /home/elasticsearch

RUN yum update -y --quiet \
    && yum install -y --quiet java-1.8.0-openjdk.x86_64 \ 
    && yum install -y --quiet wget \
    && yum install -y --quiet tar \
    && groupadd elasticsearch \
    && useradd elasticsearch -g elasticsearch -c 'Elasticsearch User' -d $USER_HOME
    
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.322.b06-1.el7_9.x86_64/jre
ENV PATH $PATH:$JAVA_HOME/bin

WORKDIR $USER_HOME

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.11.1-linux-x86_64.tar.gz \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.11.1-linux-x86_64.tar.gz.sha512 \
    && yum install perl-Digest-SHA -y \
    && shasum -a 512 -c elasticsearch-7.11.1-linux-x86_64.tar.gz.sha512 \ 
    && tar -xzf elasticsearch-7.11.1-linux-x86_64.tar.gz \
    && yum upgrade -y \
    && mkdir -p /var/lib/{logs,data} \
    && chmod -R 777 /var/lib/{logs,data} \
    && chgrp -R elasticsearch /var/lib/{logs,data} \
    && chmod -R 777 $USER_HOME/elasticsearch-7.11.1\
    && mkdir $USER_HOME/elasticsearch-7.11.1/snapshots \
    && chown elasticsearch:elasticsearch $USER_HOME/elasticsearch-7.11.1/snapshots \
    && rm $USER_HOME/elasticsearch-7.11.1-linux-x86_64.tar.gz \
    && rm $USER_HOME/elasticsearch-7.11.1-linux-x86_64.tar.gz.sha512
    
ADD elasticsearch.yml $USER_HOME/elasticsearch-7.11.1/config/

ENV ES_HOME $USER_HOME/elasticsearch-7.11.1
ENV ES_CONFIG $USER_HOME/elasticsearch-7.11.1/config/elasticsearch.yml 
  
EXPOSE 9200 9300

USER elasticsearch

CMD "/usr/sbin/init"; "/home/elasticsearch/elasticsearch-7.11.1/bin/elasticsearch"
```

elasticsearch.yml

```yaml
cluster.name: netology_test
discovery.type: single-node
path.data: /var/lib/data
path.logs: /var/lib/logs
path.repo: /home/elasticsearch/elasticsearch-7.11.1/snapshots
network.host: 0.0.0.0
discovery.seed_hosts: ["127.0.0.1", "[::1]"]
xpack.security.enabled: false
```

ответ elasticsearch на запрос пути / 

```json
{
  "name" : "5120cf1a2d70",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "tQSoia4CShef-Bw__gvR5A",
  "version" : {
    "number" : "7.11.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "ff17057114c2199c9c1bbecc727003a907c0db7a",
    "build_date" : "2021-02-15T13:44:09.394032Z",
    "build_snapshot" : false,
    "lucene_version" : "8.7.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

Образ доступен по ссылке [hub.docker.com](https://hub.docker.com/repository/docker/constantinenasiescu/centos-elasticsearch)

2) Отправленные запросы.

```bash
constantine@constantine:~$ curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 1,  
>       "number_of_replicas": 0 
>     }
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
constantine@constantine:~$ curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 2,  
>       "number_of_replicas": 1
>     }
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
constantine@constantine:~$ curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 4,  
>       "number_of_replicas": 2
>     }
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}
```

Список индексов.

```bash
constantine@constantine:~$ curl -X GET "localhost:9200/_cat/indices" -H 'Content-Type: application/json'
green  open ind-1 19wudpKkTsyXTwiuiKufHA 1 0 0 0 208b 208b
yellow open ind-3 Ic_skCwjScSFOzkCk2cUgw 4 2 0 0 832b 832b
yellow open ind-2 SvlScWKbQ8OZ77AnJ1_Hcw 2 1 0 0 416b 416b
```

Статусы индексов.

```bash
constantine@constantine:~$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
constantine@constantine-:~$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 41.17647058823529
}
constantine@constantine:~$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 41.17647058823529
}

```

Состояние кластера.

```bash
constantine@constantine:~$ curl -XGET localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 7,
  "active_shards" : 7,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 41.17647058823529
}

```

Часть индексов находится в статусе yellow, т.к. в данном случае у нас только одна нода, а для них (индексов) в конфигурации указанно, что необходима репликация, но реплицировать в данном
случае некуда, отсюда и данный статус.

Удаление индексов.

```bash
constantine@constantine:~$ curl -X DELETE 'http://localhost:9200/ind-1?pretty' 
{
  "acknowledged" : true
}
constantine@constantine:~$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
constantine@constantine:~$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
```

3) Выполнено.

```bash
constantine@constantine:~$ curl -XPOST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/home/elasticsearch/elasticsearch-7.11.1/snapshots" }}'
{
  "acknowledged" : true
}
```

Проверка папки для бэкапа http://localhost:9200/_snapshot/netology_backup?pretty

```bash
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/home/elasticsearch/elasticsearch-7.11.1/snapshots"
    }
  }
}
```

Создадим новый индекс

```bash
constantine@constantine:~$ curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
```

http://localhost:9200/test?pretty выдает результат

```bash
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1647878797840",
        "number_of_replicas" : "0",
        "uuid" : "oSsi0K_iQ5u9caR9ECquSQ",
        "version" : {
          "created" : "7110199"
        }
      }
    }
  }
}
```

Далее, создаем бэкап используя запрос curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true

```bash
constantine@constantine-3570R-370R-470R-450R-510R-4450RV:~$ curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","uuid":"L9sYBYu1Qo6o3O28EKIS4Q","version_id":7110199,"version":"7.11.1","indices":["test"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-03-21T16:08:39.577Z","start_time_in_millis":1647878919577,"end_time":"2022-03-21T16:08:39.977Z","end_time_in_millis":1647878919977,"duration_in_millis":400,"failures":[],"shards":{"total":1,"failed":0,"successful":1}}}
```

Проверка папки snapshots

```bash
[elasticsearch@024703627af4 snapshots]$ ls -l
total 48
-rw-r--r-- 1 elasticsearch elasticsearch   437 Mar 21 16:08 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Mar 21 16:08 index.latest
drwxr-xr-x 3 elasticsearch elasticsearch  4096 Mar 21 16:08 indices
-rw-r--r-- 1 elasticsearch elasticsearch 31063 Mar 21 16:08 meta-L9sYBYu1Qo6o3O28EKIS4Q.dat
-rw-r--r-- 1 elasticsearch elasticsearch   269 Mar 21 16:08 snap-L9sYBYu1Qo6o3O28EKIS4Q.dat

```

Удалим и создадим новый индекс, после чего выполним восстановление бэкапа.

```bash
[elasticsearch@024703627af4 snapshots]$ curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}
[elasticsearch@024703627af4 snapshots]$ curl -X PUT localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
[elasticsearch@024703627af4 snapshots]$ curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":true}'
{
  "accepted" : true
}
[elasticsearch@024703627af4 snapshots]$ curl -X GET http://localhost:9200/_cat/indices?v
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 2yQlgK1mSjS1L4ofyvQyzg   1   0          0            0       208b           208b
green  open   test   oJzPNDBjS_KV_Zk687eZKQ   1   0          0            0       208b           208b
[elasticsearch@024703627af4 snapshots]$ 

```