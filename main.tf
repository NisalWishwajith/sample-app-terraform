# mysql container eke part eka
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

provider "docker" {
  host = "tcp://localhost:2375"
}

resource "docker_image" "mysql" {
  name = "mysql:latest"
}

resource "docker_container" "mysql-flaskapp" {
  image = docker_image.mysql.image_id
  name = "mysql-flaskapp"
  volumes {
    volume_name = docker_volume.db_data.name
    container_path = "/var/lib/mysql"
  }
  env = [
    "MYSQL_ROOT_PASSWORD=rootpassword",
    "MYSQL_USER=user",
    "MYSQL_PASSWORD=password",
    "MYSQL_DATABASE=mylistdb"
  ]
  networks_advanced {
    name = "flaskapp_network"
    aliases = ["mysql"]
  }
}

resource "docker_volume" "db_data" {
  name = "db_data"
}







# flaskapp container eke part eka
resource "docker_image" "flaskapp-image" {
  name = "flaskapp"
  build {
    context = "./FlaskApp/"
    tag     = ["flaskapp:latest"]
    build_args = {
      foo : "flaskapp"
    }
    label = {
      author : "flaskapp"
    }
  }
}

resource "docker_container" "flaskapp-container" {
  image = docker_image.flaskapp-image.image_id
  name  = "flaskapp"
  ports {
    internal = 5000
    external = 5000
  }
  volumes {
    host_path = "D:/My Works/Projects/Terraform/FlaskApp"
    container_path = "/app"
  }
  networks_advanced {
    name = "flaskapp_network"
  }
}







#caddy container eke part eka
resource "docker_image" "caddy" {
  name = "caddy:latest"
}

resource "docker_container" "caddy" {
  image = docker_image.caddy.image_id
  name  = "caddy"
  ports {
    internal = 80
    external = 80
  }
  ports {
    internal = 443
    external = 443
  }
  volumes {
    host_path = "D:/My Works/Projects/Terraform/Caddyfile"
    container_path = "/etc/caddy/Caddyfile"
  }
}

# network eke part eka
resource "docker_network" "flaskapp_network" {
  name = "flaskapp_network"
}
