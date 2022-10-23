terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "s3-terr"
    region     = "ru-central1"
    key        = "terraform/terraform.tfstate"
    access_key = "*"
    secret_key = "*"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}