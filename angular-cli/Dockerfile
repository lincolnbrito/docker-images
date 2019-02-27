FROM node:8.9.4

LABEL maintainer="Lincoln Brito <lincoln.sbrito@gmail.com>"
LABEL description="Angular CLI image"

WORKDIR /var/www/html

ARG uid=999

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb http://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y git yarn \
    && yarn global add @angular/cli \
    && ng set --global packageManager=yarn \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN usermod -u $uid node

EXPOSE 4200
EXPOSE 49153

CMD ["yarn", "run", "start"]
