FROM python:3.14.0

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Crear la base de datos dentro del contenedor
RUN python create_db.py

EXPOSE 5000

CMD ["python", "vulnerable_app.py"]
