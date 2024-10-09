from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://root:Pass123**@localhost/todo'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
migrate = Migrate(app, db)


class User(db.Model):
    """
        类注释：
        用户模型，表示系统中的用户信息。

        属性:
            id (int): 用户的唯一标识符，主键。
            username (str): 用户名，必须是唯一且不能为空。
            posts (list[Post]): 该用户所发布的所有帖子。

        用法:
            user = User(username="John")
            db.session.add(user)
        """
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    posts = db.relationship('Post', backref='author', lazy=True)


# class Post(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     title = db.Column(db.String(100), nullable=False)
#     content = db.Column(db.Text, nullable=True)
#     user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
# 为Post模型添加一个created_at字段，以存储文章的创建时间。
# flask db migrate -m "Add created_at field to Post"
from datetime import datetime


class Post(db.Model):
    # 帖子模型（Post）
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    content = db.Column(db.Text, nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)  # 新增字段
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)  # 默认值为当前时间，更新时也为当前时间 二次新增字段


@app.route('/')
# 首页路由 /
def index():
    users = User.query.all()
    return render_template('index.html', users=users)


@app.route('/add_user', methods=['POST'])
def add_user():
    """
        函数注释：
        添加用户到数据库中。
        参数:
            username (str): 用户名，必须是唯一的。
        返回:
            重定向到index页面中
        异常:
            ValueError: 如果用户名为空或无效则抛出此异常。
        """
    username = request.form.get('username')
    if username:
        new_user = User(username=username)
        db.session.add(new_user)
        db.session.commit()
    else:
        raise ValueError('用户名不能为空')
    return redirect(url_for('index'))


@app.route('/add_post/<int:user_id>', methods=['POST'])
# 添加帖子路由
def add_post(user_id):
    title = request.form.get('title')
    content = request.form.get('content')
    created_at = request.form.get('created_at')
    updated_at = request.form.get('updated_at')
    print(f"Adding post with title: {title}, content: {content}, user_id: {user_id}")

    if title and content:
        new_post = Post(
            title=title, content=content, author=User.query.get(user_id),
            created_at=created_at, updated_at=updated_at
        )
        db.session.add(new_post)
        db.session.commit()
    return redirect(url_for('index'))


if __name__ == '__main__':
    with app.app_context():
        db.create_all()  # 创建表
    app.run(debug=True)
