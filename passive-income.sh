#!/bin/bash

echo "服务器被动收入脚本 BY VPSLOG V2025.9.15"
echo "https://github.com/vpslog/passive-income"
echo "本脚本所运行所有容器均源自互联网"
echo "挂机有风险，请勿在重要的服务器上运行本脚本"

# 参数解析
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --earnfm) EARNFM_TOKEN="$2"; shift ;;
        --repocket_email) REPOCKET_EMAIL="$2"; shift ;;
        --repocket_key) REPOCKET_KEY="$2"; shift ;;
        --packetstream) PACKETSTREAM_CID="$2"; shift ;;
        --trafficmonetizer) TRAFFICMONETIZER_TOKEN="$2"; shift ;;
        --proxyrack) PROXYRACK_UUID="$2"; shift ;;
        --peer2profit) PEER2PROFIT_EMAIL="$2"; shift ;;
        --packetshare_email) PACKETSHARE_EMAIL="$2"; shift ;;
        --packetshare_pass) PACKETSHARE_PASS="$2"; shift ;;
        --proxybase_id) PROXYBASE_ID="$2"; shift ;;
        *) echo "未知参数: $1"; exit 1 ;;
    esac
    shift
done

# 检查 Docker 是否已安装
if ! command -v docker &> /dev/null; then
    echo "Docker 未安装，正在安装 Docker..."
    sudo curl -fsSL https://get.docker.com | bash -s docker
fi

# 安装依赖
if [[ -f /etc/debian_version ]]; then
    sudo apt update
    sudo apt install -y curl sudo jq
elif [[ -f /etc/redhat-release ]]; then
    sudo yum install -y curl sudo jq
elif [[ -f /etc/os-release ]]; then
    echo "未知操作系统，尚未适配"
    exit 1
fi

# 启动容器
echo "开始启动容器..."

# PacketStream
if [ -n "$PACKETSTREAM_CID" ]; then
    echo "准备启动 PacketStream 容器..."
    sudo docker run -d --restart=always -e CID="$PACKETSTREAM_CID" \
        --name passive-income-packetstream packetstream/psclient:latest
    echo "PacketStream 容器已启动！"
fi

# EarnFM
if [ -n "$EARNFM_TOKEN" ]; then
    echo "准备启动 EarnFM 容器..."
    sudo docker run -d --restart=always -e EARNFM_TOKEN="$EARNFM_TOKEN" \
        --name passive-income-earnfm earnfm/earnfm-client:latest
    echo "EarnFM 容器已启动！"
fi

# Repocket
if [ -n "$REPOCKET_EMAIL" ] && [ -n "$REPOCKET_KEY" ]; then
    echo "准备启动 Repocket 容器..."
    sudo docker run -d --restart=always \
        -e RP_EMAIL="$REPOCKET_EMAIL" -e RP_API_KEY="$REPOCKET_KEY" \
        --name passive-income-repocket repocket/repocket
    echo "Repocket 容器已启动！"
fi

# Traffmonetizer
if [ -n "$TRAFFICMONETIZER_TOKEN" ]; then
    echo "准备启动 Traffmonetizer 容器..."
    sudo docker run -d --name passive-income-traffmonetizer \
        traffmonetizer/cli_v2 start accept --token "$TRAFFICMONETIZER_TOKEN"
    echo "Traffmonetizer 容器已启动！"
fi

# Peer2Profit
if [ -n "$PEER2PROFIT_EMAIL" ]; then
    echo "准备启动 Peer2Profit 容器..."
    sudo docker run -d --restart=always \
        -e email="$PEER2PROFIT_EMAIL" -e use_proxy=false \
        --name passive-income-peer2profit enwaiax/peer2profit:latest
    echo "Peer2Profit 容器已启动！"
fi

# PacketShare
if [ -n "$PACKETSHARE_EMAIL" ] && [ -n "$PACKETSHARE_PASS" ]; then
    echo "准备启动 PacketShare 容器..."
    sudo docker run -d --restart=always \
        --name passive-income-packetshare \
        packetshare/packetshare -accept-tos -email="$PACKETSHARE_EMAIL" -password="$PACKETSHARE_PASS"
    echo "PacketShare 容器已启动！"
fi

# Proxybase
if [ -n "$PROXYBASE_ID" ]; then
    echo "准备启动 Proxybase 容器..."
    sudo docker run -d --restart=always \
        -e USER_ID="$PROXYBASE_ID" -e DEVICE_NAME="$(hostname)" \
        --name passive-income-proxybase proxybase/proxybase:latest
    echo "Proxybase 容器已启动！"
fi

# Proxyrack
if [ -n "$PROXYRACK_UUID" ]; then
    echo "准备运行 Proxyrack 脚本..."
    bash <(curl -s https://raw.githubusercontent.com/vpslog/passive-income/refs/heads/main/proxyrack.sh) --proxyrack "$PROXYRACK_UUID"
    echo "Proxyrack 脚本已运行！"
fi


echo "所有操作完成！"
