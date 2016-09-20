#!/bin/bash

## スクリプトの実行方法の表示する
function print_usage() {
    echo "Usage: $0 [ProcessName]"
    echo "       $0 [--help]"
    echo "       $0 [--debug] [ProcessName]"

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
            process_name="$2"

        elif [ $# -eq 1 ] && [ $1 == "--debug" ] ; then
            print_usage
            exit

        elif [ $# -eq 1 ] ; then
            process_name="$1"
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
process_name=""

check_parameter $@

## CloudWatchに追加するメトリックス名や単位の設定
metric_name="${process_name}"
name_space="AmazonLinux/ProcessCount/${metric_name}"
unit="Count"

## プロセス数を取得する
process_count=`ps awux | grep -v grep | grep -v "$0" | grep -w "${process_name}" | wc -l`

## AWS CloudWatchのカスタムメトリックスにプロセス数を追加する
if [ ${debug_flg} == "on" ] ; then
    set -x
fi

${AWS_CLI} cloudwatch --region ${AWS_CLI_REGION} put-metric-data --metric-name `hostname -s`/${metric_name} --namespace ${name_space} --value ${process_count} --unit ${unit}
