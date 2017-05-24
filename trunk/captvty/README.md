Container Docker pour Captvty.
------------------------------

Basé sur la documentation de Guillaume de Captvty.fr

Dockerfile décrit la construction du container

makefile décrit les opérations possibles

# Opérations de base

## Construire l'image
make build

## Lancer
make run


# Mise à jour
Il faut que le container se mette à jour à partir du download de captvty.zip
Pour cela, modifier la version dans la ligne suivante:
RUN echo "Change me to upgrade: v2.5.9 " && wget http://captvty.fr -O /tmp/captvty.html 

# Configuration
Le répertoire de téléchargement de captvty est mappé sur un répertoire de la machine docker-host
Il est défini dans le makefile par
HOST_DOWNLOAD_DIR=$(HOME)/downloads



