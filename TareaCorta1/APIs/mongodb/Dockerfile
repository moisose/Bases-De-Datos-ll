FROM python:3.9

WORKDIR /app

COPY ./mongodb/app/. .
COPY babynames.csv .
RUN pip install --no-cache-dir -r requirements.txt
# RUN ls
# RUN python test_mariadb.py

EXPOSE 5000
CMD [ "python", "-u", "./mongoDBApi.py" ] 