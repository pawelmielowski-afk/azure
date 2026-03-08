terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
  subscription_id = "8b3fa8f8-a2d3-432c-ae70-d7f10d656b36"
  tenant_id       = "1eec61d5-8bc8-4faf-b323-9734fe75bcc9"
  resource_provider_registrations = "none"
}

data "azurerm_resource_group" "rg" {
  name = "rg-test-funcion"
#  location = "swedencentral"

}

resource "azurerm_virtual_network" "vnet" {
  name                =  "testvpc"
  resource_group_name = data.azurerm_resource_group.rg.name
  location = "swedencentral"
  address_space = ["10.0.0.0/16"]

#   tags = {
#     environment = "dev"
#   }
}

# 5️⃣ Virtual Network Gateway
# resource "azurerm_virtual_network_gateway" "vnet_gw" {
#   name                = "kk-vpn-gateway"
#   location            = data.azurerm_resource_group.rg .location
#   resource_group_name = data.azurerm_resource_group.rg.name

#   type     = "Vpn"
#   vpn_type = "RouteBased"
#   active_active = false
#   enable_bgp    = false
#   sku           = "VpnGw1"
#   generation = "Generation1"

#   ip_configuration {
#     name                          = "vnetGatewayConfig"
#     public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.gateway.id 
#   }

#   vpn_client_configuration {
#     address_space = ["10.2.0.0/24"]  # prywatne IP, które otrzyma klient VPN
#     vpn_auth_types = ["AAD"]
#     vpn_client_protocols  = ["OpenVPN"]
#     aad_tenant = "https://login.microsoftonline.com/30fe8ff1-adc6-444d-ba94-1238894df42c/"
#     aad_audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
#     aad_issuer   = "https://sts.windows.net/30fe8ff1-adc6-444d-ba94-1238894df42c/"
#     # 🔐 Certyfikat root CA (self-signed dla testów)

#   }
# }

# Odczyt istniejącej podsieci subnet1
# resource "azurerm_subnet" "subnet" {
#   name                 = "subnet1"
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   resource_group_name  = data.azurerm_resource_group.rg.name
# }

# resource "azurerm_virtual_network" "testvpc" {
#   name                = "testvpc"
#   address_space       = ["10.0.0.0/16"]
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name

#   tags = {
#     Name = "testvpc"
#   }
# }

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
 

}


resource "azurerm_public_ip" "vm_public_ip2" {
  name                = "vm-public-ip2"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"

}



resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  
#   delegation {
#     name = "aciDelegation"
#     service_delegation {
#       name    = "Microsoft.ContainerInstance/containerGroups"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
#     }
#   }
}

# resource "azurerm_subnet" "subnet2" {
#   name                 = "subnet2"
#   resource_group_name  = data.azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.0.0/24"]
#   # delegation {
#   #   name = "aks_delegation"
#   #   service_delegation {
#   #     name = "Microsoft.ContainerService/managedClusters"
#   #     actions = [
#   #       "Microsoft.Network/virtualNetworks/subnets/join/action",
#   #       "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
#   #       "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
#   #     ]
#   #   }
#   }

# delegation {
#     name = "appservice_delegation"
#     service_delegation {
#       name = "Microsoft.Web/serverFarms"
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/action",
#       ]
#     }
#   }
#}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}




# resource "azurerm_network_security_group" "nsg" {
#   name                = "example-nsg"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name

    
#   security_rule {
#     name                       = "Allow-SSH"
#     priority                   = 150
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range           = "*"
#     destination_port_range      = "22"
#     destination_address_prefix  = "*"
#     source_address_prefix      = "*"
#     description                 = "Allow SSH from admin workstation"
#   }

#   security_rule {
#     name                       = "test123"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#    security_rule {
#     name                       = "test124"
#     priority                   = 100
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#    # Pozwól ruch wewnętrzny w VNet
#   security_rule {
#     name                       = "Allow-VNet-Inbound"
#     priority                   = 110
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "VirtualNetwork"
#     destination_address_prefix = "VirtualNetwork"
#   }

#   security_rule {
#     name                       = "Allow-VNet-Outbound"
#     priority                   = 120
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "VirtualNetwork"
#     destination_address_prefix = "VirtualNetwork"
#   }

#   # Pozwól DNS do Azure internal resolver
#   security_rule {
#     name                       = "Allow-DNS-Resolver"
#     priority                   = 200
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Udp"
#     source_port_range          = "*"
#     destination_port_range     = "53"
#     source_address_prefix      = "*"
#     destination_address_prefix = "168.63.129.16"
#   }

# security_rule {
#     name                       = "Allow-ICMP-Outbound2"
#     priority                   = 310
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Icmp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#  security_rule {
#     name                       = "Allow-All-Outbound3"
#     priority                   = 320
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

# }


# resource "azurerm_network_security_group" "nsg2" {
#   name                = "example-nsg2"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name

#   security_rule {
#     name                       = "test123"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }


#    security_rule {
#     name                       = "test124"
#     priority                   = 100
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#    # Pozwól ruch wewnętrzny w VNet
#   security_rule {
#     name                       = "Allow-VNet-Inbound"
#     priority                   = 110
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "VirtualNetwork"
#     destination_address_prefix = "VirtualNetwork"
#   }

#   security_rule {
#     name                       = "Allow-VNet-Outbound"
#     priority                   = 120
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "VirtualNetwork"
#     destination_address_prefix = "VirtualNetwork"
#   }

#   # Pozwól DNS do Azure internal resolver
#   security_rule {
#     name                       = "Allow-DNS-Resolver"
#     priority                   = 200
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Udp"
#     source_port_range          = "*"
#     destination_port_range     = "53"
#     source_address_prefix      = "*"
#     destination_address_prefix = "168.63.129.16"
#   }

# security_rule {
#     name                       = "Allow-ICMP-Outbound2"
#     priority                   = 310
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Icmp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#  security_rule {
#     name                       = "Allow-All-Outbound3"
#     priority                   = 320
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

# }

# resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
#   subnet_id                 = azurerm_subnet.subnet1.id
#   network_security_group_id = azurerm_network_security_group.nsg.id

# depends_on = [ azurerm_network_security_group.nsg, azurerm_subnet.subnet1 ]

# }


# resource "azurerm_subnet_network_security_group_association" "subnet_nsg2" {
#   subnet_id                 = azurerm_subnet.subnet2.id
#   network_security_group_id = azurerm_network_security_group.nsg2.id

# depends_on = [ azurerm_network_security_group.nsg, azurerm_subnet.subnet2 ]

# }

resource "azurerm_container_registry" "acr" {
  name                = "mojprywatnyacr123"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false

  tags = {
    Environment = "Dev"
  }

}

# # AKS cluster
# resource "azurerm_kubernetes_cluster" "aks" {
#   name                = "testowy"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   dns_prefix          = "kubernetessonaty-dns"
#   private_cluster_enabled = true
#   private_dns_zone_id = "System"

#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size    = "Standard_D2s_v3"
#     node_public_ip_enabled  = true
#     vnet_subnet_id = azurerm_subnet.subnet2.id

#   }

#   network_profile {
#     network_plugin= "kubenet"
#     network_policy    = "calico"
#     pod_cidr = "10.244.0.0/24"
#     service_cidr       = "10.100.0.0/16"
#     dns_service_ip     = "10.100.0.10"
#     load_balancer_sku = "standard"
#     load_balancer_profile {
#       outbound_ip_address_ids = [
#         azurerm_public_ip.vm_public_ip.id
#       ]
#     }
#   }

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.example.id]
#   }


#   tags = {
#     Environment = "Dev"
#   }

#   # depends_on = [
#   #   azurerm_role_assignment.example,
#   # ]
# }


resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/8b3fa8f8-a2d3-432c-ae70-d7f10d656b36/resourceGroups/rg-test-funcion/providers/Microsoft.Network/virtualNetworks/testvpc/subnets/subnet1"
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.vm_public_ip2.id
  }


  # depends_on = [ azurerm_network_security_group.nsg, azurerm_subnet.subnet1 ]
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "rhel-vm"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_password = "P@ssword1234!" # lub użyj ssh_key

  disable_password_authentication = false

dynamic "os_disk" {
  for_each = [var.os_disk_setting]
  content {
        caching              = os_disk.value.caching
        storage_account_type = os_disk.value.storage_account_type
        name                 = os_disk.value.name
  }
 }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8_5"
    version   = "latest"
  }
}

# # 2️⃣ App Service Plan
# resource "azurerm_service_plan" "appservice_plan" {
#   name                = "example-appservice-plan"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   os_type             = "Linux"
#   sku_name            = "B1"
# }

# # 3️⃣ App Service (Web App)
# resource "azurerm_linux_web_app" "webapp" {
#   name                = "example-webapp-12345"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   service_plan_id     = azurerm_service_plan.appservice_plan.id
#   public_network_access_enabled = true
#   virtual_network_subnet_id = azurerm_subnet.subnet2.id

#   site_config {
#     application_stack {
#       docker_image_name = "nginx:alpine"
#       docker_registry_url = "https://index.docker.io"
#     }
#   }

#   app_settings = {
#     "WEBSITE_RUN_FROM_PACKAGE" = "1"
#   }
# }


resource "azurerm_private_dns_zone" "example" {
  name                = "sonaty.privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
} 

# resource "azurerm_user_assigned_identity" "example" {
#   name                = "aks-example-identity"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   location            = data.azurerm_resource_group.rg.location
# }

# resource "azurerm_role_assignment" "example" {
#   scope                = azurerm_private_dns_zone.example.id
#   role_definition_name = "Private DNS Zone Contributor"
#   principal_id         = azurerm_user_assigned_identity.example.principal_id
# }

# resource "azurerm_role_assignment" "example" {
#   scope                = "/subscriptions/a2b28c85-1948-4263-90ca-bade2bac4df4/resourceGroups/kml_rg_main-33cc54f78f474b87"
#   role_definition_name = "Private DNS Zone Contributor"
#   principal_id         = azurerm_user_assigned_identity.example.principal_id
# }

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "test"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}


# # Azure Container Registry
# resource "azurerm_container_registry" "acr" {
#   name                     = "dockertestsonaty"   # musi być globalnie unikalna
#   resource_group_name      = data.azurerm_resource_group.rg.name
#   location                 = data.azurerm_resource_group.rg.location
#   sku                      = "Basic"               # Basic, Standard, Premium
#   admin_enabled            = true
# }

# output "acr_login_server" {
#   value = azurerm_container_registry.acr.login_server
# }

# output "acr_admin_username" {
#   value = azurerm_container_registry.acr.admin_username
# }

# output "acr_admin_password" {
#   value = azurerm_container_registry.acr.admin_password
#   sensitive = true
# }

#  
resource "azurerm_private_endpoint" "pe" {
  name                = "vm-private-endpoint"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet1.id

  private_service_connection {
    name                           = "example-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"] # przykład: dla Storage Account
  }
  private_dns_zone_group {
    name                 = "example-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.example.id]
  }
}

# resource "azurerm_lb" "lb" {
#   name                = "vm-lb"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   sku                 = "Standard"


#   frontend_ip_configuration {
#     name                 = "PublicIPAddress"
#     public_ip_address_id = azurerm_public_ip.vm_public_ip.id
#   }
# }


resource "azurerm_user_assigned_identity" "storage" {
  name                = "id-storage"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
}


resource "azurerm_storage_account" "storage" {
  name                     = "sonatydevstorage" # musi być unikalna nazwa globalnie!
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  public_network_access_enabled = false

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.storage.id]
  }

  # customer_managed_key {
  #   key_vault_key_id          = azurerm_key_vault_key.storage.id
  #   user_assigned_identity_id = azurerm_user_assigned_identity.storage.id
  # }
  
  depends_on = [
    azurerm_key_vault_access_policy.current_user,  # ← był  # ← dodaj
  ]

  customer_managed_key {
    key_vault_key_id          = azurerm_key_vault_key.storage.id
    user_assigned_identity_id = azurerm_user_assigned_identity.storage.id
  }

  
  tags = {
    environment = "demo"
  }

}

# Tworzymy Blob Container w Storage Account
resource "azurerm_storage_container" "blob_container" {
  name                  = "mycontainer"
  storage_account_id  = azurerm_storage_account.storage.id
  container_access_type = "private" # może być też "blob" lub "container" jeśli chcesz publiczny dostęp
}



# resource "azurerm_virtual_network_gateway" "vpn_gw" {
#   name                = "kk-vpn-gateway"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   type                = "Vpn"
#   vpn_type            = "RouteBased"
#   active_active       = false
#   enable_bgp          = false
#   sku                 = "VpnGw1"

#   ip_configuration {
#     name                          = "vnetGatewayConfig"
#     public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
#     subnet_id                     = azurerm_subnet.gateway.id
#     private_ip_address_allocation = "Dynamic"
#   }

#   vpn_client_configuration {
#     address_space        = ["172.16.201.0/24"]
#     vpn_client_protocols = ["OpenVPN"]

#     root_certificate {
#       name             = "myrootcert"
#       public_cert_data = filebase64("./rootcert.cer")
#     }
#   }
# }
# resource "azurerm_private_link_service" "pls" {
#   name                = "my-pls"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name

#   load_balancer_frontend_ip_configuration_ids = [
#    azurerm_lb.lb.frontend_ip_configuration[0].id
#   ]
  
#   nat_ip_configuration {
#     name                       = "primary"
#     private_ip_address         = "10.0.1.10"
#     private_ip_address_version = "IPv4"
#     subnet_id                  = azurerm_subnet.subnet1.id
#     primary                    = true
#   }


#   visibility {
#     subscriptions = ["<client-subscription-id>"] # lub puste: dostępny dla wszystkich
#   }

#   auto_approval {
#     subscriptions = ["<client-subscription-id>"]
#   }

# resource "azurerm_recovery_services_vault" "example" {
#   name                = "vm-recovery-vault"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   sku                 = "Standard"
#   soft_delete_enabled = false
# }

# resource "azurerm_backup_policy_vm" "example" {
#   name                = "tfex-recovery-vault-policy"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   recovery_vault_name = azurerm_recovery_services_vault.example.name

#   backup {
#     frequency = "Daily"
#     time      = "23:00"
#   }
#   retention_daily {
#     count = 10
#   }
# }

# resource "azurerm_backup_protected_vm" "vm1" {
#   resource_group_name = data.azurerm_resource_group.rg.name
#   recovery_vault_name = azurerm_recovery_services_vault.example.name
#   source_vm_id        = azurerm_linux_virtual_machine.vm.id
#   backup_policy_id    = azurerm_backup_policy_vm.example.id
# }



# resource "azurerm_log_analytics_workspace" "log_analytics" {
#   name                = "la-backup"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }

# resource "azurerm_monitor_diagnostic_setting" "rsv_diagnostics" {
#   name               = "rsv-diagnostics"
#   target_resource_id = azurerm_recovery_services_vault.example.id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

#  enabled_log {
#     category = "CoreAzureBackup"
#   }

#   enabled_metric {
#     category = "AllMetrics"
#   }


# }




# VAULT 

data "azurerm_client_config" "current" {}


# Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = "sonatydev-kv"  # musi być unikalna globalnie!
  resource_group_name         = data.azurerm_resource_group.rg.name
  location                    = data.azurerm_resource_group.rg.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"       # lub "premium" dla HSM
  public_network_access_enabled = true    
    enabled_for_disk_encryption = true
       # spójnie z Twoim storage

  # Soft delete - ochrona przed przypadkowym usunięciem
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true            # ustaw true na produkcji!

  tags = {
    environment = "demo"
  }
}

# Nadajemy uprawnienia dla aktualnego użytkownika/service principal
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge"
  ]


  key_permissions = [
    "Get", "List", "Create", "Delete", "Purge",
    "Encrypt", "Decrypt",
    "Sign", "Verify",
    "WrapKey", "UnwrapKey",
    "Backup", "Restore", "Recover",
    "GetRotationPolicy",   # ← TO DODAJ!
    "SetRotationPolicy"    # ← TO DODAJ!
  ]

}

resource "azurerm_key_vault_access_policy" "storage_user" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.storage.principal_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge"
  ]


  key_permissions = [
    "Get", "List", "Create", "Delete", "Purge",
    "Encrypt", "Decrypt",
    "Sign", "Verify",
    "WrapKey", "UnwrapKey",
    "Backup", "Restore", "Recover",
    "GetRotationPolicy",   # ← TO DODAJ!
    "SetRotationPolicy"    # ← TO DODAJ!
  ]

}

resource "azurerm_key_vault_key" "storage" {
  name         = "key-storage-encryption"
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  
  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }

    depends_on = [
    azurerm_key_vault_access_policy.current_user
  ]


}

# Przykładowy secret — np. connection string do Storage Account
resource "azurerm_key_vault_secret" "storage_connection" {
  name         = "storage-connection-string"
  value        = azurerm_storage_account.storage.primary_connection_string
  key_vault_id = azurerm_key_vault.kv.id

  tags = {
    environment = "demo"
  }

  depends_on = [azurerm_key_vault_access_policy.current_user]
}

resource "azurerm_role_assignment" "current_user_kv" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "storage_kv" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.storage.principal_id
}
