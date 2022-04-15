FROM mysql:8.0

ENV MYSQL_DATABASE=django_app \
  MYSQL_USER=user \
  MYSQL_PASSWORD=jcsuser \
  MYSQL_ROOT_PASSWORD=jcsadmin \
  TZ=Asia/Tokyo

COPY ./my.cnf /etc/mysql/conf.d/my.cnf
RUN chmod 644 /etc/mysql/conf.d/my.cnf
