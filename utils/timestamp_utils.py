import time
from datetime import datetime, timedelta, timezone

class TimestampUtils:
    @staticmethod
    def get_timestamp(precision='s'):
        """获取当前时间戳，精度可选 's', 'ms', 'us'."""
        if precision == 's':
            return int(time.time())
        elif precision == 'ms':
            return int(time.time() * 1000)
        elif precision == 'us':
            return int(time.time() * 1_000_000)
        else:
            raise ValueError("Unsupported precision")

    @staticmethod
    def timestamp_to_string(timestamp, fmt="%Y-%m-%d %H:%M:%S"):
        """时间戳转字符串."""
        return datetime.fromtimestamp(timestamp).strftime(fmt)

    @staticmethod
    def string_to_timestamp(date_string, fmt="%Y-%m-%d %H:%M:%S"):
        """字符串转时间戳."""
        return int(datetime.strptime(date_string, fmt).timestamp())

    @staticmethod
    def add_time(timestamp, days=0, hours=0, minutes=0, seconds=0):
        """对时间戳进行运算."""
        return timestamp + timedelta(days=days, hours=hours, minutes=minutes, seconds=seconds).total_seconds()

    @staticmethod
    def validate_timestamp(timestamp, threshold_days=30):
        """校验时间戳."""
        if timestamp < 0:
            return False
        current_time = time.time()
        return timestamp <= current_time and timestamp >= (current_time - threshold_days * 86400)

    @staticmethod
    def convert_timezone(timestamp, from_tz, to_tz):
        """跨时区处理."""
        dt = datetime.fromtimestamp(timestamp, tz=timezone.utc).astimezone(from_tz)
        return dt.astimezone(to_tz).timestamp()

    @staticmethod
    def format_timestamp(timestamp, fmt="%Y-%m-%d %H:%M:%S"):
        """格式化显示时间戳."""
        return datetime.fromtimestamp(timestamp).strftime(fmt)

# 示例使用
if __name__ == "__main__":
    utils = TimestampUtils()
    current_ts = utils.get_timestamp()
    print("当前时间戳:", current_ts)
    print("时间戳转换为字符串:", utils.timestamp_to_string(current_ts))
    print("字符串转换为时间戳:", utils.string_to_timestamp("2024-09-30 12:00:00"))
    print("添加时间:", utils.add_time(current_ts, days=1))
    print("校验时间戳:", utils.validate_timestamp(current_ts))
