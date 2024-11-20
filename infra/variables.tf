variable "SNOWFLAKE_DATABASE" {
    type = string
    description = Base de données de travail
}

variable "SNOWFLAKE_ACCOUNT" {
    type = string
    description = Compte snowflake
}

variable "SNOWFLAKE_SCHEMA" {
    type = string
    description = Schéma snowflake contenant les tables
}

variable "SNOWFLAKE_USER" {
    type = string
    description = Utilisateur snowflake
}

variable "SNOWFLAKE_WAREHOUSE" {
    type = string
    description = Warehouse snowflake
}

variable "SNOWFLAKE_ROLE" {
    type = string
    description = Role snowflake
}

variable "SNOWFLAKE_PASSWORD" {
    type = string
    description = Mot de passe snowflake
}

variable "TASK_NAME" {
    type = string
    description = Nom de la tache
}