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

## Задание 2

![Commits links](https://github.com/NotClove/netology.devops/commits/master)

commit 33db08303c20cdecc6369a67511c2a2e9e87323e (HEAD -> master)
Author: Andrey Martyanov <shulsfm@gmail.com>
Date:   Sat May 7 11:52:49 2022 +0300

    Moved and deleted

commit c2953572427ce507080d05a99e0d42d8b8d14e10
Author: Andrey Martyanov <shulsfm@gmail.com>
Date:   Sat May 7 11:51:28 2022 +0300

    Prepare to delete and move

commit 0362d1df6f64c132350df2e706e195f35d3e2601
Author: Andrey Martyanov <shulsfm@gmail.com>
Date:   Sat May 7 11:46:20 2022 +0300

    Added gitignore



