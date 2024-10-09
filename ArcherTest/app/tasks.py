# Celery 任务定义
from celery import Celery
import time

from ArcherTest.celery_worker import celery

from celery import Celery

# 创建 Celery 实例并配置 RabbitMQ 作为消息代理
def make_celery(app):
    celery = Celery(
        app.import_name,
        backend=app.config['CELERY_RESULT_BACKEND'],
        broker=app.config['CELERY_BROKER_URL']
    )
    celery.conf.update(app.config)
    return celery


# 简单的异步任务 long_task，等待 5 秒（模拟长时间任务），并返回任务完成的消息
@celery.task(name='app.tasks.long_running_task')
def long_running_task():
    import time
    # 模拟一个耗时的任务
    time.sleep(10)
    return 'Task completed!'
