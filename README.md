
# devops-netology

## Домашнее задание к занятию "08.02 Работа с Playbook"

### Подготовка к выполнению

1) Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
Выполнено.
2) Скачайте playbook из репозитория с домашним заданием и перенесите его в свой репозиторий.
Выполнено.
3) Подготовьте хосты в соотвтествии с группами из предподготовленного playbook.
Выполнено.
4) Скачайте дистрибутив java и положите его в директорию playbook/files/.
Выполнено.

### Основная часть

1) Приготовьте свой собственный inventory файл prod.yml.
Выполнено. Добавил две группы хостов для kibana и elasticsearch.
```yaml
    ---
      elasticsearch:
        hosts:
          elastic_host:
            ansible_connection: docker
      kibana:
        hosts:
          kibana_host:
            ansible_connection: docker
```
2) Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.
Выполнено. Добавлен новый play.
3) При создании tasks рекомендую использовать модули: get_url, template, unarchive, file.
Выполнено.
4) Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.
Выполнено. Таски для нового play скачивают и разархивируют архив в созданную для него директорию после чего добавляют переменные среды KIBANA_HOME и обновляет PATH.
```yaml
- name: Install Kibana
  hosts: kibana
  tasks:
    - name: Upload tar.gz Kibana from remote URL
      get_url:
        url: "https://artifacts.elastic.co/downloads/kibana/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        mode: 0755
        timeout: 60
        force: true
        validate_certs: false
      register: get_kibana
      until: get_kibana is succeeded
      tags: kibana
    - name: Create directrory for Kibana
      file:
        state: directory
        path: "{{ kibana_home }}"
      tags: kibana
    - name: Extract Kibana in the installation directory
      become: true
      unarchive:
        copy: false
        src: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "{{ kibana_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ kibana_home }}/bin/kibana"
      tags:
        - kibana
    - name: Set environment for Kibana
      become: true
      template:
        src: templates/elk.sh.j2
        dest: /etc/profile.d/kibana.sh
      tags: kibana
```
5) Запустите ansible-lint site.yml и исправьте ошибки, если они есть.
Ошибок не обнаружено.
6) Попробуйте запустить playbook на этом окружении с флагом --check.
```commandline
vagrant@server1:~/netology_ansible/08-ansible-02-playbook$ ansible-playbook site.yml -i inventory/prod.yml --check

PLAY [Install Java] **************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************
[WARNING]: Platform linux on host elastic_host is using the discovered Python interpreter at /usr/bin/python3, but future installation of
another Python interpreter could change this. See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for
more information.
ok: [elastic_host]
[WARNING]: Platform linux on host kibana_host is using the discovered Python interpreter at /usr/bin/python3, but future installation of
another Python interpreter could change this. See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for
more information.
ok: [kibana_host]

TASK [Set facts for Java 11 vars] ************************************************************************************************************
ok: [elastic_host]
ok: [kibana_host]

TASK [Upload .tar.gz file containing binaries from local storage] ****************************************************************************
changed: [kibana_host]
changed: [elastic_host]

TASK [Ensure installation dir exists] ********************************************************************************************************
changed: [kibana_host]
changed: [elastic_host]

TASK [Extract java in the installation directory] ********************************************************************************************
fatal: [elastic_host]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.15' must be an existing dir"}
fatal: [kibana_host]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.15' must be an existing dir"}

PLAY RECAP ***********************************************************************************************************************************
elastic_host               : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
kibana_host                : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

```

7) Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.
```commandline
vagrant@server1:~/netology_ansible/08-ansible-02-playbook$ ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Java] ****************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [elastic_host]
ok: [kibana_host]

TASK [Set facts for Java 11 vars] ***************************************************************************************************************
ok: [elastic_host]
ok: [kibana_host]

TASK [Upload .tar.gz file containing binaries from local storage] ******************************************************************************
diff skipped: source file size is greater than 104448
changed: [kibana_host]
diff skipped: source file size is greater than 104448
changed: [elastic_host]

TASK [Ensure installation dir exists] **********************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.11",
-    "state": "absent"
+    "state": "directory"
 }

changed: [kibana_host]
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.11",
-    "state": "absent"
+    "state": "directory"
 }

changed: [elastic_host]

TASK [Extract java in the installation directory] **********************************************************************************************
changed: [elastic_host]
changed: [kibana_host]

TASK [Export environment variables] ************************************************************************************************************
--- before
+++ after: /home/vagrant/.ansible/tmp/ansible-local-19552p3j_hq5f_/tmp_dxhpo76/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.11
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [kibana_host]
--- before
+++ after: /home/vagrant/.ansible/tmp/ansible-local-19552p3j_hq5f_/tmpgb0gs20t/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.11
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [elastic_host]

PLAY [Install Elasticsearch] *******************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [elastic_host]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************
changed: [elastic_host]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/elastic/7.10.1",
-    "state": "absent"
+    "state": "directory"
 }

changed: [elastic_host]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************
changed: [elastic_host]

TASK [Set environment Elastic] *****************************************************************************************************************
--- before
+++ after: /home/vagrant/.ansible/tmp/ansible-local-19552p3j_hq5f_/tmpxfcyrgrw/elk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export ES_HOME=/opt/elastic/7.10.1
+export PATH=$PATH:$ES_HOME/bin
\ No newline at end of file

changed: [elastic_host]

PLAY [Install Kibana] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [kibana_host]

TASK [Upload tar.gz Kibana from remote URL] ****************************************************************************************************
changed: [kibana_host]

TASK [Create directory for Kibana] ***************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/kibana/8.2.3",
-    "state": "absent"
+    "state": "directory"
 }

changed: [kibana_host]

TASK [Extract Kibana in the installation directory] ********************************************************************************************
changed: [kibana_host]

TASK [Set environment Kibana] ******************************************************************************************************************
--- before
+++ after: /home/vagrant/.ansible/tmp/ansible-local-19552p3j_hq5f_/tmpq2uv5zf0/kibana.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export KIBANA_HOME=/opt/kibana/8.2.3
+export PATH=$PATH:$KIBANA_HOME/bin
\ No newline at end of file

changed: [kibana_host]

PLAY RECAP *************************************************************************************************************************************
elastic_host                 : ok=11   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
kibana_host                  : ok=11   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```
8. Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.

```commandline

vagrant@server1:~/netology_ansible/08-ansible-02-playbook$ ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Java] ****************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [elastic_host]
ok: [kibana_host]

TASK [Set facts for Java 11 vars] ***************************************************************************************************************
ok: [kibana_host]
ok: [elastic_host]

TASK [Upload .tar.gz file containing binaries from local storage] ******************************************************************************
ok: [elastic_host]
ok: [kibana_host]

TASK [Ensure installation dir exists] **********************************************************************************************************
ok: [elastic_host]
ok: [kibana_host]

TASK [Extract java in the installation directory] **********************************************************************************************
skipping: [elastic_host]
skipping: [kibana_host]

TASK [Export environment variables] ************************************************************************************************************
ok: [elastic_host]
ok: [kibana_host]

PLAY [Install Elasticsearch] *******************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [elastic_host]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************
ok: [elastic_host]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************
ok: [elastic_host]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************
skipping: [elastic_host]

TASK [Set environment Elastic] *****************************************************************************************************************
ok: [elastic_host]

PLAY [Install Kibana] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [kibana_host]

TASK [Upload tar.gz Kibana from remote URL] ****************************************************************************************************
ok: [kibana_host]

TASK [Create directory for Kibana] ***************************************************************************************
ok: [kibana_host]

TASK [Extract Kibana in the installation directory] ********************************************************************************************
skipping: [kibana_host]

TASK [Set environment for Kibana] ******************************************************************************************************************
ok: [kibana_host]

PLAY RECAP *************************************************************************************************************************************
elastic_host                 : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
kibana_host                  : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
```
9) Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
Выполнено.
10) Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.
https://github.com/Constantin174/netology-ansible/blob/main/08-ansible-02-playbook/README.md