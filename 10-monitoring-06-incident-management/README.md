# Домашнее задание к занятию 17 «Инцидент-менеджмент»

## Основная часть

Составьте постмортем на основе реального сбоя системы GitHub в 2018 году.

Информация о сбое: 

* [в виде краткой выжимки на русском языке](https://habr.com/ru/post/427301/);
* [развёрнуто на английском языке](https://github.blog/2018-10-30-oct21-post-incident-analysis/).

---

## Ответ:

Постмортем: сбой БД GitHub <br>

- **Краткое описание** - сбой нескольких кластеров высокой доступности MySQL,затронуты БД метаданных. Содержащие, например, Issue и PR. Время простоя 24 часа и 11 минут с 22:52 21.10.2018 UTC до 23:03 22.10.2018 UTC. В результате простоя потерь данных не зафиксировано.<br>
- **Предшествующие события** - плановые технические работы по замене вышедшего из строя сетевого оборудования 100Gbps на 48 секунд привели к потери связанности между основным ЦОД на Восточном побережье США и его промежуточном сетевом узле на Восточном побережье.<br>
- **Причина инцидента** - потеря связанности до промежуточно сетевого узла ЦОД Восточного побережья привело к классической ситуации split brain. Кластера высокой доступности на Западном побережье США потеряли связь до основного ЦОД на Восточном побережье, образовали кворум и перевели себя в активное состояние. В это же время кластера Восточного побережья также были в активном состоянии. С 22:52 21.10.2018 UTC до 23:19 21.10.2018 UTC части кластеров работали независимо друг от друга, что привело к несогласованности данных и невозможности репликации данных после восстановления связи.<br>
- **Воздействие** - несогласованность кластеров MySQL содержащих метаданные. Такие как Issue, PR и прочие не относящиеся напрямую к git.<br>
- **Обнаружение** - С 22:54 21.10.2018 UTC системы мониторинга начали генерировать алерты о том что в системе наблюдаются многочисленные сбои.<br>
- **Реакция** - С 23:02 21.10.2018 UTC инженеры определили что топология кластеров высокой доступности находится в непредвиденном состоянии. 23:07 21.10.2018 UTC команда инженеров перевела уровень работы сайт на желтый уровень что превратило ситуацию в активный инцидент и отправило уведомление координатору инцидентов. В 23:11 21.10.2018 UTC координатор инцидентов принял решение изменить уровень работы сайта на красный.<br>
- **Восстановление** - С 00:41 22.10.2018 UTC начат процесс резервного копирования поврежденных частей кластеров. 06:51 22.10.2018 UTC завершен процесс восстановления части кластеров из резервной копии и начался процесс репликации кластеров между ЦОДами и восстановлений реплик для чтения. 16:24 22.10.2018 UTC закончились процессы реплицкации кластеров и реплик на чтение. С 06:45 22.10.2018 UTC до 23:03 22.10.2018 UTC шла отработка накопившихся процессов webhook-ов.<br>
- **Таймлайн:**
22:52 21.10.2018 UTC - проведение сетевых работ, сбой связи между ЦОДами Восточного и Западного побережья США
22:52 21.10.2018 UTC - обнаружение события сбоя
23:02 21.10.2018 UTC - обнаружение причины сбоя
23:07 21.10.2018 UTC - перевод статуса работы сайта на желтый уровень
23:11 21.10.2018 UTC - перевод статуса работы сайта на красный уровень
23:13 21.10.2018 UTC - вызваны дополнительные инженеры, идет детальный разбор ситуации
23:19 21.10.2018 UTC - принято решение прекратить выполнение задач которые активно пишут метаданные (push запросы)
00:05 22.10.2018 UTC - разработка плана восстановления сервиса. Определены пункты - восстановить данные из резервных копий, синхронизировать реплики на обоих сайтах, вернуться к стабильной топологии обслуживания, а затем возобновить обработку заданий в очереди.
00:41 22.10.2018 UTC - начат процесс резервного копирования затронутых кластеров, с последующим стартом процесса восстановления кластеров из резервной копии.
06:51 22.10.2018 UTC - окончание процесса восстановления некоторых кластеров, начало процесса репликаций кластера и реплик на чтение. Замедление загрузки страниц сайта. Данные реплик на чтение стали отставать от основных кластеров.
07:51 22.10.2018 UTC - опубликовано сообщение в блоге GitHub с детальным описанием сбоя
11:12 22.10.2018 UTC - репликация кластеров завершена, но реплики на чтение не успевают реплицироваться. Из-за этого могут отображаться несогласованные данные.
13:15 22.10.2018 UTC - разработан план по устранению задержи репликации реплик на чтение
16:24 22.10.2018 UTC - окончание процесса репликаций кластеров и реплик на чтение. Статус работы сайта сохранен на красном уровне чтобы закончить внутренние процессы накопившиеся за время сбоя.
16:24 22.10.2018 UTC - запущенны внутренние процессы. Основная проблема, что запускать процессы надо таким образом, чтобы сильно не перегрузить инфрастуктуру партнеров связанную с отправкой уведомлений.
16:24 22.10.2018 UTC - все внутренние процессы были закончены, статус работы сайта был изменен на зеленый<br>
- **Последующие действия:**
Устранение накопившихся несоответствий данных кластеров. Бинарные логи MySQL образовавшиеся после восстановленного бэкапа были воспроизведены на кластерах.
- **Технические мероприятия:**
Изменены настройки оркестратора (Orchestrator) кластеров высокой доступности
Ускорен переход на новый механизм отчетности о состоянии работы сайта
За несколько недель до этого инцидента запущена общекорпоративная инженерная инициатив по поддержке обслуживания трафика GitHub из нескольких ЦОД в дизайне активный/активный/активный. Этот проект преследует цель поддержки резервирования N+1.
- **Организационные мероприятия:**
Будет внедрена практика проверки сценариев сбоев до того, как они смогут повлиять на сайт
Будут дополнительные инвестиции в инструменты внедрения ошибок и хаос-инжиниринга.