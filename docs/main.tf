terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Crear red Docker para conectar Jenkins y DinD
resource "docker_network" "jenkins_network" {
  name = "jenkins"
}

# Crear volúmenes necesarios
resource "docker_volume" "jenkins_data" {
  name = "jenkins-data"
}

resource "docker_volume" "jenkins_certs" {
  name = "jenkins-docker-certs"
}

# Imagen Docker in Docker (DinD)
resource "docker_image" "dind_image" {
  name         = "docker:dind"
  keep_locally = false
}

# Contenedor Docker in Docker (DinD)
resource "docker_container" "dind" {
  name  = "jenkins-docker"
  image = docker_image.dind_image.name
  privileged = true
  networks_advanced {
    name = docker_network.jenkins_network.name
    aliases = ["docker"]
  }
  env = [
    "DOCKER_TLS_CERTDIR=/certs"
  ]
  volumes {
    volume_name    = docker_volume.jenkins_certs.name
    container_path = "/certs/client"
  }
  volumes {
    volume_name    = docker_volume.jenkins_data.name
    container_path = "/var/jenkins_home"
  }
  ports {
    internal = 2376
    external = 2376
  }
}

# Contenedor Jenkins
resource "docker_container" "jenkins" {
  name  = "jenkins-blueocean"
  image = "myjenkins-blueocean" # Usar la imagen personalizada creada
  restart = "on-failure"
  depends_on = [docker_container.dind] # Asegurar que DinD se despliegue primero
  networks_advanced {
    name = docker_network.jenkins_network.name
  }
  env = [
    "DOCKER_HOST=tcp://docker:2376",
    "DOCKER_CERT_PATH=/certs/client",
    "DOCKER_TLS_VERIFY=1"
  ]
  volumes {
    volume_name    = docker_volume.jenkins_data.name
    container_path = "/var/jenkins_home"
  }
  volumes {
    volume_name    = docker_volume.jenkins_certs.name
    container_path = "/certs/client"
    read_only      = true # Cambiado a 'read_only'
  }
  ports {
    internal = 8080
    external = 8080
  }
  ports {
    internal = 50000
    external = 50000
  }
}
