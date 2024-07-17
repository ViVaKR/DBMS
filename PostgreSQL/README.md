# PostgreSQL

## Docker Image

```bash
    docker run -it -d --restart=always \
    --name viv-postgres \
    -p 59293:5432 \
    -e POSTGRES_PASSWORD=postgres \
    -e LANG=ko_KR.utf8 \
    -e TZ=Asiz/Seoul \
    -e POSTGRES_INITDB_ARGS="--data-checksums -E utf8 --no-locale" \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v ~/Docker/Postgres/Data:/var/lib/postgresql/data \
    postgres:latest


    docker run -it -d --restart=always \
    --name viv-postgres \
    -p 59293:5432 \
    -e POSTGRES_PASSWORD=postgres \
    -e LANG=ko_KR.utf8 \
    -e TZ=Asiz/Seoul \
    -e POSTGRES_INITDB_ARGS="--data-checksums -E utf8 --no-locale" \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v ~/Docker/Postgres/Data:/var/lib/postgresql/data \
    postgres:latest
```

## Connecte & Test

`docker exec -it viv_postgres /bin/bash`

`psql --version`
`local-gen ko_KR ko_KR.UTF-8`
`dpkg-reconfigure locales` -> ...

```bash
sudo locale-gen en_US en_US.UTF-8
sudo dpkg-reconfigure locales
```

`psql -U postgres`

`$ create user viv password 'B9037!m8947#' SUPERUSER`
`\du`

`select * from pg_shadow;`

## 권한 부여

`alter role vivakr CREATEDB;`
`alter role vivkr REPLICATION;`
`\! clear`
`create database vivakr owner vivkr;`

# 데이터베이스 접속 및 스크마 생성

$ \c vivakr vivakr;
$ create schema member;
$ \dn
