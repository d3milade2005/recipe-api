# https://chatgpt.com/share/677d3e79-0dd0-8001-ba00-bce9d4f2f890 explanation of this code
#This Dockerfile defines how to build our docker image


FROM python:3.9-alpine3.13
LABEL maintainer="demiandtech"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user


# Why Set ARG DEV=false in the Dockerfile?
# Ensures that if DEV is not explicitly overridden during the build process (e.g., when building directly using docker build), it defaults to false for production.
# Prevents accidental inclusion of development-only features or dependencies in production builds.