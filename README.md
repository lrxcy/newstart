# newstart
hello lrxcy!

chmod +x check.sh
./check.sh ssl_url

# 导入mongodb
mongoimport --db test --collection ssl --file ./output/ct.json --jsonArray
