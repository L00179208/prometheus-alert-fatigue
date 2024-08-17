from flask import Flask
from .extensions import db, migrate, login_manager
from .models import User  # Import models after initializing db to avoid circular imports

def create_app():
    app = Flask(__name__)
    app.config.from_object('config.dev.Config')

    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)
    login_manager.login_view = 'main.login'

    @login_manager.user_loader
    def load_user(user_id):
        return User.query.get(int(user_id))

    from .routes import main_blueprint
    app.register_blueprint(main_blueprint)

    return app


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))
