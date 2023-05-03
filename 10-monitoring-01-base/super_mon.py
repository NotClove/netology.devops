#!/usr/bin/python3

import psutil
import json
from datetime import datetime as dt

result = dict()

now = dt.now()
result['timestamp'] = now.strftime("%s")

#Загрузка CPU
result['cpuload_p'] = psutil.cpu_percent(interval=1)
#Загрузка виртуальной памяти
result['vmload_p'] = psutil.virtual_memory().percent
#Загрузка свопа
result['swapload_p'] = psutil.swap_memory().percent

#Общее количество операций чтения со всех дисков
result['disk_io_r'] = psutil.disk_io_counters().read_count
#Общее количество операций записи со всех дисков
result['disk_io_w'] = psutil.disk_io_counters().write_count
#Общее количество прочитанных байт со всех дисков
result['disk_bytes_r'] = psutil.disk_io_counters().read_bytes
#Общее количество записанных байт со всех дисков
result['disk_bytes_w'] = psutil.disk_io_counters().write_bytes

#Общее количество отправленных байт со всех интерфейсов
result['net_bytes_s'] = psutil.net_io_counters().bytes_sent
#Общее количество полученных байт со всех интерфейсов
result['net_bytes_r'] = psutil.net_io_counters().bytes_recv

filepath = "/var/log/"+now.strftime("%y-%m-%d")+"-awesome-monitoring.log"

with open(filepath, "a") as log:
    log.write(json.dumps(result)+"\n")