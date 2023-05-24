FROM node:20-alpine as linter

WORKDIR /var/www/it.labs/

RUN npm i create-stylelint && \
    npm init stylelint

COPY src/ .

# RUN npx stylelint "**/*.css"

FROM nginx:1.23-alpine as webserver

COPY --from=linter /var/www/it.labs/ /var/www/it.labs/
COPY conf.d/ /etc/nginx/conf.d
