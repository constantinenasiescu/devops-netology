# devops-netology

## Домашнее задание к занятию "7.1. Инфраструктура как код"

1) В данной ситуации я бы так ответил на данные вопросы.

* Я бы использовал неизменяемый тип инфраструктуры. К преимуществам можно отнести ее согласованность и надежность, а также простота и предсказуемость процесса развертывания.
К тому же, если представить, что в данном проекте инфрастуктура будет развернута в облаке, то можно быстро создавать сконфигурированные виртуальные машины, используя средства для управления конфигурацией или инициализации ресурсов.
* Я бы не стал использовать центральный сервер для управления инфраструктурой.
* Я бы не стал использовать агенты на серверах.
* Да, я бы использовал средства для управления конфигурацией или инициализации ресурсов, т.к. с помощью них можно автоматизировать образы виртуальных машин и их дальнейшее конфигурирование.

`Какие инструменты из уже используемых вы хотели бы использовать для нового проекта?`
Из используемых я бы использовал Packer для создания образов, Terraform для конфигурирования инфраструктуры, Docker для контейнеризации и Kubernetes для оркестрации контейнеров. Для автоматизации процессов использовал Teamcity, а для автоматизации настройки и развертывания программного обеспечения использовал Ansible.
`Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта?`
Возможно, для автоматизации процессов вместо Teamcity я бы использовал Jenkins или Gitlab CI, т.к. последние - open source проекты с большим и сообществом. В Jenkins имеется поддержка огромного количества плагинов, обеспечивающие большую гибкость при создании пайплайнов, а Gitlab CI имеет глубокую интеграцию в систему управления версиями.

2) Выполнено

```bash
constantine@constantine:~$ terraform --version
Terraform v1.1.5
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.1.7. You can update by downloading from https://www.terraform.io/downloads.html
```

3) Выполнено. Есть как минимум 2 варианта для решения данной проблемы, первый - это создание 2 отдельных папок с бинарниками разных версий terraform, после чего нужно создать симлинки в 
/usr/bin

```bash
constantine@constantine:~$ sudo mkdir -p /usr/local/tf
constantine@constantine:~/terraform$ sudo mkdir -p /usr/local/tf/11
constantine@constantine:~/terraform$ sudo mkdir -p /usr/local/tf/7

constantine@constantine:~/terraform$ cd ~/terraform/'terraform 1.1.7'
constantine@constantine:~/terraform/terraform 1.1.7$ sudo cp terraform /usr/local/tf/7
constantine@constantine:~/terraform/terraform 1.1.7$ cd ../'terraform 1.1.11'
constantine@constantine:~/terraform/terraform 1.1.11$ sudo cp terraform /usr/local/tf/11

constantine@constantine:~$ sudo ln -s /usr/local/tf/11/terraform /usr/bin/terraform11
constantine@constantine:~$ sudo ln -s /usr/local/tf/7/terraform /usr/bin/terraform7

constantine@constantine:~/terraform/terraform 1.1.11$ sudo chmod ugo+x /usr/bin/terraform*

constantine@constantine:~/terraform/terraform 1.1.11$ terraform7 --version
Terraform v1.1.7
on linux_amd64
constantine@constantine:~/terraform/terraform 1.1.11$ terraform11 --version
Terraform v1.0.11
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.1.7. You can update by downloading from https://www.terraform.io/downloads.html

```

второй - использование утилиты tfswitch, позволяющей быстро менять версии терраформа.