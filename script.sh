# !/bin/bash
#!/usr/bin/env bash

# install nginx
sudo apt-get update
sudo apt install -y docker.io
sudo apt-get install -y docker-compose
sudo apt -y install nginx
sudo service nginx start
sudo mkdir /tmp/airflow
sudo chmod +x /tmp/airflow
cd /tmp/airflow
mkdir dags
mkdir logs
mkdir plugins
docker-compose -f docker-compose.yaml up