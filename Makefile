# Makefile for Alpine DevOps Tools Container

# 默认目标
.DEFAULT_GOAL := help

# 镜像名称和标签
IMAGE_NAME ?= alpine-devops
IMAGE_TAG ?= latest
FULL_IMAGE_NAME ?= $(IMAGE_NAME):$(IMAGE_TAG)

# 读取构建环境变量
include .build.env
export

# 显示帮助信息
help:
	@echo "" 
	@echo "使用方法: make [TARGET]"
	@echo ""
	@echo "可用目标："
	@echo "  build       构建${CRI-BIN}镜像"
	@echo "  run         运行交互式容器"
	@echo "  shell       进入正在运行的容器shell"
	@echo "  test        执行功能测试"
	@echo "  clean       清理构建产物"
	@echo "  push        推送镜像到仓库"
	@echo "  version     显示工具版本信息"
	@echo "  debug       进入调试模式运行容器"
	@echo "  inspect     检查镜像元数据"
	@echo ""


# 构建${CRI-BIN}镜像
build:
	@echo "构建镜像 $(FULL_IMAGE_NAME)..." 
	@echo "构建日期: $(BUILD_DATE)"
	@echo "版本: $(TOOL_VERSION)"
	@echo "Git提交: $(VCS_REF)"
	${CRI-BIN} build \
        --build-arg BUILD_DATE=$(BUILD_DATE) \
        --build-arg VCS_REF=$(VCS_REF) \
        --build-arg TOOL_VERSION=$(TOOL_VERSION) \
        --build-arg SECURITY_HARDENING=$(SECURITY_HARDENING) \
        --build-arg DROP_ROOT=$(DROP_ROOT) \
        --build-arg NON_ROOT_USER=$(NON_ROOT_USER) \
        --build-arg NON_ROOT_UID=$(NON_ROOT_UID) \
        -t $(FULL_IMAGE_NAME) .

# 运行交互式容器
run: build
	@echo "启动容器..."
	${CRI-BIN} run --rm -it \
        --name devops-toolbox \
        -p 80:80 \
        -p 443:443 \
        -p 9090:9090 \
        $(FULL_IMAGE_NAME)

# 进入容器shell（需要容器已经在运行）
shell:
	@echo "进入容器shell..."
	${CRI-BIN} exec -it devops-toolbox sh

# 执行功能测试
test: run
	@echo "执行功能测试..."
	${CRI-BIN} inspect $(FULL_IMAGE_NAME) > /dev/null 2>&1
	@if ${CRI-BIN} run --rm $(FULL_IMAGE_NAME) curl --version > /dev/null 2>&1; then \
		echo "curl 测试通过"; \
	else \
		echo "curl 测试失败"; \
		exit 1; \
	fi

# 清理构建产物
clean:
	@echo "清理构建产物..."
	${CRI-BIN} rmi $(FULL_IMAGE_NAME) || true

# 推送镜像到仓库
push: build
	@echo "推送镜像到仓库..."
	${CRI-BIN} push $(FULL_IMAGE_NAME)

# 显示工具版本信息
version:
	@${CRI-BIN} run --rm $(FULL_IMAGE_NAME) /entrypoint.sh

# 调试模式运行容器
debug:
	@echo "以调试模式启动容器..."
	${CRI-BIN} run --rm -it \
        --name devops-toolbox-debug \
        -p 80:80 \
        -p 443:443 \
        -p 9090:9090 \
        -e DEBUG=true \
        $(FULL_IMAGE_NAME) sh

# 检查镜像元数据
inspect:
	@echo "检查镜像元数据..."
	${CRI-BIN} inspect $(FULL_IMAGE_NAME) | grep -A 10 "Labels"