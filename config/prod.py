# config/prod.py

import os
from dotenv import load_dotenv

class ProdConfig:
    load_dotenv('.env.prod')  # Load environment variables from .env.prod

    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = os.getenv('SECRET_KEY', 'rR1eeaHsiIEbPyebrPHjHKhLHExCxBzg')
    DEBUG = False
