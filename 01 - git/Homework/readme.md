## Задание 1

- любой путь до каталога .terraform

`**/.terraform/*`

- игнорирование логов

`crash.log`
`crash.*.log`

- в это блоке может быть любое начало или конец файла начиная от *

`*.tfstate`
`*.tfstate.*`
`*.tfvars`
`*.tfvars.json`
`*_override.tf`
`*_override.tf.json`

- конкретные имена файла для игнорирования

`override.tf`
`override.tf.json`
`terraform.rc`
`.terraformrc`


