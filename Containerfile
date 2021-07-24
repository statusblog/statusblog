FROM hexpm/elixir:1.12.2-erlang-24.0.3-alpine-3.14.0 as build

# install build dependencies
RUN apk add --no-cache build-base npm git python3 curl

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ARG MIX_ENV="prod"
ENV MIX_ENV="${MIX_ENV}"

# get mix dependencies
COPY mix.exs mix.lock .
COPY apps/statusblog/mix.exs apps/statusblog/
COPY apps/statusblog_web/mix.exs  apps/statusblog_web/
COPY apps/statusblog_site_web/mix.exs apps/statusblog_site_web/
RUN mix deps.get --only $MIX_ENV

# Dependencies sometimes use compile-time configuration. Copying
# these compile-time config files before we compile dependencies
# ensures that any relevant config changes will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/$MIX_ENV.exs config/
RUN mix deps.compile

# install statusblog_web asset deps
COPY apps/statusblog_web/assets apps/statusblog_web/assets/
RUN npm --prefix ./apps/statusblog_web/assets ci --progress=false --no-audit --loglevel=error

# install statusblog_site_web asset deps
COPY apps/statusblog_site_web/assets apps/statusblog_site_web/assets/
RUN npm --prefix ./apps/statusblog_site_web/assets ci --progress=false --no-audit --loglevel=error

# copy everything else besides config/runtime.exs
COPY apps apps

# webpack
RUN npm run --prefix ./apps/statusblog_web/assets deploy
RUN npm run --prefix ./apps/statusblog_site_web/assets deploy

# this will run for both of our phoenix sites
RUN mix phx.digest

# compile and build the release
RUN mix compile

# changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix release

# Start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM alpine:3.14.0 AS app
RUN apk add --no-cache openssl ncurses-libs libstdc++

ENV USER="elixir"

# set build ENV (again)
ARG MIX_ENV="prod"
ENV MIX_ENV="${MIX_ENV}"

WORKDIR "/home/${USER}/app"
# Creates an unprivileged user to be used exclusively to run the Phoenix app
RUN \
  addgroup \
   -g 1000 \
   -S "${USER}" \
  && adduser \
   -s /bin/sh \
   -u 1000 \
   -G "${USER}" \
   -h /home/elixir \
   -D "${USER}" \
  && su "${USER}"

# Everything from this line onwards will run in the context of the unprivileged user.
USER "${USER}"

COPY --from=build --chown="${USER}":"${USER}" /app/_build/"${MIX_ENV}"/rel/statusblog_umbrella ./

ENTRYPOINT ["bin/statusblog_umbrella"]

# Usage:
#  * build: sudo docker image build -t elixir/my_app .
#  * shell: sudo docker container run --rm -it --entrypoint "" -p 127.0.0.1:4000:4000 elixir/my_app sh
#  * run:   sudo docker container run --rm -it -p 127.0.0.1:4000:4000 --name my_app elixir/my_app
#  * exec:  sudo docker container exec -it my_app sh
#  * logs:  sudo docker container logs --follow --tail 100 my_app
CMD ["start"]
