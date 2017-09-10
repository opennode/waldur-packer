#!/bin/sh -ex

yum clean all
yum -y update

# Set up Waldur core
curl https://raw.githubusercontent.com/opennode/waldur-core/develop/docs/guide/bootstrap-centos7.sh | sh -

su - waldur -c "waldur createstaffuser -u admin -p admin"

# Set up Waldur MasterMind
yum -y install centos-release-openstack-mitaka
yum -y install waldur-mastermind

su - waldur -c "waldur migrate --noinput"

systemctl restart waldur-uwsgi
systemctl restart waldur-celery
systemctl restart waldur-celerybeat

# Set up Waldur HomePort
yum -y install waldur-homeport

# Set up Nginx
yum -y install nginx

systemctl start nginx
systemctl enable nginx
