from flask import Flask, render_template, request, redirect
from models import db, Todo

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://root:Pass123**@localhost/todo'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

with app.app_context():
    db.create_all()  # 创建数据库表

@app.route('/')
def index():
    todos = Todo.query.all()
    return render_template('index.html', todos=todos)

@app.route('/add', methods=['POST'])
def add_todo():
    todo_content = request.form.get('todo')
    if todo_content:
        new_todo = Todo(content=todo_content)
        db.session.add(new_todo)
        db.session.commit()
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)
