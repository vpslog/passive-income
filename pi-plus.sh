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

# 启动容器通用函数
start_container() {
    local name="$1"
    local image="$2"
    shift 2
    if sudo docker ps -a --format '{{.Names}}' | grep -q "^${name}$"; then
        echo "容器 ${name} 已存在，跳过..."
    elif sudo docker ps -a --format '{{.Image}}' | grep -q "^${image}$"; then
        echo "已有基于镜像 ${image} 的容器存在，跳过..."
    else
        echo "启动容器 ${name}..."
        sudo docker run -d --restart=always --name "$name" "$image" "$@"
        echo "容器 ${name} 已启动！"
    fi
}

# 开始启动容器
echo "开始启动容器..."

# PacketStream
if [ -n "$PACKETSTREAM_CID" ]; then
    start_container "passive-income-packetstream" "packetstream/psclient:latest" \
        -e CID="$PACKETSTREAM_CID"
fi

# EarnFM
if [ -n "$EARNFM_TOKEN" ]; then
    start_container "passive-income-earnfm" "earnfm/earnfm-client:latest" \
        -e EARNFM_TOKEN="$EARNFM_TOKEN"
fi

# Repocket
if [ -n "$REPOCKET_EMAIL" ] && [ -n "$REPOCKET_KEY" ]; then
    start_container "passive-income-repocket" "repocket/repocket" \
        -e RP_EMAIL="$REPOCKET_EMAIL" -e RP_API_KEY="$REPOCKET_KEY"
fi

# Traffmonetizer
if [ -n "$TRAFFICMONETIZER_TOKEN" ]; then
    if sudo docker ps -a --format '{{.Names}}' | grep -q "^passive-income-traffmonetizer$"; then
        echo "容器 passive-income-traffmonetizer 已存在，跳过..."
    elif sudo docker ps -a --format '{{.Image}}' | grep -q "^traffmonetizer/cli_v2$"; then
        echo "已有基于镜像 traffmonetizer/cli_v2 的容器存在，跳过..."
    else
        echo "启动容器 passive-income-traffmonetizer..."
        sudo docker run -d --name passive-income-traffmonetizer \
            traffmonetizer/cli_v2 start accept --token "$TRAFFICMONETIZER_TOKEN"
        echo "容器 passive-income-traffmonetizer 已启动！"
    fi
fi

# Peer2Profit
if [ -n "$PEER2PROFIT_EMAIL" ]; then
    start_container "passive-income-peer2profit" "enwaiax/peer2profit:latest" \
        -e email="$PEER2PROFIT_EMAIL" -e use_proxy=false
fi

# PacketShare
if [ -n "$PACKETSHARE_EMAIL" ] && [ -n "$PACKETSHARE_PASS" ]; then
    start_container "passive-income-packetshare" "packetshare/packetshare" \
        -accept-tos -email="$PACKETSHARE_EMAIL" -password="$PACKETSHARE_PASS"
fi

# Proxybase
if [ -n "$PROXYBASE_ID" ]; then
    start_container "passive-income-proxybase" "proxybase/proxybase:latest" \
        -e USER_ID="$PROXYBASE_ID" -e DEVICE_NAME="$(hostname)"
fi

# Proxyrack（特殊：用脚本）
if [ -n "$PROXYRACK_UUID" ]; then
    if pgrep -f "proxyrack" > /dev/null; then
        echo "Proxyrack 已在运行，跳过..."
    else
        echo "准备运行 Proxyrack 脚本..."
        bash <(curl -s https://raw.githubusercontent.com/vpslog/passive-income/refs/heads/main/proxyrack.sh) --proxyrack "$PROXYRACK_UUID"
        echo "Proxyrack 脚本已运行！"
    fi
fi

echo "所有操作完成！"
