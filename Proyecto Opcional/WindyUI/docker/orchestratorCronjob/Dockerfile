FROM python:3.10.7-slim-bullseye

WORKDIR /app

COPY app/. .
RUN pip install --no-cache-dir -r requirements.txt
# RUN ls
# RUN python test_orchestrator.py

CMD [ "python", "-u", "./app.py" ]
