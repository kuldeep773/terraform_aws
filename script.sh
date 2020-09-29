#!/bin/bash

# install nginx
apt-get update
apt-get -y install nginx

# make sure nginx is started and install nginx
service nginx start
