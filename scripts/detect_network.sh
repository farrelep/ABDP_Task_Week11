#!/bin/bash
# Deteksi nama docker network container mysql-server
docker inspect mysql-server -f '{{range $k, $v := .NetworkSettings.Networks}}{{$k}}{{"\n"}}{{end}}'
