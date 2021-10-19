FROM python:3.9-alpine as build

COPY requirements.txt requirements.txt
COPY main.py /app/main.py
RUN apk update && \
    pip install pyinstaller && \
    pip install -r requirements.txt && \
    mkdir /app
WORKDIR /app
RUN pyinstaller -F main.py

from alpine:3.14 as release
RUN mkdir /app
COPY --from=build /app/dist/main /app/main
WORKDIR /app
EXPOSE 8080
CMD ./main -p 8080