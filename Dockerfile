FROM ruby:2.6.5
MAINTAINER JeongWooYeong(wjd030811@gmail.com)

ENV SECRET_KEY_BASE $SECRET_KEY_BASE
ENV MYSQL_ROOT_PASSWORD $MYSQL_ROOT_PASSWORD
ENV QUIZLET_DATABASE_PATH $QUIZLET_DATABASE_PATH

RUN apt-get update && \
    apt-get install -y \
    default-libmysqlclient-dev \
    nodejs

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

RUN gem install bundler

RUN mkdir quizlet
COPY . quizlet
WORKDIR quizlet

RUN bundle install

EXPOSE 3000