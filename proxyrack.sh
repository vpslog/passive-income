#!/bin/bash

# 参数解析
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --proxyrack) API_KEY="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$API_KEY" ]; then
    echo "Error: --proxyrack 参数缺失！"
    exit 1
fi

echo "开始配置 proxyrack"

# 1. 生成 Device ID
DEVICE_ID=$(cat /dev/urandom | LC_ALL=C tr -dc 'A-F0-9' | dd bs=1 count=64 2>/dev/null && echo)
echo "生成的 Device ID: $DEVICE_ID"

# 3. 运行 Proxyrack 容器
echo "启动 Proxyrack 容器..."
sudo docker run -d --name proxyrack --restart always -e UUID="$DEVICE_ID" proxyrack/pop
if [ $? -ne 0 ]; then
    echo "启动 Proxyrack 容器失败！"
    exit 1
fi
echo "Proxyrack 容器已启动。"

# 获取主机名作为设备名称
DEVICE_NAME=$(hostname)
echo "设备名称: $DEVICE_NAME"

# 4. 动态生成 add_proxycrack.sh
ADD_SCRIPT="add_proxycrack.sh"
cat > $ADD_SCRIPT <<EOF
#!/bin/bash

# 参数定义
API_KEY="$API_KEY"
DEVICE_ID="$DEVICE_ID"
DEVICE_NAME="$DEVICE_NAME"

# 发起请求
RESPONSE=\$(curl -s -X POST https://peer.proxyrack.com/api/device/add \\
    -H "Api-Key: \$API_KEY" \\
    -H "Content-Type: application/json" \\
    -H "Accept: application/json" \\
    -d "{\\"device_id\\":\\"\$DEVICE_ID\\",\\"device_name\\":\\"\$DEVICE_NAME\\"}")

# 检查响应状态
STATUS=\$(echo "\$RESPONSE" | jq -r '.status')

if [ "\$STATUS" == "success" ]; then
    echo "设备已成功添加到 Peer 帐户。"
    echo "自销毁脚本..."
    rm -- "\$0"
else
    echo "添加设备失败：\$RESPONSE"
    echo "保持脚本文件以便重试。"
fi
EOF

# 赋予执行权限
chmod +x $ADD_SCRIPT
echo "生成 $ADD_SCRIPT 完成！请五分钟后使用 ./$ADD_SCRIPT 执行脚本完成添加"
