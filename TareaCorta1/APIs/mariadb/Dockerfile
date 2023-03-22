FROM python:3.9

WORKDIR /app

COPY ./mariadb/app/. .
COPY babynames.csv .
RUN pip install --no-cache-dir -r requirements.txt
# RUN ls
# RUN python test_mariadb.py

CMD [ "python", "-u", "./mariaDBApi.py" ] 