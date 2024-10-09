# 初始化 Flask 应用，配置数据库、Celery 和其他依赖
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from config import Config
from .tasks import make_celery

# 注册数据库连接（SQLAlchemy）和路由
db = SQLAlchemy()

# 负责创建 Flask 应用并返回 Celery 实例
from flask import Flask
from .tasks import make_celery

def create_app():
    app = Flask(__name__)

    # 配置 RabbitMQ 和 Redis
    app.config.update(
        CELERY_BROKER_URL='amqp://localhost//',  # RabbitMQ 连接
        CELERY_RESULT_BACKEND='redis://localhost:6379/0'  # Redis 作为结果存储
    )

    celery = make_celery(app)

    @app.route('/longtask')
    def longtask():
        # 启动异步任务
        task = celery.send_task('app.tasks.long_running_task', args=[])
        return f'Task {task.id} started!'

    return app
