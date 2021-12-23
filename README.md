### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

Выполнено. Корректный json

```json
    {
    	"info": "Sample JSON output from our service\t",
    	"elements": [{
    		"name": "first",
    		"type": "server",
    		"ip": 7175
    	}, {
    		"name": "second",
    		"type": "proxy",
    		"ip": "71.78.22.43"
    	}]
    }
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import io
import json
import socket

import yaml

json_file_name = 'data.json'
yaml_file_name = 'data.yaml'


def save_data_json(json_data):
    with io.open(json_file_name, 'w') as file:
        file.write(json.dumps(json_data))
    return None


def save_yaml_file(yaml_data):
    with io.open(yaml_file_name, 'w') as file:
        yaml.dump(yaml_data, file)
    return None


data = {"drive.google.com": '127.0.0.1', "mail.google.com": '127.0.0.1', "google.com": '127.0.0.1'}

save_data_json(data)
save_yaml_file(data)

while True:
    for service in data.keys():
        ip_address = socket.gethostbyname(service)
        print(f"Service: {service}. IP Address: {ip_address}")

        if data[service] != ip_address:
            print(f"[ERROR] {service} IP mismatch: {data[service]} {ip_address}.")
            data[service] = ip_address
            save_data_json(data)
            save_yaml_file(data)
```

### Вывод скрипта при запуске при тестировании:
```
Service: drive.google.com. IP Address: 173.194.73.194
[ERROR] drive.google.com IP mismatch: 127.0.0.1 173.194.73.194.
Service: mail.google.com. IP Address: 142.250.150.83
[ERROR] mail.google.com IP mismatch: 127.0.0.1 142.250.150.83.
Service: google.com. IP Address: 173.194.222.102
[ERROR] google.com IP mismatch: 127.0.0.1 173.194.222.102.
Service: drive.google.com. IP Address: 173.194.73.194
Service: mail.google.com. IP Address: 142.250.150.83
Service: google.com. IP Address: 173.194.222.102
Service: drive.google.com. IP Address: 173.194.73.194
Service: mail.google.com. IP Address: 142.250.150.83
Service: google.com. IP Address: 173.194.222.102
Service: drive.google.com. IP Address: 173.194.73.194
Service: mail.google.com. IP Address: 142.250.150.83
Service: google.com. IP Address: 173.194.222.102
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"drive.google.com": "173.194.73.194", "mail.google.com": "142.250.150.83", "google.com": "173.194.222.102"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
drive.google.com: 173.194.73.194
google.com: 173.194.222.102
mail.google.com: 142.250.150.83
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???