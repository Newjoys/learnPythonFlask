# 配置 Gunicorn 使用的 WSGI 入口文件
from app import create_app

app = create_app()

if __name__ == "__main__":
    app.run()
