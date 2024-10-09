# 启动 Celery worker 的入口
from app import create_app
from app.tasks import celery

app = create_app()

if __name__ == '__main__':
    celery.start()
