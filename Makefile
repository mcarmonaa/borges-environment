SHELL = /bin/sh

DOCKER_COMPOSE ?= /usr/local/bin/docker-compose
HDFS_CLIENT ?= /home/manu/go/bin/hdfs
NAMENODE ?= namenode
DATANODE ?= datanode1
SLEEP_TIME = 80
BORGES ?= bin/borges
BORGES_LOG_LEVEL = debug
TEMP_DIR ?= tmp
REPOS_LIST ?= repos.list
HADOOP_USER_NAME ?= root
HDFS_ADDR ?= localhost:8020
ROOT_REPOS_DIR ?= root-repositories
ROOT_REPOS_TEMP_DIR ?= tmp/siva-copy
NUM_WORKERS ?= 4

.PHONY: up stop restart down hdfs-fail producer consumer gen-dirs hdfs-dirs

gen-dirs:
	mkdir -p volumes/{namenode,datanode1,postgres} tmp

up: gen-dirs
	$(DOCKER_COMPOSE) up -d

stop:
	$(DOCKER_COMPOSE) stop

restart:
	$(DOCKER_COMPOSE) restart

down:
	$(DOCKER_COMPOSE) down

top:
	$(DOCKER_COMPOSE) top

hdfs-fail:
	$(DOCKER_COMPOSE) stop $(NAMENODE) $(DATANODE) && \
	sleep $(SLEEP_TIME) && \
	$(DOCKER_COMPOSE) restart $(NAMENODE) $(DATANODE)

producer:
	$(BORGES) init && \
	$(BORGES) producer --loglevel=$(BORGES_LOG_LEVEL) \
	--source=file --file $(REPOS_LIST)

consumer: hdfs-dirs
	HADOOP_USER_NAME=$(HADOOP_USER_NAME) \
	CONFIG_HDFS=$(HDFS_ADDR) \
	CONFIG_TEMP_DIR=$(TEMP_DIR) \
	CONFIG_ROOT_REPOSITORIES_DIR=/$(ROOT_REPOS_DIR) \
	CONFIG_ROOT_REPOSITORIES_TEMP_DIR=/$(ROOT_REPOS_TEMP_DIR) \
	$(BORGES) consumer --loglevel=$(BORGES_LOG_LEVEL) --workers=$(NUM_WORKERS)

hdfs-dirs:
	HADOOP_USER_NAME=$(HADOOP_USER_NAME) \
	$(HDFS_CLIENT) mkdir -p hdfs://$(HDFS_ADDR)/{$(ROOT_REPOS_DIR),$(ROOT_REPOS_TEMP_DIR)}
