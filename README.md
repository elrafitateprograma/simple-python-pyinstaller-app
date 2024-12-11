# simple-python-pyinstaller-app
Prerequisitos:
- Tener instalado docker
- Tener githubdesktop o git instalado
- Hacer un fork de app-instalation-python
- Instalar terraform en tu sistema
Paso 1:
- Configurar el archivo main.tf o despliegue.tf (el nombre es opcional) de tal manera que se cree un DinD y, dentro del mismo, un docker de jenkins. Si tienes problemas de conexión segura en tu navegador, te recomiendo instalar una imagen que valide el TLS. 

Paso 2:
- Tener tu jenkinsfile y tu dockerfile descargados o creados y configurados.

Paso 3: 
- Si todo va bien, clonar en nuestro dispositivo el fork que hemos fokeado anteriormente y añadir la estructura requerida por la práctica. 
- Añadir tu main.tf

Paso 4: 
- Abrir una terminal en la carpeta y escribir "terraform init"
- Después, para validar que todo anda bien "terraform plan"
- Si no hay archivos corruptos, "terraform apply" -> "yes"

Paso 5:
- Si configuraste tu main.tf para que jenkins se abra en localhost:8080, abrir esta dirección en el navegador
- Introducir la clave de administrador (se puede consultar si ponemos el comando docker exec -it jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword siempre y cuando tu contenedor se llame jenkins-blueocean)
- Seleccionar instalación recomendada
- Crear un usuario
- Pulsar en nueva tarea-> dale un nombre y selecciona pipeline
- Olvida todas las opciones menos la última. En vez de Pipeline script, pon Pipeline script from SCM
- Selecciona de SCM, git
- Añade el repositorio que ya tendrías que haber subido en github (solo la raiz del mismo)
- Si tu ruta de jenkinsfile es diferente, actualizala

Paso 6:
- Si todo ha ido bien, puedes probar a, simplemente pulsar en construir ahora. Si nada ha fallado, deberás de ver SUCCESS y después podrás descargar el ejecutable