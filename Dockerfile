# Dockerfile

# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Define the build-time variable for the environment
ARG ENVIRONMENT=dev

# Set it as an environment variable
ENV ENVIRONMENT=$ENVIRONMENT

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy wait-for-it script into the container
COPY wait-for-it.sh /app/wait-for-it.sh
RUN chmod +x /app/wait-for-it.sh

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Set the Flask configuration environment
ENV FLASK_ENV=${ENVIRONMENT}

# Define the environment variable for Flask
ENV FLASK_APP=run.py

# Ensure the correct config file is used
CMD if [ -f "config/${ENVIRONMENT}.py" ]; then cp "config/${ENVIRONMENT}.py" "prod.py"; fi && flask run --host=0.0.0.0
