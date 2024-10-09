# 配置文件，用于配置 Flask、MySQL、Celery、Redis 等
import os

class Config:
    SQLALCHEMY_DATABASE_URI = 'mysql://root:password@mysql:3306/flask_db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    CELERY_BROKER_URL = 'amqp://rabbitmq'
    CELERY_RESULT_BACKEND = 'redis://redis:6379/0'
