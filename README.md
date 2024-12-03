# 不要在运行重要服务的机器上运行挂机脚本。挂机可能导致服务器被封。

# passive-income 服务器被动收入

- 原理：共享服务器的IP地址给挂机平台，挂机平台将统一将IP地址出租给用户，用于运行爬虫等需要频繁切换不同IP/区域的程序。
- 限制条件：主要是对服务器的IP地址有限制，一般需要独立的IPv4地址，另外家庭宽带的收益比机房IP更高。部分挂机服务仅限家庭宽带。
- 风险提示：由于会将本机IP地址共享给客户用于运行程序，无法确保其中没有恶意程序。这里收集的几个平台经过测试风险较低。**但仍然建议提前了解商家 TOS，不要在运行重要服务的机器上运行挂机脚本。挂机可能导致服务器被封。** 目前挂了一年将近一百台机，就有一台被检测到问题。**不建议在大厂（国内阿里云等，国外 GCP 等）上运行。** 建议灵车商家搭配挂机脚本。
- 已知问题：挂机会提高IP的风险值。

## 使用说明

本项目收集了几个相对靠谱的挂机平台。这几个都是 VPS 可挂机、并且可以用 docker 一键运行的。按照下面说明，注册各平台，并获取密钥等，复制到 [https://passive-income.pages.dev/](https://passive-income.pages.dev/) 生成一键运行命令，在 VPS 上运行即可。

## 平台概述

这里放的都是带有 推荐系统（AFF） 的链接，一些平台走推荐链接注册可以赠送初始余额（一般是 5 美元），同时平台会对我也有一定奖励。这不影响您的收益。

### traffmonetizer

首先通过邀请链接注册：[点此注册](https://traffmonetizer.com/?aff=1574337)

可以使用域名邮箱或者任何你的常用邮箱注册。注册完成后，登录到控制面板，可以看到你的收益情况等。

左边找到 Your application token 栏，复制这个 Token 备用。

### packetstream

首先 [点此AFF访问官网](https://packetstream.io/?psr=5vZe) 注册

首页 Share PacketStream 栏，有个链接类似于`https://packetstream.io/?psr=5vZe`，复制最后四个代码（例如`5vZe`）备用。

### repocket

首先通过邀请链接注册：[点此注册](https://link.repocket.co/UY62)

repocket 的面板可以看到你当前在线的设备数、IP 地址以及相应的收益，还是很不错的。

转到 https://app.repocket.co/bandwidth-earnings 页面（也可以点击左侧的 Sell Internet），转到流量管理页面。复制这个 API Key 备用。

### earnfm

这个平台收益稍微少一点，对 IP 要求很高。

首先 [点此访问官网](https://earn.fm/ref/1361ES2B) 注册。

转到 More 页面，中间 Your API key 栏，复制这个 API Key 备用。

### peer2profit

这个只针对已有用户，提供邮箱即可。新用户应该不能注册了。

### proxyrack

这个项目还在测试，没有出金，可以通过 [官网链接注册](https://peer.proxyrack.com/register)，这个是没有 AFF 的，建议是不走 AFF。走 AFF 初始就有 5美元，但是需要 20 美元才能提现，如果不走 AFF 只要 5 美元就能提现，如果有信息挂满 20 美元，也可以走 [AFF链接](https://peer.proxyrack.com/ref/1musvbkykdydfjmpcyilrxtm092rv8smylu1gcts) （不建议）

注册后转到 https://peer.proxyrack.com/profile 获取 API Key 即可。注意这个挂机，在跑起来容器之后，还需要额外运行注册脚本（见脚本说明）
