# 配置文件，用于配置 Flask、MySQL、Celery、Redis 等
import os

class Config:
    # Flask应用的SECRET_KEY用于安全管理
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'hard-to-guess-string'
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://user:password@localhost/mydb'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    # Celery: 定义了Redis作为消息代理和任务结果存储后端
    CELERY_BROKER_URL = 'redis://localhost:6379/0'
    CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'
