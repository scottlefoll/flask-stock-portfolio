from flask import Flask, render_template
from flask_admin import Admin
from flask_sqlalchemy import SQLAlchemy
from logging.handlers import RotatingFileHandler
import logging
from flask.logging import default_handler
import os
from sqlalchemy import MetaData
from flask_migrate import Migrate
from flask_wtf.csrf import CSRFProtect
from flask_login import LoginManager
from flask_mail import Mail


# -------------
# Configuration
# -------------

# Create a naming convention for the database tables
convention = {
    "ix": 'ix_%(column_0_label)s',
    "uq": "uq_%(table_name)s_%(column_0_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s"
}
metadata = MetaData(naming_convention=convention)

# Create the instances of the Flask extensions in the global scope,
# but without any arguments passed in. These instances are not
# attached to the Flask application at this point.
database = SQLAlchemy(metadata=metadata)
db_migration = Migrate()
csrf_protection = CSRFProtect()
login = LoginManager()
login.login_view = "users.login"
mail = Mail()


# ----------------------------
# Application Factory Function
# ----------------------------

def create_app():
    # Create the Flask application
    app = Flask(__name__)

    # Configure the Flask application
    config_type = os.getenv('CONFIG_TYPE', default='config.DevelopmentConfig')
    app.config.from_object(config_type)
    # admin2 = Admin(app, name='My Admin Panel2', template_mode='bootstrap4')
    initialize_extensions(app)
    register_blueprints(app)
    configure_logging(app)
    register_app_callbacks(app)
    register_error_pages(app)

    ##############################################################################
    # This section is only necessary in production when a command-line interface #
    # is NOT available for running commands to initialize the database.          #
    ##############################################################################
    # import sqlalchemy as sa

    # Check if the database needs to be initialized
    # engine = sa.create_engine(app.config['SQLALCHEMY_DATABASE_URI'])
    # inspector = sa.inspect(engine)
    # if not inspector.has_table("users"):
    #     with app.app_context():
    #         db.drop_all()
    #         db.create_all()
    #         app.logger.info('Initialized the database!')
    # else:
    #     app.logger.info('Database already contains the users table.')

    return app


# ----------------
# Helper Functions
# ----------------

def initialize_extensions(app):
    # Since the application instance is now created, pass it to each Flask
    # extension instance to bind it to the Flask application instance (app)
    database.init_app(app)
    db_migration.init_app(app, database)
    csrf_protection.init_app(app)
    login.init_app(app)
    mail.init_app(app)

    # Flask-Login configuration
    from project.models import User

    @login.user_loader
    def load_user(user_id):
        query = database.select(User).where(User.id == int(user_id))
        return database.session.execute(query).scalar_one()


def register_blueprints(app):
    # Import the blueprints
    from project.stocks import stocks_blueprint
    from project.users import users_blueprint
    from project.admin import admin_blueprint
    from project.watchlist import watchlist_blueprint

    # Since the application instance is now created, register each Blueprint
    # with the Flask application instance (app)
    app.register_blueprint(stocks_blueprint)
    app.register_blueprint(users_blueprint, url_prefix='/users')
    app.register_blueprint(admin_blueprint, url_prefix='/admin')
    app.register_blueprint(watchlist_blueprint)


def configure_logging(app):
    # Logging Configuration
    if app.config['LOG_WITH_GUNICORN']:
        gunicorn_error_logger = logging.getLogger('gunicorn.error')
        app.logger.handlers.extend(gunicorn_error_logger.handlers)
        app.logger.setLevel(logging.DEBUG)
    else:
        file_handler = RotatingFileHandler('instance/flask-stock-portfolio.log',
                                           maxBytes=16384,
                                           backupCount=20)
        file_formatter = logging.Formatter('%(asctime)s %(levelname)s %(threadName)s-%(thread)d: %(message)s [in %(filename)s:%(lineno)d]')
        file_handler.setFormatter(file_formatter)
        file_handler.setLevel(logging.INFO)
        app.logger.addHandler(file_handler)

    # Remove the default logger configured by Flask
    app.logger.removeHandler(default_handler)

    app.logger.info('Starting the Flask Stock Portfolio App...')


def register_app_callbacks(app):
    """Register the request callback functions.

    These functions were provided to illustrate how request callbacks work,
    but they are commented out to avoid unnecessary logging messages.
    """
    # @app.before_request
    # def app_before_request():
    #     app.logger.info('Calling before_request() for the Flask application...')
    #
    # @app.after_request
    # def app_after_request(response):
    #     app.logger.info('Calling after_request() for the Flask application...')
    #     # print(response.headers)
    #     return response
    #
    # @app.teardown_request
    # def app_teardown_request(error=None):
    #     app.logger.info('Calling teardown_request() for the Flask application...')
    #
    # @app.teardown_appcontext
    # def app_teardown_appcontext(error=None):
    #     app.logger.info('Calling teardown_appcontext() for the Flask application...')
    pass


def register_error_pages(app):
    @app.errorhandler(404)
    def page_not_found(e):
        return render_template('404.html'), 404

    @app.errorhandler(405)
    def method_not_allowed(e):
        return render_template('405.html'), 405

    @app.errorhandler(403)
    def page_forbidden(e):
        return render_template('403.html'), 403
