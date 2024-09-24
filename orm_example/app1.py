from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
# 使用Flask-Migrate，您可以轻松管理数据库模式的变化。
# Flask-Migrate利用Alembic进行数据库迁移，允许您在不丢失数据的情况下更新数据库结构。
app1 = Flask(__name__)
app1.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://root:Pass123**@localhost/todo'
app1.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app1)
migrate = Migrate(app1, db)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    posts = db.relationship('Post', backref='author', lazy=True)

class Post(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    content = db.Column(db.Text, nullable=True)  # 新增字段
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

with app1.app_context():
    db.create_all()  # 创建表

    # 添加用户和他们的文章
    user = User(username='example_user')
    db.session.add(user)
    db.session.commit()

    post1 = Post(title='First Post', content='This is the first post.', author=user)
    post2 = Post(title='Second Post', content='This is the second post.', author=user)
    db.session.add(post1)
    db.session.add(post2)
    db.session.commit()

    # 查询用户及其文章
    user_with_posts = User.query.filter_by(username='example_user').first()
    print(user_with_posts.posts)  # 打印用户的所有文章