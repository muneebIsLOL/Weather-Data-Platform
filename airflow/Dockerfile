# Use the slim version of Python 3.14.4
FROM apache/airflow

# Set the environment variable for container seperately
ENV PYTHONPATH=/opt/airflow/

# Use the app as your workdir of the container
WORKDIR /opt/airflow/

# Copy the requiremnts folder into the container
COPY requirements/ requirements/

# Install Necessary python packages inside container
RUN pip install --upgrade pip && \
    pip install -r requirements/airflow.txt -r requirements/base.txt
