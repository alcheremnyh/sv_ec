FROM node:10-alpine
RUN mkdir -p /home/node/sv_ec/node_modules && chown -R node:node /home/node/sv_ec
WORKDIR /home/node/sv_ec
COPY package*.json ./
USER node
RUN npm install
COPY --chown=node:node . .
EXPOSE 8434

CMD [ "node", "app.js" ]