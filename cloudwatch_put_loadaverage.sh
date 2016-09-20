#!/bin/bash

## スクリプトの実行方法の表示する
function print_usage() {
    echo "Usage: $0"
    echo "       $0 [--help]"
    echo "       $0 [--debug]"

    return 0
}

## 入力されたパラメータをチェックする
function check_parameter() {

    ## パラメータチェック
    if [ $# -eq 0 ] || [ $# -eq 1 ] ; then
        ## パラメータとして --help を指定した場合、スクリプトの実行方法を表示する
        if [ $# -eq 1 ] && [ $1 = "--help" ] ; then
            print_usage
            exit
        fi

        ## パラメータとして --debug を指定した場合、実行するawsコマンド自体も表示する
        if [ $# -eq 1 ] && [ $1 = "--debug" ] ; then
            debug_flg="on"
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

## パラメータチェック
check_parameter $@

## CloudWatchに追加するメトリックス名や単位の設定
metric_name="LoadAverage"
name_space="AmazonLinux/${metric_name}"
unit="Count"

## ロードアベレージを取得する
load_average=`uptime | awk 'BEGIN{FS="load average: "}{print $2}' | awk 'BEGIN{FS="."}{print $1}'`

## AWS CloudWatchのカスタムメトリックスにロードアベレージを追加する
if [ ${debug_flg} == "on" ] ; then
    set -x
fi

${AWS_CLI} cloudwatch --region ${AWS_CLI_REGION} put-metric-data --metric-name `hostname -s`/${metric_name} --namespace ${name_space} --value ${load_average} --unit ${unit}
