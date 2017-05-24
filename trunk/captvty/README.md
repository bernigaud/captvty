Container Docker pour Captvty.
------------------------------

Bas� sur la documentation de Guillaume de Captvty.fr

Dockerfile d�crit la construction du container

makefile d�crit les op�rations possibles

# Op�rations de base

## Construire l'image
make build

## Lancer
make run


# Mise � jour
Il faut que le container se mette � jour � partir du download de captvty.zip
Pour cela, modifier la version dans la ligne suivante:
RUN echo "Change me to upgrade: v2.5.9 " && wget http://captvty.fr -O /tmp/captvty.html 

# Configuration
Le r�pertoire de t�l�chargement de captvty est mapp� sur un r�pertoire de la machine docker-host
Il est d�fini dans le makefile par
HOST_DOWNLOAD_DIR=$(HOME)/downloads



