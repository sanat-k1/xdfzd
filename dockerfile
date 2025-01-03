FROM python:3.8-slim
WORKDIR /
COPY . .
RUN pip install prometheus_client
CMD ["python", "app.py"]