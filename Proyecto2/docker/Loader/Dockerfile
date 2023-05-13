FROM python:3.10.7-slim-bullseye

WORKDIR /app

#COPY ./downloadedFiles .
COPY app/ .
RUN pip install --no-cache-dir -r requirements.txt
#-------------------------------------
ARG USERNAME
ENV USERNAME ${USERNAME}
#-------------------------------------
ARG PASSWORD
ENV PASSWORD ${PASSWORD}
#-------------------------------------
ARG DATABASE
ENV DATABASE ${DATABASE}
#-------------------------------------
ARG ARTISTS_COLLECTION
ENV ARTISTS_COLLECTION ${ARTISTS_COLLECTION}
#-------------------------------------
ARG LYRICS_COLLECTION
ENV LYRICS_COLLECTION ${LYRICS_COLLECTION}

#RUN ls
#RUN python -u unittests.py

#CMD [ "flask",  "--app", "app", "run", "--host=0.0.0.0" ]
CMD [ "python", "-u", "./app.py" ] 