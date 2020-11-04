FROM python:3.6-alpine

RUN addgroup -S microblog && adduser -S microblog -G microblog

ENV WORKDIR=/home/microblog
WORKDIR ${WORKDIR}

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# SQLALCHEMY_DATABASE_URI's default settings store a SQLite app.db file at the root of the project
# These settings can be overriden at runtime
ENV DATABASE_URL=sqlite:///${WORKDIR}/data/app.db
VOLUME ["${WORKDIR}/data"] 

COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./
RUN chmod a+x boot.sh

ENV FLASK_APP microblog.py

RUN chown -R microblog:microblog ./
USER microblog

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
