# Домашнее задание к занятию «Микросервисы: принципы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

Обоснуйте свой выбор.


# Ответ:

API Gateway. Запрошенные требования являются базовым функционалом, поэтому все выбранные решения их поддерживают. Для небольших проектов можно остановиться на Nginx. API Gateway очень много развелось. Свои решения предлагают как сервис все крупные облака (даже от Сбертеха). Есть множество OpenSource решений с ограниченным функционалом, и платными подписками с дополнительными плюшками. Из интересных.

|Наименование|Маршрутизация запросов на основе конфигурации|Аутентификация|HTTPS|Комментарий|
| --- |:---:|:---:|:---:|:--- |
|Nginx|X|X|X|On Premise, подойдет для небольших инсталляций, функционал балансировки без подписки на Nginx Plus слабый, управление конфигами через ручные правки, C++|
|Kong|X|X|X|On Premise, Open source, на базе Nginx, Kubernetes Ingress Controller, конфигурация статическая или через API,WEB интерфейс управления, Lua|
|Tyk.io|X|X|X|On Premise и SaaS, Open source, есть бесплатная версия, Kubernetes Ingress Controller, WEB интерфейс управления, GoLang|
|Amazon AWS API Gateway|X|X|X|SaaS,WEB интерфейс управления, платный, один из первых сервисов, популярный, для тех кто вплотную сидит на AWS|
|WSO2 API Manage|X|X|X|On Premise и SaaS, Open source, поддержка API REST, JSON, SOAP, XML, WEB интерфейс управления, для относительно больших компаний, Java|

## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

Обоснуйте свой выбор.

## Ответ:

Брокер сообщений. Хочу сразу отметить что такие метрики как "Высокая скорость работы" и "Простота эксплуатации" вещь субъективная или зависит от характера нагрузки. Для простых проектов мне пока больше нравится RabbitMQ, он  простой в настройке и у него наиболее интересный механизм маршрутизации сообщений. 

|Название|Кластеризация|Хранение на диске|Высокая скорость|Различные форматы|Распределение прав|Простота|Комментарий|
| --- |:---:|:---:|:---:|:---:|:---:|:---:| --- |
|Kafka|X|X|X|X|X|X|On Premise, Open source|
|RabbitMQ|X|X|X|X|X|X|On Premise, Open source|
|Redis|X|-|X|X|-|X|On Premise, Open source, можно хранить бэкапы в виде дампов|

