FROM python:3-alpine

COPY ./requirements.txt /requirements.txt
RUN pip3 install -r requirements.txt
ENV FLASK_APP microblog.py

COPY ./ /microblog
WORKDIR /microblog

ENV APP_ENVIRONMENT PROD

EXPOSE 5000

CMD ["./boot.sh"]