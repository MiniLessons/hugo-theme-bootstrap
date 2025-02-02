# Build stage
FROM klakegg/hugo:ext-ubuntu as builder

RUN apt-get update -y

RUN apt-get install -y git curl
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -
RUN apt-get install -y nodejs

# Build site
WORKDIR /src
COPY . /src
ARG HUGO_BASEURL=/
ENV HUGO_BASEURL=${HUGO_BASEURL}
WORKDIR /src/exampleSite
RUN npm install
RUN npm install -g @fullhuman/postcss-purgecss
RUN hugo version
RUN hugo --themesDir=../../ --theme=src -b ${HUGO_BASEURL}

# Final stage
FROM nginx
COPY --from=builder /src/exampleSite/public /app
COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf
