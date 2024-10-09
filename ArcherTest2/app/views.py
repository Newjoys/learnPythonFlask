from flask import Blueprint, jsonify, request
from .models import User, db
from .tasks import long_task

main = Blueprint('main', __name__)

@main.route('/')
def index():
    return jsonify(message="Welcome to the Flask App")

@main.route('/add_user', methods=['POST'])
def add_user():
    data = request.get_json()
    new_user = User(username=data['username'], email=data['email'])
    db.session.add(new_user)
    db.session.commit()
    return jsonify(message="User added")

@main.route('/start_task', methods=['POST'])
def start_task():
    task = long_task.apply_async()
    return jsonify(task_id=task.id)
