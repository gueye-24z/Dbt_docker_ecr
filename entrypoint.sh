#!/bin/bash

export DBT_PROFILES_DIR=/usr/src/app/.dbt
export DBT_PROJECT_DIR=/usr/src/app/

dbt run --profiles-dir $DBT_PROFILES_DIR --project-dir $DBT_PROJECT_DIR