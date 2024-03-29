# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."


## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

```bash
Переменные можно автоматически забирать из утилиты YC
Пример такой реализации:

export YC_TOKEN=`yc config list | grep token | awk '{print $2}'`
export YC_CLOUD_ID=`yc config list | grep cloud-id | awk '{print $2}'`
export YC_FOLDER_ID=`yc config list | grep folder-id | awk '{print $2}'`
export YC_ZONE=`yc config list | grep zone | awk '{print $2}'`
```

## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ. 

1. terraform init:

   ```
   terraform git:(master) ✗ terraform init

   Initializing the backend...

   Initializing provider plugins...
   - Finding latest version of yandex-cloud/yandex...
   - Installing yandex-cloud/yandex v0.81.0...
   - Installed yandex-cloud/yandex v0.81.0 (self-signed, key ID E40F590B50BB8E40)

   Partner and community providers are signed by their developers.
   If you'd like to know more about provider signing, you can read about it here:
   https://www.terraform.io/docs/cli/plugins/signing.html

   Terraform has created a lock file .terraform.lock.hcl to record the provider
   selections it made above. Include this file in your version control repository
   so that Terraform can guarantee to make the same selections by default when
   you run "terraform init" in the future.

   Terraform has been successfully initialized!

   You may now begin working with Terraform. Try running "terraform plan" to see
   any changes that are required for your infrastructure. All Terraform commands
   should now work.

   If you ever set or change modules or backend configuration for Terraform,
   rerun this command to reinitialize your working directory. If you forget, other
   commands will detect it and remind you to do so if necessary.
   ```

2. terraform plan

   ```
   terraform git:(master) ✗ terraform plan

   Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
   + create

   Terraform will perform the following actions:

   # yandex_compute_instance.vm will be created
   + resource "yandex_compute_instance" "vm" {
         + created_at                = (known after apply)
         + folder_id                 = (known after apply)
         + fqdn                      = (known after apply)
         + hostname                  = (known after apply)
         + id                        = (known after apply)
         + metadata                  = {
            + "ssh-keys" = <<-EOT
                  ubuntu:***
               EOT
         }
         + name                      = "terraformsyntax"
         + network_acceleration_type = "standard"
         + platform_id               = "standard-v1"
         + service_account_id        = (known after apply)
         + status                    = (known after apply)
         + zone                      = (known after apply)

         + boot_disk {
            + auto_delete = true
            + device_name = (known after apply)
            + disk_id     = (known after apply)
            + mode        = (known after apply)

            + initialize_params {
               + block_size  = (known after apply)
               + description = (known after apply)
               + image_id    = "fd89ovh4ticpo40dkbvd"
               + name        = (known after apply)
               + size        = (known after apply)
               + snapshot_id = (known after apply)
               + type        = "network-hdd"
               }
         }

         + network_interface {
            + index              = (known after apply)
            + ip_address         = (known after apply)
            + ipv4               = true
            + ipv6               = (known after apply)
            + ipv6_address       = (known after apply)
            + mac_address        = (known after apply)
            + nat                = true
            + nat_ip_address     = (known after apply)
            + nat_ip_version     = (known after apply)
            + security_group_ids = (known after apply)
            + subnet_id          = (known after apply)
         }

         + placement_policy {
            + host_affinity_rules = (known after apply)
            + placement_group_id  = (known after apply)
         }

         + resources {
            + core_fraction = 100
            + cores         = 2
            + memory        = 2
         }

         + scheduling_policy {
            + preemptible = (known after apply)
         }
      }

   # yandex_vpc_network.net will be created
   + resource "yandex_vpc_network" "net" {
         + created_at                = (known after apply)
         + default_security_group_id = (known after apply)
         + folder_id                 = (known after apply)
         + id                        = (known after apply)
         + labels                    = (known after apply)
         + name                      = "net"
         + subnet_ids                = (known after apply)
      }

   # yandex_vpc_subnet.subnet-1 will be created
   + resource "yandex_vpc_subnet" "subnet-1" {
         + created_at     = (known after apply)
         + folder_id      = (known after apply)
         + id             = (known after apply)
         + labels         = (known after apply)
         + name           = "subnet1"
         + network_id     = (known after apply)
         + v4_cidr_blocks = [
            + "192.168.100.0/24",
         ]
         + v6_cidr_blocks = (known after apply)
         + zone           = "ru-central1-b"
      }

   Plan: 3 to add, 0 to change, 0 to destroy.

   Changes to Outputs:
   + external_ip = (known after apply)
   + private_ip  = (known after apply)

   ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

   Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
   ```

3. Запускаем скрипт, который создает переменные окружения и применяет terraform apply:

   ```bash
   source ./start.sh
   ```

4. Получаем результат:

   ```
   Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

   Outputs:

   external_ip = "51.250.107.184"
   private_ip = "192.168.100.14"
   ```


В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
   - Packer
1. Ссылку на репозиторий с исходной конфигурацией терраформа. 
   - [Ссылка на репозиторий](https://github.com/NotClove/netology.devops/tree/master/07-terraform-02-syntax/terraform)
