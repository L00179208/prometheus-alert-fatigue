# Use the official Python image.
FROM python:3.9-slim

# Set the working directory.
WORKDIR /app

# Install dependencies.
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy the project files.
COPY . .

# Set environment variables.
ENV FLASK_APP run.py

# Expose the application port.
EXPOSE 5000

# Command to run the application.
CMD ["flask", "run", "--host=0.0.0.0"]