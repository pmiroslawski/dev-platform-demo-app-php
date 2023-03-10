#!/bin/bash

export VARIABLE="env"

print_usage() {
  echo ""
  echo "USAGE: init.sh env"
  echo "Where"
  echo "    env: is a environment variable related to .env configuration"
  echo ""
}

if [ ! -z "$1" ]; then
  if [ "$1" = 'help' ] || [ "$1" = '-h' ];
  then
    print_usage
    exit 1
  fi
fi

# load default config file
export $(grep -v '^#' "../.env" | xargs)

if [ -n "$1" ]
then
  echo "TEST"
  export $(grep -v '^#' "../.env.$1" | xargs)
fi


configure_mariadb() {
  if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then
    echo "MYSQL_ROOT_PASSWORD has not been found."
    exit 1;
  fi

  if [ -z "${MYSQL_DATABASE}" ]; then
    echo "MYSQL_DATABASE has not been found."
    exit 1;
  fi

  if [ -z "${MYSQL_USER}" ]; then
    echo "MYSQL_USER has not been found."
    exit 1;
  fi

  if [ -z "${MYSQL_PASSWORD}" ]; then
    echo "MYSQL_PASSWORD has not been found."
    exit 1;
  fi

  export RUN_MYSQL="mysql -uroot -p${MYSQL_ROOT_PASSWORD}"

  docker exec -ti dev-platform-mariadb /bin/bash -c "echo CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} | ${RUN_MYSQL}";
  docker exec -ti dev-platform-mariadb /bin/bash -c "echo CREATE USER IF NOT EXISTS \'${MYSQL_USER}\'@\'%\' IDENTIFIED BY \'${MYSQL_PASSWORD}\' | ${RUN_MYSQL}";
  docker exec -ti dev-platform-mariadb /bin/bash -c "echo GRANT USAGE ON ${MYSQL_DATABASE}.* TO \'${MYSQL_USER}\'@\'%\' IDENTIFIED BY \'${MYSQL_PASSWORD}\' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 | ${RUN_MYSQL}";
  docker exec -ti dev-platform-mariadb /bin/bash -c "echo GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO \'${MYSQL_USER}\'@\'%\' | ${RUN_MYSQL}";
}

configure_rabbitmq() {
  if [ -z "${RABBITMQ_ADMIN}" ]; then
    echo "RABBITMQ_ADMIN has not been found."
    exit 1;
  fi

  if [ -z "${RABBITMQ_USER}" ]; then
    echo "RABBITMQ_USER has not been found."
    exit 1;
  fi

  if [ -z "${RABBITMQ_PASS}" ]; then
    echo "RABBITMQ_PASS has not been found."
    exit 1;
  fi

  if [ -z "${RABBITMQ_VHOST}" ]; then
    echo "RABBITMQ_VHOST has not been found."
    exit 1;
  fi

  docker exec -ti dev-platform-rabbitmq /bin/bash -c "rabbitmqctl add_vhost /$RABBITMQ_VHOST;";
  docker exec -ti dev-platform-rabbitmq /bin/bash -c "rabbitmqctl add_user $RABBITMQ_USER $RABBITMQ_PASS;";
  docker exec -ti dev-platform-rabbitmq /bin/bash -c "rabbitmqctl set_permissions -p /$RABBITMQ_VHOST $RABBITMQ_USER  \".*\" \".*\" \".*\";";

  docker exec -ti dev-platform-rabbitmq /bin/bash -c "rabbitmqctl set_permissions -p /$RABBITMQ_VHOST $RABBITMQ_ADMIN  \".*\" \".*\" \".*\";";
}

# Database configure
configure_mariadb
configure_rabbitmq
