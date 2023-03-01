FROM python:3.9

WORKDIR /app

# Copiar el archivo.py que queremos ejecutar a la imagen. Creo que aqui se agrega reque.txt
COPY app/. .

# Ejecutar el archivo al iniciar la imagen en un contenedor.
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "./script.py"]

#sudo docker build -t {nombreImagen} . 
