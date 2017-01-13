#!/bin/bash

cp docker-compose-example.yml docker-compose.yml
cp .env-example .env
TOKEN=$(composer config -g github-oauth.github.com)
sed -i -e "s/API_TOKEN: \".*\"/API_TOKEN: \"$TOKEN\"/g" docker-compose.yml

