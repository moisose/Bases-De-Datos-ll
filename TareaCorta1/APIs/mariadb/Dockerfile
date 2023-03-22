FROM python:3.9

WORKDIR /app

COPY babynames.csv /app/
ENV ARCHIVO_CSV=/app/babynames.csv

COPY app/. .
RUN pip install --no-cache-dir -r requirements.txt
# RUN ls
# RUN python test_mariadb.py

CMD [ "python", "-u", "./mariaDBApi.py" ] 