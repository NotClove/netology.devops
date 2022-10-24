# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "y0_AgAAAAADuIv9AATuwQAAAADM93UJe3QnJOGXQXOvC_1fPAlCfojwcMY"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gc1ufn6og4q7hkvht8"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "centos-7-base" {
  default = "fd841pnhqaa5csb9dssi"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "ubuntu-base" {
  default = "fd8gn7hnrq3urla6fcq5"
}