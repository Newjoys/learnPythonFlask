FROM python:3.9-slim

WORKDIR /app

COPY . /app

# RUN pip install -r requirements.txt 在安装 Python 包时使用缓存
COPY requirements.txt ./
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple/ -r requirements.txt
#RUN pip install --no-cache-dir -r requirements.txt


CMD ["gunicorn", "--bind", "0.0.0.0:8000", "wsgi:app", "--worker-class", "gevent", "--workers", "4"]
#当 Docker 容器启动时，Gunicorn 会在所有可用的网络接口上监听 8000 端口，运行名为 app 的 Flask 应用，使用 gevent 作为工作进程类，并启动 4 个工作进程。这种配置适合处理并发请求，适合用于生产环境。
