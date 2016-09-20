# AWS CloudWatchカスタムメトリックスにEC2インスタンスのプロセス死活監視、ディスク使用率、iノード使用率を追加するスクリプト
Add The Custom Metrics of EC2 Instance in AWS CloudWatch

http://qiita.com/na0AaooQ/items/9dc3649e0bf4b0193ef9

  - EC2 Instance ProcessCount           cloudwatch_put_process.sh
  - EC2 Instance DiskPartitionUse       cloudwatch_put_disk_use.sh
  - EC2 Instance DiskPartitionInodeUse  cloudwatch_put_disk_inode_use.sh
  - EC2 Instance LoadAverage            cloudwatch_put_loadaverage.sh
  
```
git clone https://github.com/na0AaooQ/aws-cloudwatch-put-ec2-metric.git
```
