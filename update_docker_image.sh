#!/bin/bash

#set -x
echo 设置阿里服务器地址
REGISTRY="registry.cn-chengdu.aliyuncs.com"
NAMESPACE="tickg"

echo 当前目录 $(pwd)
echo 系统信息 $(uname -a)
echo 用户信息 $(whoami)
echo docker版本
docker version | grep -i version

fun_update(){
    echo "------------------分割线-------------------"
    IMAGE=$1
    TAG=$2
    echo 开始处理：$IMAGE:$TAG
    #把IMAGE中的斜线/替换为短横线-
    NEWIMAGE=$(echo $IMAGE | sed s#/#-# )
    #tag不变
    NEWTAG=$TAG
    echo 开始拉取
    docker pull $IMAGE:$TAG  > tmp.log
    tail -3 tmp.log
    echo 拉取结果
    docker images | grep $IMAGE
    echo 重新tag
    docker tag $IMAGE:$TAG "$REGISTRY/$NAMESPACE/$NEWIMAGE:$NEWTAG"
    echo tag结果
    docker images | grep $NEWIMAGE
    echo 开始push到阿里云
    docker push "$REGISTRY/$NAMESPACE/$NEWIMAGE:$NEWTAG"   > tmp.log
    tail -2 tmp.log
    echo push完成： "$REGISTRY/$NAMESPACE/$NEWIMAGE:$NEWTAG"

}


do_main(){
    fun_update vaultwarden/server                   latest
    fun_update portainer/portainer-ce              latest
    fun_update nginx                                        1.27
    fun_update jc21/nginx-proxy-manager       latest
    # v1.5.9 , 9个月了一直没更新了
    fun_update productiveops/dokemon          latest
    # v2.4 ，  6年一直没更新了
    fun_update bytemark/webdav                    latest
    #
    fun_update zerotier/zerotier                  latest
    
}

do_main

