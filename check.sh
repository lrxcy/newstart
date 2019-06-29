#! /bin/bash

# 添加执行权限
chmod +x ./runcheck.sh

# 创建当前目录文件夹
mkdir -p ./tmp/api

# 获取url并执行检测
for i in $@
do
    ./runcheck.sh ${i}
done

# 写入json文件
echo '[' > ./tmp/api/ct.json

# 将检测结果放入保留的json文件
for i in $@
do
    cat ./tmp/${i}.json >> ./tmp/api/ct.json
done

# 清除最后一行
sed -i '$d' ./tmp/api/ct.json

echo '}' >> ./tmp/api/ct.json
echo ']' >> ./tmp/api/ct.json

# 打成无序状态
sed -i ':label;N;s/\n/ /;b label' ./tmp/api/ct.json

# 基本上没有变化
sed -i "s|\" \"||g" ./tmp/api/ct.json
# 去掉了":''后面的空格
sed -i "s|\"\: \"|\"\:\"|g" ./tmp/api/ct.json
# 去掉","后面的空格
sed -i "s|\"\, \"|\"\,\"|g" ./tmp/api/ct.json
# 去掉多个url检测时每一个之间空格
sed -i "s|\" }, { \"|\"},{\"|g" ./tmp/api/ct.json


mkdir -p ./output
cp -rf ./tmp/api/ct.json ./output/ct.json

# 清除临时文件
rm -rf ./tmp

# 提示
echo "Check completed! Can use 'cat ./output/ct.json | jq' check!"

