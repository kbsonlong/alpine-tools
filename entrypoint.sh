#!/bin/sh
set -e

# 显示欢迎信息
print_welcome() {
    echo "========================================="
    echo " Alpine DevOps Tools Container"
    echo "包含了以下工具类别："
    echo " 1. 网络诊断工具"
    echo " 2. 系统调试工具"
    echo " 3. 文件处理工具"
    echo " 4. 监控分析工具"
    echo " 5. 安全相关工具"
    echo " 6. 云原生支持工具"
    echo "========================================="
}

# 检查并显示工具版本
check_tools() {
    echo "\n系统工具版本信息："
    
    if command -v curl >/dev/null 2>&1; then
        echo "- curl: $(curl --version | head -n 1)"
    fi
    
    if command -v wget >/dev/null 2>&1; then
        echo "- wget: $(wget --version | head -n 1)"
    fi
    
    if command -v tcpdump >/dev/null 2>&1; then
        echo "- tcpdump: $(tcpdump --version)"
    fi
    
    if command -v nmap >/dev/null 2>&1; then
        echo "- nmap: $(nmap --version | head -n 1)"
    fi
    
    if command -v kubectl >/dev/null 2>&1; then
        echo "- kubectl: $(kubectl version --client=true 2>/dev/null | grep 'GitVersion' | awk '{print $2}')"
    fi
    
    if command -v helm >/dev/null 2>&1; then
        echo "- helm: $(helm version --short 2>/dev/null | grep 'semver' | cut -d'"' -f2)"
    fi
    
    if command -v etcdctl >/dev/null 2>&1; then
        echo "- etcdctl: $(etcdctl --version 2>/dev/null | head -n 1 | cut -d' ' -f1-3)"
    fi
    
    if command -v gpg >/dev/null 2>&1; then
        echo "- gpg: $(gpg --version | head -n 1)"
    fi
    
    echo ""
}

# 初始化syslog服务
start_syslog() {
    echo "启动syslog服务..."
    syslog-ng --no-daemon &
}

# 启动node exporter（用于监控）
start_node_exporter() {
    if command -v node_exporter >/dev/null 2>&1; then
        echo "启动node exporter..."
        node_exporter &
    fi
}

# 设置安全环境
setup_security() {
    echo "配置安全环境..."
    
    # 锁定root账户
    passwd -l root
    
    # 设置umask
    umask 027
    
    # 创建工作目录
    mkdir -p /workspace
    chown -R $NON_ROOT_USER:$NON_ROOT_USER /workspace
    
    # 设置环境变量
    export PATH=/usr/local/bin:$PATH
    export TERM=xterm
}

# 主函数
main() {
    print_welcome
    check_tools
    setup_security
    start_syslog
    start_node_exporter
    
    echo "执行主命令: "
    if [ "$#" -gt 0 ]; then
        exec "$@"
    else
        exec sh
    fi
}

main "$@"