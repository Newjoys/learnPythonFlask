FROM python:3.9-slim

# 设置工作目录
WORKDIR /app

# 安装必要的系统依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev

# 复制项目文件到容器
COPY . .

# 安装 Python 依赖
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple/ -r requirements.txt

# 设置 Gunicorn 启动命令
CMD ["gunicorn", "-c", "gunicorn_config.py", "wsgi:app"]
