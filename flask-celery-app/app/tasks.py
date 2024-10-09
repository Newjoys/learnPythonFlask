from celery import Celery
from . import create_app

app = create_app()
celery = Celery(app.import_name, broker=app.config['CELERY_BROKER_URL'])
celery.conf.update(app.config)

@celery.task
def add_numbers(x, y):
    return x + y
