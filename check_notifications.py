from db_manager import db_manager

print("=== 通知渠道配置 ===")
channels = db_manager.get_notification_channels()
print(f"通知渠道数量: {len(channels)}")
for channel in channels:
    print(f"ID: {channel['id']}")
    print(f"名称: {channel['name']}")
    print(f"类型: {channel['type']}")
    print(f"启用: {channel['enabled']}")
    if channel['type'] == 'feishu':
        print(f"飞书Webhook: {channel['config']}")
    elif channel['type'] == 'qq':
        print(f"QQ号码: {channel['config']}")
    print("-" * 40)

print("\n=== 消息通知配置 ===")
notifications = db_manager.get_all_message_notifications()
print(f"配置账号数量: {len(notifications)}")
for cookie_id, notifs in notifications.items():
    print(f"账号: {cookie_id}")
    for notif in notifs:
        print(f"  - 渠道: {notif['channel_name']} ({notif['channel_type']})")
        print(f"    启用: {notif['enabled']}")
        if notif['channel_type'] == 'qq':
            print(f"    QQ号码: {notif['channel_config']}")
        elif notif['channel_type'] == 'feishu':
            print(f"    飞书Webhook: {notif['channel_config'][:50]}...")
    print("-" * 40)
