FROM python:3.10.7-slim-bullseye

WORKDIR /app

#COPY ./downloadedFiles .
COPY app/ .
RUN pip install --no-cache-dir -r requirements.txt

ARG ENV_FILE
ENV ENV_FILE ${ENV_FILE}
RUN test -n "$ENV_FILE" && echo "Cargando variables de entorno desde $ENV_FILE" && source "$ENV_FILE" || echo "No se ha especificado un archivo .env"
#test -n "$USERNAME"

#RUN ls
#RUN python -u unittests.py

#CMD [ "flask",  "--app", "app", "run", "--host=0.0.0.0" ]
CMD [ "python", "-u", "./app.py" ] 