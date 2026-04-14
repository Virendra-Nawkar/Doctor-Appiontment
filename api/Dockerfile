FROM node:18-alpine

WORKDIR /app

COPY packag*.json ./

RUN npm install

COPY . . 

EXPOSE 5000

CMD ["npm","start"]

