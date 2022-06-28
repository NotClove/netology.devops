# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?

    ![01](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-06-net/pics/01.png?raw=true)

  ```
  Код перенаправления "301 Moved Permanently" протокола передачи гипертекста (HTTP) показывает, что запрошенный ресурс 
  был окончательно перемещён в URL, указанный в заголовке Location (en-US). Браузер в случае такого ответа 
  перенаправляется на эту страницу, а поисковые системы обновляют свои ссылки на ресурс (говоря языком SEO, вес 
  страницы переносится на новый URL-адрес).
  ```

2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`

  ![02](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-06-net/pics/02.png?raw=true)

- укажите в ответе полученный HTTP код.

  ```
  HTTP код перенаправления  307 Temporary Redirect означает, что запрошенный ресурс был временно перемещён в URL-адрес, 
  указанный в заголовке Location (en-US).

  Метод и тело исходного запроса повторно используются для выполнения перенаправленного запроса. Если вы хотите, чтобы 
  используемый метод был изменён на GET, используйте 303 See Other. Это полезно, если вы хотите дать ответ на метод PUT, 
  который не является загруженным ресурсом, а является подтверждающим сообщением (например, «Вы успешно загрузили XYZ»).

  Единственное различие между 307 и 302 состоит в том, что 307 гарантирует, что метод и тело не будут изменены при 
  выполнении перенаправленного запроса. В случае с кодом 302 некоторые старые клиенты неправильно меняли метод на GET, 
  из-за чего поведение запросов с методом отличным от GET и ответа с кодом 302 непредсказуемо, тогда как поведение в 
  случае ответа с кодом 307 предсказуемо. Для запросов GET поведение идентично.
  ```

- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?

  ![03](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-06-net/pics/03.png?raw=true)

3. Какой IP адрес у вас в интернете?

  ![04](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-06-net/pics/04.png?raw=true)

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`

  ![05](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-06-net/pics/05.png?raw=true)

  ```
  AS25405
  ```

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`

  ![06](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-06-net/pics/06.png?raw=true)

6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?

  ![07](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-06-net/pics/07.png?raw=true)

  ```
  На последнем участке 22.8 avg ping
  ```


7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`

  ![08](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-06-net/pics/08.png?raw=true)

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`

  ![09](https://github.com/NotClove/netology.devops/blob/master/03-sysadmin-06-net/pics/09.png?raw=true)
