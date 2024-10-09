from celery import Celery
import time

celery_app = Celery('tasks', broker='pyamqp://guest@localhost//', backend='redis://localhost:6379/0')

@celery_app.task
def long_task():
    time.sleep(10)  # 模拟耗时任务
    return "Task Completed!"
