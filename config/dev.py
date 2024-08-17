# config/dev.py

import os
from dotenv import load_dotenv

class DevConfig:
    load_dotenv('.env.dev')  # Load environment variables from .env.dev

    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = os.getenv('SECRET_KEY', 'KyEe6kG5PYcDBZfzwlfTRrkAeRjs3HpE')
    DEBUG = True
