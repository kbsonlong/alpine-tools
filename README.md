# Alpine DevOps Tools Container

这是一个基于Alpine Linux的轻量级运维排查故障基础镜像，包含丰富的网络诊断、系统调试、监控分析等工具，适用于云原生环境下的故障排查和系统维护。

## 镜像特性

- 基于Alpine Linux（3.x版本），体积小巧
- 包含全面的运维工具集，分为六大类：
  - 网络诊断工具：curl, wget, tcpdump, nmap 等
  - 系统调试工具：vim, strace, lsof, iotop 等
  - 文件处理工具：tar, gzip, zip/unzip 等
  - 监控分析工具：sysstat, dstat, node-exporter 等
  - 安全相关工具：openssl, gpg, sudo 等
  - 云原生支持工具：kubectl, helm, docker-cli 等
- 提供完整的入口脚本初始化功能
- 支持标准的Docker操作（构建、运行、测试）
- 包含详细的Makefile进行标准化管理

## 工具列表

### 网络诊断工具
- curl - 数据传输工具
- wget - 网络下载工具
- telnet - 网络连接测试
- traceroute - 路由跟踪
- iproute2 - 网络配置工具
- tcpdump - 网络抓包工具
- netcat - 网络读写工具
- dig/nslookup - DNS查询工具
- mtr - 综合网络诊断
- nmap - 网络扫描工具
- iperf3 - 网络性能测试

### 系统调试工具
- grep - 文本搜索
- vim - 文本编辑器
- procps - 进程管理（ps/top/free等）
- lsof - 打开文件查看
- strace - 系统调用跟踪
- ltrace - 动态库调用跟踪
- sysstat - 系统性能统计
- iotop - I/O监控
- dstat - 多维度系统监控

### 文件和压缩工具
- tar - 归档工具
- gzip/bzip2/xz - 压缩工具
- zip/unzip - ZIP压缩解压
- 7z - 7-Zip压缩工具

### 监控和日志工具
- syslog-ng - 日志服务
- logrotate - 日志轮转
- node-exporter - Prometheus监控指标暴露

### 安全相关工具
- gpg - 加密签名
- openssl - SSL/TLS工具
- sudo - 权限提升

### 云原生支持工具
- docker-cli - Docker客户端
- kubernetes-client - K8s客户端(kubectl)
- helm - Kubernetes包管理器
- etcdctl - Etcd操作工具

## 使用方法

### 构建镜像
```bash
make build
```

### 运行容器
```bash
make run
```

### 进入正在运行的容器
```bash
make shell
```

### 执行功能测试
```bash
make test
```

### 显示工具版本信息
```bash
make version
```

## 最佳实践

1. **作为调试边车容器**：在Kubernetes环境中，可以将此镜像作为sidecar容器与主应用一起部署，用于网络诊断和系统调试。

2. **故障排查**：当遇到网络问题或系统瓶颈时，可以快速启动该镜像，使用内置工具进行深入分析。

3. **日常维护**：作为系统管理员的常用工具箱，执行常规的系统检查和维护任务。

4. **CI/CD流水线**：在持续集成环境中，作为基础镜像执行构建、测试和部署任务。

5. **教育和培训**：作为学习Linux系统管理和网络诊断的实践环境。

## 自定义修改

如需根据特定需求定制镜像，请参考以下建议：

- **添加新工具**：在Dockerfile的RUN apk add命令中添加所需工具
- **移除不需要的工具**：优化镜像大小，移除不常用的工具
- **调整入口脚本**：根据需要修改entrypoint.sh的功能
- **安全加固**：根据CIS基准进行安全配置调整
- **多架构支持**：修改构建流程以支持ARM等其他架构

## 注意事项

- 本镜像中的某些工具（如tcpdump）需要特权模式才能完全发挥作用，在生产环境中使用时请注意权限控制。
- 为了保持镜像的通用性，未设置默认的CMD指令，可以根据需要在运行时指定命令。
- 建议定期更新基础镜像和安装的工具，保持最新的安全补丁。
- 在生产环境中使用时，应根据实际需求精简工具集，遵循最小化原则。