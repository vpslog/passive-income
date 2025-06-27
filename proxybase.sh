#!/bin/bash

# 容器名称
CONTAINER_NAME="passive-income-proxybase"

# 拉起容器
docker run -d --restart=always --name "$CONTAINER_NAME" proxybase/proxybase

# 等待容器运行并产生日志
sleep 10

# 获取 Device ID 所在的日志行
device_line=$(docker logs "$CONTAINER_NAME" 2>&1 | grep "Device ID:")

# 输出结果
echo "$device_line"

