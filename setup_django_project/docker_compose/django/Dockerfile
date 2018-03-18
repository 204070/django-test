FROM python:3.6.2
ENV PYTHONUNBUFFERED 1

# update package lists, fix broken system packages
RUN apt-get update
RUN apt-get -f install

# install and cache dependencies in /tmp directory
# doing it this way also installs any newly added dependencies
RUN pip install --upgrade pip
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# load project files and set work directory
ADD . /app
WORKDIR /app

# create user and add to docker group
RUN adduser --disabled-password --gecos '' djangoAPP_NAME
RUN groupadd docker
RUN usermod -aG docker djangoAPP_NAME

# grant newly created user permissions on essential files
RUN chown -R djangoAPP_NAME:$(id -gn djangoAPP_NAME) ~/
RUN chown -R djangoAPP_NAME:$(id -gn djangoAPP_NAME) /app/

# change user to newly created user
USER djangoAPP_NAME