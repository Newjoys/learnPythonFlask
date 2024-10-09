from flask import Blueprint, jsonify, request
from .tasks import add_numbers

main_blueprint = Blueprint('main', __name__)

@main_blueprint.route('/add', methods=['POST'])
def add():
    data = request.json
    task = add_numbers.apply_async(args=[data['x'], data['y']])
    return jsonify({'task_id': task.id}), 202
