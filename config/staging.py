import os
from dotenv import load_dotenv

class Config:
    # Load environment variables from the corresponding .env file
    FLASK_ENV = os.getenv('FLASK_ENV', 'dev')
    env_file = f".env.{FLASK_ENV}"
    load_dotenv(env_file)
    
    # Now, use the loaded environment variables
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = os.getenv('SECRET_KEY', 'defaultsecretkey')
    DEBUG = FLASK_ENV == 'dev'
