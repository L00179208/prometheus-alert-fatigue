import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    # Load the appropriate configuration based on FLASK_ENV
    env = os.getenv('FLASK_ENV', 'dev')
    if env == 'prod':
        app.config.from_object('config.prod.Config')
    elif env == 'staging':
        app.config.from_object('config.staging.Config')
    elif env == 'qa':
        app.config.from_object('config.qa.Config')
    else:
        app.config.from_object('config.dev.Config')

    db.init_app(app)

    # Import and register the blueprint
    from .routes import main_blueprint
    app.register_blueprint(main_blueprint)

    print(app.url_map)  # Debugging output

    return app
