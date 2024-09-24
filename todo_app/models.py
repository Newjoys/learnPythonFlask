from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()
# 使用类定义数据库表，Flask-SQLAlchemy提供了db.Model基类，允许你轻松定义模型属性。
class Todo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.String(200), nullable=False)

    def __repr__(self):
        return f'<Todo {self.content}>'
