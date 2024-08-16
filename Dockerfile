# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the wait-for-it script into the container
COPY wait-for-it.sh /app/wait-for-it.sh

# Ensure the script is executable
RUN chmod +x /app/wait-for-it.sh

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable for Flask app
ENV FLASK_APP=run.py

# Define default environment variables (can be overridden)
ARG DATABASE_URL
ENV DATABASE_URL=${DATABASE_URL}

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
