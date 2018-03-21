#!/bin/bash

chmod 777 -Rf /var/ftp_data

docker build -t ubuntu16.04/sftp-ftps .
docker run -d -p 2222:2222 -v /var/ftp_data:/home/uftp ubuntu16.04/sftp-ftps
