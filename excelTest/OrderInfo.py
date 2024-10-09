from flask import Flask, render_template, send_file
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import func
import pandas as pd
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
from io import BytesIO
import os
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://username:password@localhost/your_database'
db = SQLAlchemy(app)


class OrderInfo(db.Model):
    __tablename__ = 'order_info'
    order_id = db.Column(db.Integer, primary_key=True)
    customer_id = db.Column(db.Integer, nullable=False)
    status = db.Column(db.Enum('pending', 'shipped', 'cancelled'), default='pending')
    created_at = db.Column(db.TIMESTAMP, default=func.now())
    updated_at = db.Column(db.TIMESTAMP, default=func.now(), onupdate=func.now())


class OrderItem(db.Model):
    __tablename__ = 'order_item'
    item_id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey('order_info.order_id', ondelete='CASCADE'))
    product_name = db.Column(db.String(255), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    price = db.Column(db.DECIMAL(10, 2), nullable=False)


class PurchaseOrder(db.Model):
    __tablename__ = 'purchase_order'
    purchase_order_id = db.Column(db.Integer, primary_key=True)
    supplier_name = db.Column(db.String(255), nullable=False)
    total_amount = db.Column(db.DECIMAL(10, 2), nullable=False)
    status = db.Column(db.Enum('pending', 'approved', 'rejected'), default='pending')
    created_at = db.Column(db.TIMESTAMP, default=func.now())
    updated_at = db.Column(db.TIMESTAMP, default=func.now(), onupdate=func.now())


class PurchaseOrderItem(db.Model):
    __tablename__ = 'purchase_order_item'
    item_id = db.Column(db.Integer, primary_key=True)
    purchase_order_id = db.Column(db.Integer, db.ForeignKey('purchase_order.purchase_order_id', ondelete='CASCADE'))
    product_id = db.Column(db.Integer)
    quantity = db.Column(db.Integer, nullable=False)
    price = db.Column(db.DECIMAL(10, 2), nullable=False)


# 财务汇总数据查询并生成Excel报表
def generate_financial_report():
    # 计算订单收入
    income = db.session.query(func.sum(OrderItem.quantity * OrderItem.price)).scalar() or 0
    # 计算采购支出
    expenses = db.session.query(func.sum(PurchaseOrderItem.quantity * PurchaseOrderItem.price)).scalar() or 0
    # 计算利润
    profit = income - expenses

    # 创建报表数据
    report_data = {
        'Income': [income],
        'Expenses': [expenses],
        'Profit': [profit]
    }

    df = pd.DataFrame(report_data)

    # 保存为Excel文件
    excel_file = BytesIO()
    with pd.ExcelWriter(excel_file, engine='xlsxwriter') as writer:
        df.to_excel(writer, sheet_name='Financial Report', index=False)
    excel_file.seek(0)

    return excel_file


# 导出Excel文件
@app.route('/download_report')
def download_report():
    excel_file = generate_financial_report()
    return send_file(excel_file, attachment_filename='financial_report.xlsx', as_attachment=True)


# 发送邮件
def send_report_via_email(email_address):
    excel_file = generate_financial_report()

    # 设置邮件信息
    msg = MIMEMultipart()
    msg['From'] = 'your_email@example.com'
    msg['To'] = email_address
    msg['Subject'] = 'Daily Financial Report'

    # 添加附件
    attachment = MIMEBase('application', 'octet-stream')
    attachment.set_payload(excel_file.getvalue())
    encoders.encode_base64(attachment)
    attachment.add_header('Content-Disposition', 'attachment', filename='financial_report.xlsx')
    msg.attach(attachment)

    # 使用SMTP发送邮件
    server = smtplib.SMTP('smtp.example.com', 587)
    server.starttls()
    server.login('your_email@example.com', 'your_password')
    server.sendmail('your_email@example.com', email_address, msg.as_string())
    server.quit()


# 定时任务调度
from apscheduler.schedulers.background import BackgroundScheduler


def scheduled_report():
    send_report_via_email('admin@example.com')


scheduler = BackgroundScheduler()
scheduler.add_job(scheduled_report, 'cron', hour=12)
scheduler.start()

if __name__ == '__main__':
    app.run(debug=True)
