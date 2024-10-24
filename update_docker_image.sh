#!/bin/bash

#set -x

REGISTRY="registry.cn-chengdu.aliyuncs.com"
NAMESPACE="tickg"

echo curdir=$(pwd)
echo sysinfo=$(uname -a)
echo whoami=$(whoami)
docker version

fun_update(){
    IMAGE=$1
    TAG=$2
    echo $IMAGE:$TAG
    #把IMAGE中的斜线/替换为短横线-
    NEWIMAGE=$(echo $IMAGE | sed s#/#-# )
    #tag不变
    NEWTAG=$TAG
    docker pull $IMAGE:$TAG
    docker images | grep $IMAGE
    docker tag $IMAGE:$TAG "$REGISTRY/$NAMESPACE/$NEWIMAGE:$NEWTAG"
    docker images | grep $NEWIMAGE
    docker push "$REGISTRY/$NAMESPACE/$NEWIMAGE:$NEWTAG"
    echo 同步完成： "$REGISTRY/$NAMESPACE/$NEWIMAGE:$NEWTAG"

}


do_main(){
    fun_update vaultwarden/server latest
    fun_update portainer/portainer-ce latest
    fun_update nginx:1.27
    fun_update jc21/nginx-proxy-manager latest
    # v1.5.9 , 9个月了一直没更新了
    fun_update productiveops/dokemon latest
    # v2.4 ，  6年一直没更新了
    fun_update bytemark/webdav latest
    
}

do_main

