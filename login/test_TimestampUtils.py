from utils.timestamp_utils import TimestampUtils
if __name__ == "__main__":
    utils = TimestampUtils()
    current_ts = utils.get_timestamp()
    print("当前时间戳:", current_ts)
    print("时间戳转换为字符串:", utils.timestamp_to_string(current_ts))
    print("字符串转换为时间戳:", utils.string_to_timestamp("2024-09-30 12:00:00"))
    print("添加时间:", utils.add_time(current_ts, days=1))
    print("校验时间戳:", utils.validate_timestamp(current_ts))

# 获取当前时间戳
current_ts = TimestampUtils.get_timestamp()
print("当前时间戳:", current_ts)

# 将时间戳转换为字符串
timestamp_str = TimestampUtils.timestamp_to_string(current_ts)
print("时间戳转换为字符串:", timestamp_str)

# 将字符串转换为时间戳
date_string = "2024-09-30 12:00:00"
converted_ts = TimestampUtils.string_to_timestamp(date_string)
print("字符串转换为时间戳:", converted_ts)

# 添加时间
new_ts = TimestampUtils.add_time(current_ts, days=1)
print("添加一天后的时间戳:", new_ts)

# 校验时间戳
is_valid = TimestampUtils.validate_timestamp(current_ts)
print("当前时间戳校验结果:", is_valid)

# 格式化显示时间戳
formatted_time = TimestampUtils.format_timestamp(current_ts)
print("格式化显示时间戳:", formatted_time)
