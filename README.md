# devops-netology

## Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

1) Инфраструктура как код (IaaC) - это паттерн, согласно которому, создание и конфигурирование инфраструктуры происходит при помощи написания программного кода. 
Соответственно, одними из основных преимуществ данного подхода являются:
* Гибкость создания и сопровождения инфраструктуры.
* Уменьшение затрат (как финансовых, так и временных). В первую очередь сокращение рутинных операций за счет автоматизации процессов.
* Сокращение человеческого фактора. Так как большинство процессов автоматизируется, то соответственно, с увеличением автоматизации сокращается риск возникновения ошибок которые можно 
допустить при выполнении операций вручную.
* Увеличение скорости разработки и тестирования за счет автоматизации процессов.
* Стабильность системы.

Основополагающим преимуществом на мой взгляд является идемпотентность, то есть способность операции предоставлять результат идентичный предыдущим и всем последующим.

2) К основным преимуществам Ansible помимо простоты, скорости и расширяемости (т.е. возможности подключения дополнительных ролей и модулей) можно отнести то, что он не требует установки
какого-либо дополнительного окружения (например, PKI), а работает c уже существующей ssh инфраструктурой.\
"Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?"
На мой взгляд, более надежен метод PUSH. С одной стороны, в режиме PUSH при недоступности сервера будет отсутствовать возможность,
чтобы применить конфигурацию, с другой в режиме PULL, если сервер недоступен, то агент тоже не сможет запулить конфигурацию, плюс далеко не факт, 
что применение конфигурации агентом будет проведено успешно из-за конфликтов с GPO (групповых политик) сервера. 

3) Выполнено. Установка virtualbox 

```bash
sudo apt-get install virtualbox
```
установка vagrant

```bash
constantine@constantine:~$ curl -O https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 40.9M  100 40.9M    0     0  4206k      0  0:00:09  0:00:09 --:--:-- 4499k
constantine@constantine:~$ 
constantine@constantine:~$ sudo apt install ./vagrant_2.2.9_x86_64.deb
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Note, selecting 'vagrant' instead of './vagrant_2.2.9_x86_64.deb'
The following NEW packages will be installed:
  vagrant
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 0 B/43.0 MB of archives.
After this operation, 126 MB of additional disk space will be used.
Get:1 /home/vagrant/vagrant_2.2.9_x86_64.deb vagrant amd64 1:2.2.9 [43.0 MB]
Selecting previously unselected package vagrant.
(Reading database ... 41552 files and directories currently installed.)
Preparing to unpack .../vagrant_2.2.9_x86_64.deb ...
Unpacking vagrant (1:2.2.9) ...
Setting up vagrant (1:2.2.9) ...
constantine@constantine:~$ vagrant --version
Vagrant 2.2.9
```
Установка ansible

```bash
constantine@constantine:~$ sudo apt update
constantine@constantine:~$ sudo apt install software-properties-common
constantine@constantine:~$ sudo add-apt-repository --yes --update ppa:ansible/ansible
constantine@constantine:~$ sudo apt install ansible
```

4) Выполнено

```bash
constantine@constantine:~/services/vagrant_project$ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
==> server1.netology: Matching MAC address for NAT networking...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
==> server1.netology: Setting the name of the VM: server1.netology
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: 
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology: 
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it`s present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/constantine/services/vagrant_project
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
changed: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=git)
ok: [server1.netology] => (item=curl)

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
 
constantine@constantine-3570R-370R-470R-450R-510R-4450RV:~/services/vagrant_project$ vagrant ssh
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon 24 Jan 2022 07:36:53 PM UTC

  System load:  0.0               Users logged in:          0
  Usage of /:   3.2% of 61.31GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 20%               IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                IPv4 address for eth1:    192.168.192.11
  Processes:    103


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Mon Jan 24 19:30:35 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

