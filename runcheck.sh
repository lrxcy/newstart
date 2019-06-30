#! /bin/bash

# 创建临时目录
mkdir -p ./tmp

# 获取域名相关信息
curl https://${1} --connect-timeout 30 -v -s -o /dev/null 2> ./tmp/ca.info

# 提取相应信息
cat ./tmp/ca.info | grep 'start date: ' > ./tmp/${1}.info
cat ./tmp/ca.info | grep 'expire date: ' >> ./tmp/${1}.info
cat ./tmp/ca.info | grep 'issuer: ' >> ./tmp/${1}.info
cat ./tmp/ca.info | grep 'subject: ' >> ./tmp/${1}.info

# 不同的机器采集的样本有一点出入
# cat ./tmp/ca.info | grep 'SSL certificate verify' >> ./tmp/${1}.info

# 去除*号及首行空格
sed -i 's/\*//g'  ./tmp/${1}.info && sed -i 's/^[[:space:]]*//'  ./tmp/${1}.info

# 变量相应的信息
start=$(sed -n '1p' ./tmp/${1}.info | awk -F ': ' '{print $2}')
expire=$(sed -n '2p' ./tmp/${1}.info | awk -F ': ' '{print $2}')
issuer=$(sed -n '3p' ./tmp/${1}.info | awk -F ': ' '{print $2}'| awk -F 'CN=' '{print $2}' | awk -F ',' '{print $1}')
subject=$(sed -n '4p' ./tmp/${1}.info | awk -F ': ' '{print $2}' | awk -F 'CN=' '{print $2}' | awk -F ',' '{print $1}')
# status=$(sed -n '5p' ./tmp/${1}.info | awk -F 'y ' '{print $2}' | awk -F '.' '{print $1}')

# 清除临时文件
rm -f ./tmp/ca.info
rm -f ./tmp/${1}.info

# 运行的日期
DATE="$(echo $(date '+%Y-%m-%d %H:%M:%S'))"

# 做变量转换及计算
nowstamp="$(date -d "$DATE" +%s)"
expirestamp="$(date -d "$expire" +%s)"
let EX=$expirestamp-$nowstamp
let expireday=$EX/86400

# 将最终的信息导入到json文件
echo '{' > tmp/${1}.json
echo '"check": "'$DATE'",' >> ./tmp/${1}.json
echo '"domain": "'${1}'",' >> ./tmp/${1}.json
echo '"start date": "'$start'",' >> ./tmp/${1}.json
echo '"expire date": "'$expire'",' >> ./tmp/${1}.json
# echo '"SSL certificate verify": "'$status'",' >>  ./tmp/${1}.json

if [ $expirestamp -lt $nowstamp ]
then
    echo '"status": "Expired",' >> ./tmp/${1}.json
    echo '"status_display": "error",' >> ./tmp/${1}.json
elif [ $expireday -lt 30 ]
then
    echo '"status": "Soon Expired",' >> ./tmp/${1}.json
    echo '"status_display": "warning",' >> ./tmp/${1}.json
else
    echo '"status": "Valid",' >> ./tmp/${1}.json
    echo '"status_display": "success",' >> ./tmp/${1}.json
fi

echo '"remain": "'$expireday'",' >> ./tmp/${1}.json
echo '"common name": "'$subject'",' >> ./tmp/${1}.json
echo '"issuer_cn": "'$issuer'"' >> ./tmp/${1}.json

echo '},' >> ./tmp/${1}.json
