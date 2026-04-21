import os

class Config:
    # Database
    DB_HOST     = os.environ.get('DB_HOST', 'localhost').spilt(':')[0]
    DB_NAME     = os.environ.get('DB_NAME', 'portfolio')
    DB_USER     = os.environ.get('DB_USER', 'postgres')
    DB_PASSWORD = os.environ.get('DB_PASSWORD', 'postgres')
    DB_PORT     = os.environ.get('DB_PORT', '5432')

    SQLALCHEMY_DATABASE_URI = (
        f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    # Flask
    SECRET_KEY  = os.environ.get('SECRET_KEY', 'dev-secret-key')
    FLASK_ENV   = os.environ.get('FLASK_ENV', 'development')