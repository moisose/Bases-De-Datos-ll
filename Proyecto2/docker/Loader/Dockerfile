FROM python:3.10.7-slim-bullseye

WORKDIR /app

#COPY ./downloadedFiles .
COPY app/ .
RUN pip install --no-cache-dir -r requirements.txt

#RUN ls
#RUN python -u unittests.py

#CMD [ "flask",  "--app", "app", "run", "--host=0.0.0.0" ]
CMD [ "python", "-u", "./app.py" ] 