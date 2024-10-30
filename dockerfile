# Utilisez une image de base légère
FROM python:3.12-slim

# Définissez les métadonnées
LABEL maintainer="mohamed.ge21@gmail.com"
LABEL version="1.0"
LABEL description="Docker image for dbt project using Snowflake"

# Installer les dépendances du système
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libffi-dev \
    libpq-dev \
    git \
    tini \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Créer et définir le répertoire de travail
WORKDIR /usr/src/app

# Copier le fichier requirements.txt et installer les dépendances Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copier tout le contenu du projet dans le répertoire de travail
COPY DBT_transform_comments ./
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Commande par défaut pour exécuter dbt
ENTRYPOINT ["tini", "--", "/usr/local/bin/entrypoint.sh"]