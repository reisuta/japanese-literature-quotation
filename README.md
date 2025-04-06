## デプロイ方法
railwayの場合
```
railway up
```
rakeタスクなどを実行したい場合は、
```
railway ssh
```
で接続してから実行したいコマンドを実行

## 使用例
箴言一覧を取得する
```
curl https://japanese-literature-quotation-production.up.railway.app/api/v1/quotes
```

特定の箴言を取得する(※jqは別途インストールする必要あり)
```
curl https://japanese-literature-quotation-production.up.railway.app/api/v1/quotes/1 | jq '.content'
# "山路を登りながら、こう考えた。智に働けば角が立つ。情に棹させば流される。意地を通せば窮屈だ。とかくに人の世は住みにくい。"
```
