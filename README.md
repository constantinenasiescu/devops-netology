### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ                                                                                           |
| ------------- |-------------------------------------------------------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | Никакое, пробросится исключение "TypeError: unsupported operand type(s) for +: 'int' and 'str'" |
| Как получить для переменной `c` значение 12?  | Для этого нужно привести переменную a к типу string (c = str(a) + b).                                                                                             |
| Как получить для переменной `c` значение 3?  | Для этого нужно привести переменную b к типу integer (c = a + int(b))                                                                                             |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/PycharmProjects/devops-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result.find("изменено") != -1:
        prepare_result = result.replace('\tизменено:   ', '')
        print(os.path.abspath(prepare_result))

```

### Вывод скрипта при запуске при тестировании:
```
/home/constantine/PycharmProjects/devops-netology/README.md
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

path = "~/PycharmProjects/devops-netology"

if len(sys.argv) >= 2:
    if os.path.exists(sys.argv[1] + "/.git"):
        path = sys.argv[1]

bash_command = ["cd " + path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result.find("изменено") != -1:
        prepare_result = result.replace('\tизменено:      ', '')
        print(os.path.abspath(prepare_result))

```

### Вывод скрипта при запуске при тестировании:
```
/home/constantine/PycharmProjects/devops-netology/README.md
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket

# localhost добавил для проверки ошибок
data = {"drive.google.com": '127.0.0.1', "mail.google.com": '127.0.0.1', "google.com": '127.0.0.1'}

while True:
    for service in data.keys():
        ip_address = socket.gethostbyname(service)
        print(f"Service: {service}. IP Address: {ip_address}")

        if data[service] != ip_address:
            print(f"[ERROR] {service} IP mismatch: {data[service]} {ip_address}.")
            data[service] = ip_address

```

### Вывод скрипта при запуске при тестировании:
```
Service: drive.google.com. IP Address: 64.233.165.194
[ERROR] drive.google.com IP mismatch: 127.0.0.1 64.233.165.194.
Service: mail.google.com. IP Address: 142.250.150.19
[ERROR] mail.google.com IP mismatch: 127.0.0.1 142.250.150.19.
Service: google.com. IP Address: 64.233.162.138
[ERROR] google.com IP mismatch: 127.0.0.1 64.233.162.138.
Service: drive.google.com. IP Address: 64.233.165.194
Service: mail.google.com. IP Address: 142.250.150.18
[ERROR] mail.google.com IP mismatch: 142.250.150.19 142.250.150.18.
Service: google.com. IP Address: 64.233.162.113
[ERROR] google.com IP mismatch: 64.233.162.138 64.233.162.113.
Service: drive.google.com. IP Address: 64.233.165.194
Service: mail.google.com. IP Address: 142.250.150.18
Service: google.com. IP Address: 64.233.162.113
Service: drive.google.com. IP Address: 64.233.165.194
Service: mail.google.com. IP Address: 142.250.150.18
Service: google.com. IP Address: 64.233.162.113
Service: drive.google.com. IP Address: 64.233.165.194
Service: mail.google.com. IP Address: 142.250.150.18
Service: google.com. IP Address: 64.233.162.113
Service: drive.google.com. IP Address: 64.233.165.194
Service: mail.google.com. IP Address: 142.250.150.18
Service: google.com. IP Address: 64.233.162.113
...
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```