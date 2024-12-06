#!/bin/bash

# # 检查输入参数
# if [ $# -lt 3 ]; then
#   echo "Usage: $0 <API_KEY> <NEW_PASSWORD> <BENEFICIARY>"
#   exit 1
# fi

# API_KEY=$1
# NEW_PASSWORD=$2
# BENEFICIARY=$3

echo "install myst"
docker run --log-opt max-size=10m --cap-add NET_ADMIN -d -p 4449:4449 --name passive-income-myst -v myst-data:/var/lib/mysterium-node --restart unless-stopped mysteriumnetwork/myst:latest service --agreed-terms-and-conditions
sudo docker run -d --restart=always --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup --include-stopped --include-restarting --revive-stopped --interval 60 passive-income-myst

ipv4=$(curl -4 ip.sb)
echo "go to http://${ipv4}:4449 to complete setup"
 
# # Step 1: 获取 Token
# TOKEN_RESPONSE=$(curl -s -X POST 'http://localhost:4449/tequilapi/auth/login' \
#   -H 'Content-Type: application/json' \
#   --data-raw '{"username":"myst","password":"mystberry"}' \
#   --insecure)
# TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.token')

# if [ -z "$TOKEN" ]; then
#   echo "Failed to retrieve token."
#   exit 1
# fi

# echo "Token: $TOKEN"

# # Step 2: 获取当前身份 ID
# IDENTITY_RESPONSE=$(curl -s -X PUT 'http://localhost:4449/tequilapi/identities/current' \
#   -H "Cookie: token=$TOKEN" \
#   --data-raw '{"passphrase":""}' \
#   --insecure)
# IDENTITY_ID=$(echo $IDENTITY_RESPONSE | jq -r '.id')

# if [ -z "$IDENTITY_ID" ]; then
#   echo "Failed to retrieve identity ID."
#   exit 1
# fi

# echo "Identity ID: $IDENTITY_ID"

# # Step 3: 同意服务条款
# curl -s -X POST 'http://localhost:4449/tequilapi/terms' \
#   -H "Cookie: token=$TOKEN" \
#   --data-raw '{"agreed_provider":true,"agreed_version":"0.0.53"}' \
#   --insecure
# echo "Terms accepted."

# # Step 4: 配置 API Key
# curl -s -X POST 'http://localhost:4449/tequilapi/mmn/api-key' \
#   -H "Cookie: token=$TOKEN" \
#   --data-raw "{\"api_key\":\"$API_KEY\"}" \
#   --insecure
# echo "API Key configured."

# # Step 5: 修改密码
# curl -s -X PUT 'http://localhost:4449/tequilapi/auth/password' \
#   -H "Cookie: token=$TOKEN" \
#   --data-raw "{\"username\":\"myst\",\"old_password\":\"mystberry\",\"new_password\":\"$NEW_PASSWORD\"}" \
#   --insecure
# echo "Password updated."

# # Step 6: 注册节点身份
# curl -s -X POST "http://localhost:4449/tequilapi/identities/$IDENTITY_ID/register" \
#   -H "Cookie: token=$TOKEN" \
#   --data-raw "{\"beneficiary\":\"$BENEFICIARY\",\"stake\":0}" \
#   --insecure
# echo "Identity registered."
