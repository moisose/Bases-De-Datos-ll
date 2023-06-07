variable "group" {
    description = "Name of the group"
    type = string 
}

variable "location" {
    description = "Location of the resource group"
    type = map
    default =  {
      "name" = "East US"
      "code" = "eastus"
    }
}
