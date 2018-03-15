FROM node:8.9.4

LABEL maintainer="Lincoln Brito <lincoln.sbrito@gmail.com>"
LABEL description="Vue CLI image"

WORKDIR /var/www/html

ARG uid=999

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb http://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y git yarn \
    && yarn global add webpack@3.10.0 \    
    && yarn global add vue-cli@2.9.3 \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN usermod -u $uid node

EXPOSE 8080
EXPOSE 3000

CMD ["yarn", "run", "start"]