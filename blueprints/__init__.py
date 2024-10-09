from flask import Blueprint

# 创建蓝图对象
my_blueprint = Blueprint('my_blueprint', __name__)

# 定义路由和视图函数
@my_blueprint.route('/hello/<name>')
def hello(name):
    return f'Hello, {name}!'
