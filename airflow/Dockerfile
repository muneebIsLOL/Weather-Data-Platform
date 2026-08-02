# Use the slim version of Python 3.14.4
FROM apache/airflow:3.2.2

# Set the environment variable for container seperately
ENV PYTHONPATH=/opt/airflow/

# Use the app as your workdir of the container
WORKDIR /opt/airflow/

# Copy the requiremnts folder into the container
COPY requirements/ requirements/

# Install Necessary python packages inside container
RUN pip install --upgrade pip && \
    pip install -r requirements/airflow.txt -r requirements/base.txt

COPY --chown=airflow:root ./backend/src/ELT ./src/ELT
COPY --chown=airflow:root ./backend/src/db/connection.py ./src

COPY --chown=airflow:root ./airflow/dags ./dags
COPY --chown=airflow:root ./airflow/config ./config

# 3. Create an empty logs directory with correct permissions
RUN mkdir -p ./logs && chown -R airflow:root ./logs

RUN curl -o global-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem 
