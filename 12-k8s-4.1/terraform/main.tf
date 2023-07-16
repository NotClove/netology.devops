resource "yandex_vpc_network" "vpc-network" {
  folder_id   = var.folder_id
  name        = "network"
  description = "netology network"
}

resource "yandex_vpc_route_table" "nat-route-table" {
  network_id = yandex_vpc_network.vpc-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.instance-nat-ip
  }
}

# Subnets of the network.
resource "yandex_vpc_subnet" "vpc-public" {
  folder_id      = var.folder_id
  name           = "public-subnet"
  description    = "public-subnet"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.yandex_cloud_zone
  network_id     = yandex_vpc_network.vpc-network.id
}

resource "yandex_vpc_subnet" "vpc-private" {
  folder_id      = var.folder_id
  name           = "private-subnet"
  description    = "private-subnet"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = var.yandex_cloud_zone
  network_id     = yandex_vpc_network.vpc-network.id
  route_table_id = yandex_vpc_route_table.nat-route-table.id
}

resource "yandex_compute_instance" "instance_nat-vm" {
  count       = var.instance_count
  folder_id   = var.folder_id
  platform_id = var.instance_type
  name        = "${var.instance_name}-nat"
  hostname    = "${var.instance_name}-nat.${var.domain}"
  resources {
    cores         = var.cores
    core_fraction = var.core_fraction
    memory        = var.memory
  }
  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      type     = var.boot_disk
      size     = var.disk_size
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.vpc-public.id
    ip_address = var.instance-nat-ip
    nat       = true
  }

    metadata = {
    ssh-keys = "${var.users}:${file(var.path_to_public_key)}"
  }

  allow_stopping_for_update = true
}

resource "yandex_compute_instance" "public-vm" {
  count       = var.instance_count
  folder_id   = var.folder_id
  platform_id = var.instance_type
  name        = "${var.instance_name}-public"
  hostname    = "${var.instance_name}-public.${var.domain}"
  resources {
    cores         = var.cores
    core_fraction = var.core_fraction
    memory        = var.memory
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
      type     = var.boot_disk
      size     = var.disk_size
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.vpc-public.id
    nat       = true
  }
  
    metadata = {
    ssh-keys = "${var.users}:${file(var.path_to_public_key)}"
  }

  allow_stopping_for_update = true
}

resource "yandex_compute_instance" "private-vm" {
  count       = var.instance_count
  folder_id   = var.folder_id
  platform_id = var.instance_type
  name        = "${var.instance_name}-private"
  hostname    = "${var.instance_name}-private.${var.domain}"
  resources {
    cores         = var.cores
    core_fraction = var.core_fraction
    memory        = var.memory
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
      type     = var.boot_disk
      size     = var.disk_size
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.vpc-private.id
  }
  
    metadata = {
    ssh-keys = "${var.users}:${file(var.path_to_public_key)}"
  }

  allow_stopping_for_update = true
}