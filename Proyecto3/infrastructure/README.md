# Infraestructura en Azure Cloud

## Requerimientos:

* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)
* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* Tener una cuenta de [Azure Student](https://azure.microsoft.com/en-us/free/students/), la misma se activa con su email del TEC.

## Creación de la infraestructura

* Abrir una terminal PowerShell/Linux
* Iniciar sesión en Azure Cloud, para lograr esto se debe ejecutar el siguiente comando:

```bash
az login --use-device-code
```
* Ingresar a la carpeta **infrastructure** y editar el archivo **conf\group.tfvars**, establecer un nombre sin caracteres especiales, espacios o mayusculas:

```hcl
group = "{NOMBRE}"
```

* Editar el archivo **container_app.tf** y configurar el nombre de una imagen creada por cada grupo (ver carpeta docker) así como definir variables de entorno requeridas.

```hcl
      name   = "api-demo"
      image  = "docker.io/nereo08/api-demo:latest"
      env {
        name  = "ENV1"
        value = "VAL1"
      }
      env {
        name  = "ENV2"
        value = "VAL2"
      }
```

* Crear la infraestructura

```bash
terraform init
terraform apply --var-file=conf/group.tfvars
```
Cuando esta ha sido creada se tendra una salida similar a:

```bash
Outputs:

azureSQL = "nereo-sqlserver.database.windows.net"
cassandra_connectionstring = <sensitive>
cassandra_endpoint = "https://tfex-cosmos-db-67715.documents.azure.com:443/"
container_fqdn = tolist([
  "main-app.redisland-c3baa40a.eastus.azurecontainerapps.io",
])
container_outbound_ip_addresses = tolist([
  "20.84.21.89",
])
instance_ip_addr = "104.41.153.220"

```

Esta es información importante para conectarse a su infraestructura desde sus computadoras. Para ver el valor de cassandra_connectionstring, ejecuten:

```bash
terraform output cassandra_connectionstring
```

* Si ocupan cambiar algo en los archivos de infraestructura ejecutan:

```bash
terraform init
terraform apply --var-file=conf/group.tfvars
```

* Si ocupan borrar solo ejecutan:
```bash
terraform init
terraform destroy --var-file=conf/group.tfvars
```

**IMPORTANTE**: Guarden en sus repositorios todos los archivos generados menos las carpetas .terraform y .terraform.lock.hcl