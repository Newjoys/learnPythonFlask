# Flask 路由处理，定义 API 接口
from flask import Blueprint, jsonify
from .models import User
from .tasks import long_task

bp = Blueprint('main', __name__)

@bp.route('/users', methods=['GET'])
def get_users():
    users = User.query.all()
    return jsonify([{'id': u.id, 'username': u.username} for u in users])

@bp.route('/long_task', methods=['POST'])
def start_long_task():
    # 触发一个异步任务（通过Celery），并立即返回任务ID，客户端可以根据这个 ID查询任务的状态
    task = long_task.apply_async()
    return jsonify({'task_id': task.id}), 202
