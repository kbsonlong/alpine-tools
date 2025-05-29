FROM alpine:latest

# 设置构建参数
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG TOOL_VERSION
ARG SECURITY_HARDENING
ARG DROP_ROOT
ARG NON_ROOT_USER
ARG NON_ROOT_UID

# 添加元数据标签
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Alpine DevOps Tools" \
      org.label-schema.description="Alpine Linux based DevOps tools container image" \
      org.label-schema.version=$TOOL_VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vendor="DevOps Team" \
      org.label-schema.schema-version="1.0"

# 安装基础运维工具组1：网络诊断
RUN apk add --no-cache \
    curl \
    wget \
    busybox-extras \
    traceroute \
    iproute2 \
    tcpdump \
    netcat-openbsd \
    bind-tools \
    iperf3 \
    mtr \
    nmap \
    grep \
    vim \
    jq \
    procps \
    lsof \
    strace \
    ltrace \
    sysstat \
    iotop 
