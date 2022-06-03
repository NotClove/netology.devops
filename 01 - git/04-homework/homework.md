# Домашнее задание к занятию «2.4. Инструменты Git»

Для выполнения заданий в этом разделе давайте склонируем репозиторий с исходным кодом 
терраформа https://github.com/hashicorp/terraform 

В виде результата напишите текстом ответы на вопросы и каким образом эти ответы были получены. 

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.


    commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
    Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
    Date:   Thu Jun 18 10:29:58 2020 -0400

        Update CHANGELOG.md

3. Какому тегу соответствует коммит `85024d3`?


    commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
    Author: tf-release-bot <terraform@hashicorp.com>
    Date:   Thu Mar 5 20:56:10 2020 +0000

        v0.12.23

4. Сколько родителей у коммита `b8d720`? Напишите их хеши.


    commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
    Родителей 2(Merge): 56cd7859e 9ea88f22f

5. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.


    33ff1c03b (tag: v0.12.24) v0.12.24
    b14b74c49 [Website] vmc provider links
    3f235065b Update CHANGELOG.md
    6ae64e247 registry: Fix panic when server is unreachable
    5c619ca1b website: Remove links to the getting started guide's old location
    06275647e Update CHANGELOG.md
    d5f9411f5 command: Fix bug when using terraform login on Windows
    4b6d06cc5 Update CHANGELOG.md
    dd01a3507 Update CHANGELOG.md
    225466bc3 Cleanup after v0.12.23 release
    85024d310 (tag: v0.12.23) v0.12.23

6. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
так `func providerSource(...)` (вместо троеточего перечислены аргументы).


    commit 8c928e83589d90a031f811fae52a81be7153e82f
    Author: Martin Atkins <mart@degeneration.co.uk>
    Date:   Thu Apr 2 18:04:39 2020 -0700

7. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.


    78b122055 Remove config.go and update things using its aliases
    52dbf9483 keep .terraform.d/plugins for discovery
    41ab0aef7 Add missing OS_ARCH dir to global plugin paths
    66ebff90c move some more plugin search path logic to command
    8364383c3 Push plugin discovery down into command package


8. Кто автор функции `synchronizedWriters`? 


    commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
    Author: Martin Atkins <mart@degeneration.co.uk>
    Date:   Wed May 3 16:25:41 2017 -0700

        main: synchronize writes to VT100-faker on Windows