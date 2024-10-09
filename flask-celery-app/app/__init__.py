# 初始化 Flask 应用，配置数据库、Celery 和其他依赖
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from .config import Config

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)

    from .views import main_blueprint
    app.register_blueprint(main_blueprint)

    return app
