# 启动 Celery worker 的入口
from app import create_app

app, celery = create_app()

if __name__ == '__main__':
    celery.start()
