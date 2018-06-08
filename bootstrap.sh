#!/bin/sh -ex

yum clean all
yum -y update

# Configure repositories
yum -y install epel-release
yum -y install https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm
yum -y install https://opennodecloud.com/centos/7/elastic-release.rpm
yum -y install https://opennodecloud.com/centos/7/waldur-release.rpm
yum -y install centos-release-openstack-pike

# Set up PostgreSQL
yum -y install postgresql95-server
/usr/pgsql-9.5/bin/postgresql95-setup initdb
systemctl start postgresql-9.5
systemctl enable postgresql-9.5

su - postgres -c "/usr/pgsql-9.5/bin/createdb -EUTF8 waldur"
su - postgres -c "/usr/pgsql-9.5/bin/createuser waldur"

# Set up Redis
yum -y install redis
systemctl start redis
systemctl enable redis

# Set up Elasticsearch
yum -y install elasticsearch java

systemctl start elasticsearch
systemctl enable elasticsearch

# Set up Logstash
yum -y install logstash

cat > /etc/logstash/conf.d/waldur-events.json <<EOF
input {
  tcp {
    codec => json
    port => 5959
    type => "waldur-event"
  }
}

filter {
  if [type] == "waldur-event" {

    mutate {
      remove_field => [ "class", "file", "logger_name", "method", "path", "priority", "thread" ]
    }

    grok {
      match => { "host" => "%{IPORHOST:host}:%{POSINT}" }
      overwrite => [ "host" ]
    }
  }
}

output {
  elasticsearch { }
}
EOF

systemctl start logstash
systemctl enable logstash


# Set up Waldur MasterMind
yum -y install waldur-mastermind

su - waldur -c "waldur migrate --noinput"

su - waldur -c "waldur createstaffuser -u admin -p admin"

systemctl start waldur-uwsgi
systemctl enable waldur-uwsgi

systemctl start waldur-celery
systemctl enable waldur-celery

systemctl start waldur-celerybeat
systemctl enable waldur-celerybeat

# Set up Waldur HomePort
yum -y install waldur-homeport

# Set up Nginx
yum -y install nginx

systemctl start nginx
systemctl enable nginx
