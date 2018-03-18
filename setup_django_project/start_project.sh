#!/bin/bash

APP_NAME=$1

echo "=> Creating Application folder"
mkdir "${APP_NAME}_project"
cd "${APP_NAME}_project"

mkdir docs ${APP_NAME} tests
# Copy .gitignore to project directory
cp ../.gitignore ./.gitignore

# Copy LICENSE to project directory

touch README.md LICENSE .env TODO

cp ../makefile ./makefile

# Copy docker-compose yml files
cp ../docker-compose.yml ./docker-compose.yml
cp ../docker-compose.override.yml ./docker-compose.override.yml
cp ../docker-compose.prod.yml ./docker-compose.prod.yml
cp ../docker-compose.e2e.yml ./docker-compose.e2e.yml


# Change APP_NAME in docker-compose.yml files
sed -i -e "s/APP_NAME/${APP_NAME}/g" docker-compose.*
sed -i -e "s/APP_NAME/${APP_NAME}/g" makefile

cd ${APP_NAME}
# copy config for gunicorn
cp ../../gunicorn.conf gunicorn.conf
cp -r ../../docker_compose docker_compose

sed -i -e "s/APP_NAME/${APP_NAME}/g" docker_compose/django/Dockerfile
sed -i -e "s/APP_NAME/${APP_NAME}/g" docker_compose/nginx/nginx.conf


cd ..

docker-compose run web django-admin startproject ${APP_NAME} .

echo "==> Configuring django settings"
cd ${APP_NAME}/${APP_NAME}/

sudo chown -R 1000 .

mkdir settings
mv settings.py settings/base.py
cd settings

cat > development.py <<EOF
from .base import *

DEBUG = True
EOF

cat > production.py <<EOF
from .base import *

DEBUG = False
ALLOWED_HOSTS = ['app.project_name.com', ]
EOF

cat > __init__.py <<EOF
from .development import *
EOF

# Add settings.__init__.py file to gitignore
echo ""
if [ $? -eq 0 ]; then
  echo "Setup complete."
  echo "Run docker-compose up to start server"
else
  echo "Setup Failed"
fi