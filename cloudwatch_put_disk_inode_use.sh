#!/bin/bash

## スクリプトの実行方法の表示する
function print_usage() {
    echo "Usage: $0 [DiskPartitionName]"
    echo "       $0 [--help]"
    echo "       $0 [--debug] [DiskPartitionName]"

    return 0
}

## 入力されたパラメータをチェックする
function check_parameter() {

    if [ $# -ge 1 ] && [ $# -le 2 ] ; then
        ## パラメータとして --help を指定した場合、スクリプトの実行方法を表示する
        if [ $1 == "--help" ] ; then
            print_usage
            exit

        ## パラメータとして --debug を指定した場合、実行するawsコマンド自体も表示する
        elif [ $# -eq 2 ] && [ $1 == "--debug" ] ; then
            debug_flg="on"
            disk_name="$2"

        elif [ $# -eq 1 ] && [ $1 == "--debug" ] ; then
            print_usage
            exit

        elif [ $# -eq 1 ] ; then
            disk_name="$1"
        fi

    else
        print_usage
        exit
    fi

    return 0
}

## AWS CLI設定
readonly AWS_CLI="/usr/bin/aws"
readonly AWS_CLI_REGION="ap-northeast-1"

## デバッグフラグ
debug_flg="off"

## パラメータ初期化
disk_name=""

check_parameter $@

## CloudWatchに追加するメトリックス名や単位の設定
metric_name="${disk_name}"
name_space="AmazonLinux/DiskInodeUse/_${metric_name}"
unit="Percent"

## パーティションのiノード使用率を取得する
disk_inode_use=`df -Pil | grep -v "Filesystem" | grep -w "${disk_name}" | awk 'BEGIN{FS=" "}{print $5}' | sed -s 's/%//g'`

## AWS CloudWatchのカスタムメトリックスにiノード使用率を追加する
if [ ${debug_flg} == "on" ] ; then
    set -x
fi

${AWS_CLI} cloudwatch --region ${AWS_CLI_REGION} put-metric-data --metric-name `hostname -s`/DiskInodeUse_${metric_name} --namespace ${name_space} --value ${disk_inode_use} --unit ${unit}
