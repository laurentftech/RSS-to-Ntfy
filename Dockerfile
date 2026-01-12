FROM python:3.12-alpine

WORKDIR /app

# Dépendances système (si nécessaires aux libs du projet)
RUN apk add --no-cache gcc musl-dev libffi-dev

# Dépendances Python du projet
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Script du projet
COPY rss-to-ntfy.py .

# Dossier d'état persistant
RUN mkdir -p /app/state

CMD ["python", "rss-to-ntfy.py"]
