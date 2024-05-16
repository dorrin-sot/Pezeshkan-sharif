FROM node:18

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

ENV pg_url postgresql://sad_root:IBkOzb8jd7NF@ep-noisy-wood-a1vwc6lo.ap-southeast-1.aws.neon.tech/sad_db?sslmode=require
ENV server_port 80
ENV jwt_secret_key H3d1dHUV4cm0PckrePij/NEZ40gQMd5iXP971V4vu9Y=
ENV cookie_max_age 86400000

EXPOSE 80

CMD ["node", "index.js"]
