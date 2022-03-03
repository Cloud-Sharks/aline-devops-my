FROM mysql
ENV MYSQL_ROOT_PASSWORD root
ENV MYSQL_DATABASE alinedb
ENV MYSQL_USER user
ENV MYSQL_PASSWORD pwd
COPY aline-db-schema.sql /docker-entrypoint-initdb.d/aline-db-schema.sql