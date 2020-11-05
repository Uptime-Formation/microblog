FROM python:3.6-alpine

RUN addgroup -S microblog && adduser -S microblog -G microblog

ENV WORKING_DIRECTORY=/home/microblog
WORKDIR ${WORKING_DIRECTORY}

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# DATABASE_URL by default stores data in a SQLite app.db file in the data folder
# These settings can be overriden at runtime
# e.g. to use MySQL, override this variable with:
# DATABASE_URL=mysql+mysqlconnector://${MYSQL_USER}:${MYSQL_PASSWORD}@${MYSQL_HOST}/${MYSQL_DB}
ENV DATABASE_URL=sqlite:///${WORKING_DIRECTORY}/data/app.db
VOLUME ["${WORKING_DIRECTORY}/data"] 

COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./
RUN chmod a+x boot.sh

ENV FLASK_APP microblog.py

RUN chown -R microblog:microblog ./
USER microblog

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
