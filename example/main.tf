provider "postgresql" {
  scheme          = "gcppostgres"
  host            = module.postgresql.postgres_instance_connection_name
  port            = 5432
  database        = replace(var.project, "-", "_")
  username        = "postgres"
  password        = module.postgresql.postgres_postgres_password
  sslmode         = "require"
  connect_timeout = 15
}

module "database_users" {
  source = "../"
  users = {
    "ackee.fella" : {
      permissions : ["DELETE", "SELECT", "INSERT", "REFERENCES", "TRIGGER", "TRUNCATE", "UPDATE"]
      seq_permissions : ["USAGE", "UPDATE", "SELECT"]
      seq_objects : [
        "audits_id_seq",
        "countries_id_seq",
        "discounts_id_seq",
        "ga_callbacks_id_seq",
        "invoices_id_seq",
        "languages_id_seq",
        "merchants_id_seq",
        "mf_callbacks_id_seq",
        "shops_id_seq"
      ]
    }
    "reader-sa" : {
      permissions : ["SELECT"]
      create_sa : true
    }
    "mr.unicorn@ackee.cz" : {
      permissions : ["SELECT"]
      type : "CLOUD_IAM_USER"
    }
  }
  vault_secret_path      = var.vault_secret_path
  database               = var.project
  postgres_instance_name = module.postgresql.postgres_instance_name
  project                = var.project
}

module "postgresql" {
  source                 = "git::ssh://git@github.com/AckeeCZ/terraform-sql-postgresql.git"
  project                = var.project
  region                 = var.region
  zone                   = var.zone
  namespace              = var.namespace
  cluster_ca_certificate = module.gke.cluster_ca_certificate
  cluster_token          = module.gke.access_token
  cluster_endpoint       = module.gke.endpoint
  environment            = var.environment
  availability_type      = "REGIONAL"
  vault_secret_path      = "secret/devops/production/${var.project}/${var.environment}"
  private_ip             = true
  public_ip              = true
  sqlproxy_dependencies  = false
  deletion_protection    = false

  database_flags = {
    log_connections : "on",
    "cloudsql.iam_authentication" : "on",
  }
}

module "gke" {
  source            = "git::ssh://git@github.com/AckeeCZ/terraform-gke-vpc.git?ref=v11.11.0"
  cluster_name      = "postgresql-cluster-test"
  namespace         = var.namespace
  project           = var.project
  location          = var.zone
  vault_secret_path = var.vault_secret_path
  private           = false
  min_nodes         = 1
  max_nodes         = 2
}

variable "environment" {
  default = "development"
}

variable "namespace" {
  default = "stage"
}

variable "project" {
}

variable "vault_secret_path" {
}

variable "region" {
  default = "europe-west3"
}

variable "zone" {
  default = "europe-west3-c"
}
