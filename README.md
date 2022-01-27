# devops-netology

## Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

1) Создал свой репозиторий c названием nginx. В качестве образа выбрал официальный образ nginx:1.20.2. Далее, делаем форк образа

```bash
constantine@constantine:~$ docker pull nginx:1.20.2
```

После этого реализуем доп. функциональность, создав небольшой Dockerfile (директория docker/exercise_1)

```dockerfile
FROM nginx:1.20.2

COPY ./index.html /usr/share/nginx/html/index.html

ENTRYPOINT ["nginx", "-g", "daemon off;"]
```
, после чего соберем образ

```bash
constantine@constantine:~/PycharmProjects/devops-netology/docker/exercise_1$ docker build -t constantinenasiescu/nginx:1.0 .
Sending build context to Docker daemon  3.072kB
Step 1/3 : FROM nginx:1.20.2
 ---> d6c9558ba445
Step 2/3 : COPY ./index.html /usr/share/nginx/html/index.html
 ---> df56d0ae007d
Step 3/3 : ENTRYPOINT ["nginx", "-g", "daemon off;"]
 ---> Running in 0c6cf3b4df60
Removing intermediate container 0c6cf3b4df60
 ---> f04a6e320e48
Successfully built f04a6e320e48
Successfully tagged nginx:1.0
```

и запустим контейнер командой docker run -it -p 8080:80 --name nginx_custom nginx:1.0. Результат после запуска контейнера

![ex1](./img/ex1.png)

После этого, пушим полученный образ в docker hub 

```bash
constantine@constantine:~$ docker push constantinenasiescu/nginx:1.0
```

Ссылка на образ [в docker hub](https://hub.docker.com/repository/docker/constantinenasiescu/nginx)

2) Сценарий:

* Высоконагруженное монолитное java веб-приложение; - нет, т.к. такое приложение, как правило, требовательно к ресурсам. В данном случае лучше использовать физическую машину, для прямого доступа к аппаратным ресурсам.
* Nodejs веб-приложение; - да. В данном случае можно будет удобно перезапускать упавшие контейнеры и масштабировать приложение в системах оркестрации, регулируя количество контейнеров, в зависимости от нагрузки.
* Мобильное приложение c версиями для Android и iOS; - да, т.к. приложение можно запускать на любой системе не беспокоясь проблемах с совместимостью и пр.
* Шина данных на базе Apache Kafka; - нет. Kafka это в первую очередь in-memory очередь, следовательно, она чувствительна к аппаратным ресурсам, в первую очередь к оперативной памяти. Наилучшим решением, на мой взгляд будет физический сервер.
* Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana; - и да и нет. Для тестовых сред еще можно развернуть elasticsearch в контейнерах, но на продуктиве, на мой взгляд, из-за возможных нагрузок на сервер и высокого потребления ресурсов (в первую очередь оперативной памяти) лучше использовать физические или виртуальные машины (в зависимости от доступных для нас ресурсов) для создания масштабируемой распределенной системы.
* Мониторинг-стек на базе Prometheus и Grafana; - и да и нет, т.к. опять же зависит от того, где и как мы будем использовать Prometheus и Grafana. Если это, скажем, графана, которая используется для мониторинга инфраструктуры в крупной компании, то это физическая или виртуальная машина. Для каких-то менее глобальных задач (например, для мониторинга внутренних приложений и сервисов небольшого отдела или команды) можно обойтись и контейнеризацией.
* MongoDB, как основное хранилище данных для java-приложения; - да. Если у нас, скажем, небольшой сервис, где объемы данных и нагрузка не так велики, как для высоконагруженных БД.
* Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry. - и да и нет. Опять же все зависит от ситуации. Такие серверы чувствительны аппаратным ресурсам (работа с жестким диском, оперативной памятью, сетью). Если нам нужен gitlab или docker registry, которая управляет процессами для большой организации (банки, крупные компании), то лучше выбрать физический сервер или виртуализацию.
Однако, если мы имеем дело с небольшой командой, скажем разработки или автотестирования для реализации каких-то внутренних микросервисов и приложений, то, на мой взгляд, вполне можно использовать контейнеризацию.

3) Для начала скачаем из docker hub необходимые образы

```bash
constantine@constantine:~$ docker pull centos:centos8.4.2105
centos8.4.2105: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:centos8.4.2105
docker.io/library/centos:centos8.4.2105

constantine@constantine:~$ docker pull debian:stable-slim
stable-slim: Pulling from library/debian
a9500b2c9077: Pull complete 
Digest: sha256:d721cdc17ce7e73a42c567ca3882c059d6ed1fe55eee12f9591095947ece3850
Status: Downloaded newer image for debian:stable-slim
docker.io/library/debian:stable-slim
```

запустим образы в фоновом режиме

```bash
constantine@constantine:~$ docker run -it -v ~/data/common:/data -d --name centos centos:centos8.4.2105
392c550fe374a96c5f72fb26f3b497a98da5f06cb47424ea0528a0b79f1f3e4d
constantine@constantine:~$ docker run -it -v ~/data/common:/data -d --name debian debian:stable-slim
cd70491a9956fb864847b0226c44447b9cc100ed1937d5628b232923d848cd0b
```

создадим в первом контейнере в директории /data и на хостовой машине в директории /data/common два файла

```bash
constantine@constantine:~$ docker exec -it centos /bin/bash
[root@392c550fe374 /]# cd data
[root@392c550fe374 data]# echo "Hello world" > hello.txt

constantine@constantine:~$ echo "One more hello world" | sudo tee ~/data/common/hello2.txt
One more hello world
```

далее, проверим их наличие и содержание во втором контейнере в папке /data

```bash
constantine@constantine:~$ docker exec -it debian /bin/bash
root@cd70491a9956:/# cd data
root@cd70491a9956:/data# ls -l
total 8
-rw-r--r-- 1 root root 12 Jan 27 19:25 hello.txt
-rw-r--r-- 1 root root 21 Jan 27 19:33 hello2.txt
root@cd70491a9956:/data# cat hello.txt 
Hello world
root@cd70491a9956:/data# cat hello2.txt
One more hello world
```

4) Выполнено. https://hub.docker.com/repository/docker/constantinenasiescu/ansible