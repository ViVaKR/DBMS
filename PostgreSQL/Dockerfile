FROM postgres:18-bookworm

RUN apt-get update && \
    apt-get install -y locales && \
    sed -i 's/# ko_KR.UTF-8 UTF-8/ko_KR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen ko_KR.UTF-8 && \
    ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=ko_KR.UTF-8 \
    LC_ALL=ko_KR.UTF-8 \
    LANGUAGE=ko_KR.UTF-8

# init-db.sql 자동 실행
COPY ./init-db.sql /docker-entrypoint-initdb.d/
