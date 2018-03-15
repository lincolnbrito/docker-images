# base image
FROM node:boron

# dir to hold app code
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# bundle app source
COPY . /usr/src/app

# port
EXPOSE 8080

# run the server
CMD ["npm", "start"]