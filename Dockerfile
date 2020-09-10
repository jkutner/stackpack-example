FROM heroku/heroku:18-build

# TODO add a stackpack

RUN mkdir -p /cnb
COPY stack /cnb/stack

ARG pack_uid=1000
ARG pack_gid=1000

RUN groupadd heroku --gid ${pack_gid} && \
  useradd heroku -u ${pack_uid} -g ${pack_gid} -s /bin/bash -m
RUN mkdir /app && \
  chown heroku:heroku /app

ENV CNB_USER_ID=${pack_uid}
ENV CNB_GROUP_ID=${pack_gid}
ENV STACK "stackpack-18"
ENV CNB_STACK_ID "stackpack-18"
LABEL io.buildpacks.stack.id="stackpack-18"

USER heroku