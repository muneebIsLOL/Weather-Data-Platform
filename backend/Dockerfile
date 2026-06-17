# Use the slim version of Python 3.14.4
FROM python:3.14.4-slim

ENV PYTHONPATH=/app

# Use the app as your workdir of the container
WORKDIR /app

# Copy requirments.txt from source code folder to container folder
COPY requirements/ requirements/

# Install Nncessary python packages inside container
RUN pip install -r requirements/api.txt -r requirements/base.txt

COPY backend/src/api/ .

CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]