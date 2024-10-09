详细目录和文件说明
app/__init__.py: 初始化 Flask 应用，配置数据库、Celery 和其他依赖。
app/models.py: 定义 SQLAlchemy ORM 模型。
app/routes.py: Flask 路由处理，定义 API 接口。
app/tasks.py: Celery 任务定义。
celery_worker.py: 启动 Celery worker 的入口。
config.py: 配置文件，用于配置 Flask、MySQL、Celery、Redis 等。
requirements.txt: Python 包依赖列表。
wsgi.py: 配置 Gunicorn 使用的 WSGI 入口文件。
run.sh: 启动脚本。
Dockerfile: Docker 容器配置文件。
docker-compose.yml: Docker Compose 文件，用于构建和启动 MySQL、Redis、RabbitMQ 等服务。
nginx/nginx.conf: Nginx 配置文件。

Redis 和 RabbitMQ 的安装和配置都在 docker-compose.yml 文件中完成，你无需在主机上手动安装它们。
Celery Worker 也是通过 docker-compose.yml 中定义的指令自动启动的
Docker 和 Nginx 需要预先安装

安装完成后，你就可以运行项目。具体步骤：
确保 Docker 服务已启动。
在项目目录下执行启动脚本：
chmod +x run.sh
./run.sh
该脚本会使用 Docker Compose 构建并启动 Flask 应用、MySQL、Redis、RabbitMQ、Celery worker 和 Nginx 服务。

测试 Nginx 配置
在浏览器中访问 http://localhost 或者使用 curl 来检查 Nginx 是否反向代理到 Flask 应用。

使用以下命令查看所有 Docker 容器的运行状态：
docker ps

可以通过以下命令查看 Celery Worker 的日志，确保它正确处理任务：
docker-compose logs celery

验证 MySQL 数据库
启动容器后，可以通过以下方式验证是否成功创建数据库：

进入 MySQL 容器：
docker exec -it <mysql_container_name> mysql -u root -p
# <mysql_container_name>是docker ps中看到的别名
登录后，查看数据库列表：
SHOW DATABASES;
你应该会看到 mydb 在数据库列表中。

构建镜像: 如果对 Dockerfile 或 docker-compose.yml 文件进行了更改，请重新构建镜像：
docker-compose build
重启服务:
docker-compose up