FROM python:latest

RUN mkdir /build

WORKDIR /build

COPY app /build

COPY app/requirements.txt /build

EXPOSE 7000

RUN pip install --upgrade pip && pip install -r requirements.txt

USER 1000

CMD [ "python3", "app.py" ]