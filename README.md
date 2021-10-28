# devops-netology

## Задание №1 – Создать и настроить репозиторий для дальнейшей работы на курсе.

### Файл terraform/\.gitignore.

Все игнорирования файлов и папок происходят на том же уровне или ниже относительно terraform/\.gitignore.

1) \*\*/\.terraform/\* - будет игнорироваться содержимое папки (папок) с названием \.terraform, например, \.terraform/abc.json, build/\.terraform/def.exe.
2) \*\.tfstate и \*\.tfstate.\* - игнорирование файлов с расширением \.tfstate и содержащие в своем названии \.tfstate\., например, abc.tfstate, terraform/build/abc.tfstate.exe.
3) crash.log - игнорирование файла crash.log, который может находится в любой директории, например, terraform/lib/build/crash.log.
4) \*.tfvars - исключение всех файлов с расширением .tfvars (пример: abc.tfvars).
5) override.tf и override.tf.json - игнорирование файлов override.tf и override.tf.json.
6) \*_override.tf и \*_override.tf.json - исключить все файлы, которые содержат \*_override.tf и \*_override.tf.json (build/abc_override.tf и def_override.tf.json)
7) .terraformrc и terraform.rc - игнорирование файлов .terraformrc и terraform.rc.