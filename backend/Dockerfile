# Use the slim version of Python 3.14.4
FROM python:3.14.4-slim

# Use the /app as your workdir of the container
WORKDIR /app

# Add __init__.py to improve modulation
RUN mkdir -p __init__.py

# Copy requirments.txt from source code folder to container folder
COPY requirements/ requirements/

# Install Necessary python packages inside container
RUN pip install -r requirements/api.txt -r requirements/base.txt

# Make same directories as host machine for as much similarities as possible
RUN mkdir -p /src/api

# Copy api files from host to container
COPY backend/src/api/ ./src/api

# Run and deploy the api service
CMD ["python", "-m", "uvicorn", "src.api.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]