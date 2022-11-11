
# Provisionando Usuários e Grupos
provider "googleworkspace" {
  credentials             = "${file("serviceaccount.yaml")}"
  customer_id             = "C0332gag2"
  impersonated_user_email = "pvs@paulovitor.dev.br"
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.userschema",
    "https://www.googleapis.com/auth/admin.directory.group",	
    # include scopes as needed
  ]
}

# Criando Grupo Marketing e Usuário
resource "googleworkspace_group" "marketing" {
  email       = "marketing@paulovitor.dev.br"
  name        = "Marketing"
  description = "Grupo para membros do Marketing"

  aliases = ["marketing-pvs@paulovitor.dev.br"]

  timeouts {
    create = "1m"
    update = "1m"
  }
}

resource "googleworkspace_user" "paulo" {
  primary_email = "paulo@paulovitor.dev.br"
  password      = "34819d7beeabb9260a5c854bc85b3e44"
  hash_function = "MD5"

  name {
    given_name  = "Paulo"
    family_name = "Vitor"
  }
}

resource "googleworkspace_group_member" "manager1" {
  group_id = googleworkspace_group.marketing.id
  email    = googleworkspace_user.paulo.primary_email

  role = "MANAGER"

}

# Criando Grupo Devops e Usuário
resource "googleworkspace_group" "devops" {
  email       = "devops@paulovitor.dev.br"
  name        = "Devops"
  description = "Grupo para membros DevOps"

  aliases = ["dev-ops@paulovitor.dev.br"]

  timeouts {
    create = "1m"
    update = "1m"
  }
}

resource "googleworkspace_user" "du" {
  primary_email = "du@paulovitor.dev.br"
  password      = "34819d7beeabb9260a5c854bc85b3e44"
  hash_function = "MD5"

  name {
    given_name  = "Du"
    family_name = "Alves"
  }
}

resource "googleworkspace_group_member" "manager2" {
  group_id = googleworkspace_group.devops.id
  email    = googleworkspace_user.du.primary_email

  role = "MANAGER"

}

# Criando Grupo SRE e Usuário
resource "googleworkspace_group" "sre" {
  email       = "sre@paulovitor.dev.br"
  name        = "SRE"
  description = "Grupo para membros SRE"

  aliases = ["sre-pvs@paulovitor.dev.br"]

  timeouts {
    create = "1m"
    update = "1m"
  }
}

resource "googleworkspace_user" "dudu" {
  primary_email = "dudu@paulovitor.dev.br"
  password      = "34819d7beeabb9260a5c854bc85b3e44"
  hash_function = "MD5"

  name {
    given_name  = "Dudu"
    family_name = "Santos"
  }
}

resource "googleworkspace_group_member" "manager3" {
  group_id = googleworkspace_group.sre.id
  email    = googleworkspace_user.dudu.primary_email

  role = "MANAGER"

}

# Criando Grupo Financeiro e Usuário
resource "googleworkspace_group" "financeiro" {
  email       = "financeiro@paulovitor.dev.br"
  name        = "Financeiro"
  description = "Grupo para membros Financeiro"

  aliases = ["financeiro-pvs@paulovitor.dev.br"]

  timeouts {
    create = "1m"
    update = "1m"
  }
}

resource "googleworkspace_user" "edu" {
  primary_email = "edu@paulovitor.dev.br"
  password      = "34819d7beeabb9260a5c854bc85b3e44"
  hash_function = "MD5"

  name {
    given_name  = "Edu"
    family_name = "Silva"
  }
}

resource "googleworkspace_group_member" "manager4" {
  group_id = googleworkspace_group.financeiro.id
  email    = googleworkspace_user.edu.primary_email

  role = "MANAGER"

}


# Provisionando Recursos do Console GCP 

provider "google" {
  project      = "pvs-devops-iac"
  region       = "us-central1"
  zone         = "us-central1-c"
  credentials  = "${file("servicesaccount.yaml")}"
}

resource "google_folder" "Financeiro" {
  display_name = "Financeiro"
  parent       = "organizations/43457189655"  
}

# Provisionando estrutura para o backend da aplicação
resource "google_folder" "ApiFinan" {
  display_name = "ApiFinan"
  parent       = google_folder.Financeiro.name
}

resource "google_folder" "ApiFinanDev" {
  display_name = "Desenvolvimento"
  parent       = google_folder.ApiFinan.name
}

resource "google_folder" "ApiFinanProd" {
  display_name = "Producao"
  parent       = google_folder.ApiFinan.name
}

resource "google_project" "pvs-apifinan-dev" {
  name =  "ApiFinan-Dev"
  project_id = "pvs-apifinan-dev"
  folder_id = google_folder.ApiFinanDev.name
  auto_create_network = false
  billing_account = "01E7B2-4AE1CA-5C9264"
}

resource "google_project" "pvs-apifinan-prod" {
  name =  "ApiFinan-Prod"
  project_id = "pvs-apifinan-prod"
  folder_id = google_folder.ApiFinanProd.name
  auto_create_network = false
  billing_account = "01E7B2-4AE1CA-5C9264"
}

# Provisionando estrutura para o frontend da aplicação
resource "google_folder" "ClientFinan" {
  display_name = "ClientFinan"
  parent       = google_folder.Financeiro.name
}

resource "google_folder" "ClientFinanDev" {
  display_name = "Desenvolvimento"
  parent       = google_folder.ClientFinan.name
}

resource "google_folder" "ClientFinanProd" {
  display_name = "Producao"
  parent       = google_folder.ClientFinan.name
}

resource "google_project" "pvs-clientfinan-dev" {
  name =  "ClientFinan-Dev"
  project_id = "pvs-clientfinan-dev"
  folder_id = google_folder.ClientFinanDev.name
  auto_create_network = false
  billing_account = "01E7B2-4AE1CA-5C9264"
}

resource "google_project" "pvs-clientfinan-prod" {
  name =  "ClientFinan-Prod"
  project_id = "pvs-clientfinan-prod"
  folder_id = google_folder.ClientFinanProd.name
  auto_create_network = false
  billing_account = "01E7B2-4AE1CA-5C9264"
}

# Criando alerta de Monitoramento de custos do projeto
data "google_billing_account" "account" {
  billing_account = "01E7B2-4AE1CA-5C9264"
}

data "google_project" "project" {
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.id
  display_name    = "Meu Alerta de Faturamento"

  budget_filter {
    projects = ["projects/${data.google_project.project.number}"]
  }

  amount {
    specified_amount {
      currency_code = "BRL"
      units         = "10"
    }
  }

  threshold_rules {
    threshold_percent = 1.0
  }
  threshold_rules {
    threshold_percent = 1.0
    spend_basis       = "FORECASTED_SPEND"
  }


}

