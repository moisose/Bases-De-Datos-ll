FROM python:3.10.7-slim-bullseye

EXPOSE 5000
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update -y 
RUN apt-get install curl -y 
RUN apt-get install gnupg -y

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update -y

RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18

RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc

RUN ls
RUN python -u unittest.py

WORKDIR /app

COPY app/. .
RUN pip install --no-cache-dir -r requirements.txt

CMD [ "flask",  "--app", "app", "run", "--host=0.0.0.0" ]