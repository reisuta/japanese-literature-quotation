modern = Tag.create(name: '近代文学')
classic = Tag.create(name: '古典')
poetry = Tag.create(name: '詩歌')
novel = Tag.create(name: '小説')

quotes = [
  {
    content: '山路を登りながら、こう考えた。智に働けば角が立つ。情に棹させば流される。意地を通せば窮屈だ。とかくに人の世は住みにくい。',
    author: '夏目漱石',
    work: '草枕',
    era: '明治',
    tags: [ modern, novel ]
  },
  {
    content: '吾輩は猫である。名前はまだ無い。',
    author: '夏目漱石',
    work: '吾輩は猫である',
    era: '明治',
    tags: [ modern, novel ]
  },
  {
    content: '人間は所詮ひとりなのだ。どこまでいってもひとり。それがさびしいから人を求める。これは矛盾だ。',
    author: '太宰治',
    work: '人間失格',
    era: '昭和',
    tags: [ modern, novel ]
  },
  {
    content: '行く河の流れは絶えずして、しかも本の水にあらず。よどみに浮かぶうたかたは、かつ消えかつ結びて、久しくとどまりたるためしなし。',
    author: '鴨長明',
    work: '方丈記',
    era: '鎌倉',
    tags: [ classic ]
  },
  {
    content: '世の中にたえて桜のなかりせば春の心はのどけからまし',
    author: '在原業平',
    work: '古今和歌集',
    era: '平安',
    tags: [ classic, poetry ]
  }
]

quotes.each do |quote_data|
  quote = Quote.create(
    content: quote_data[:content],
    author: quote_data[:author],
    work: quote_data[:work],
    era: quote_data[:era]
  )

  quote_data[:tags].each do |tag|
    QuoteTag.create(quote: quote, tag: tag)
  end
end

puts "#{Quote.count}件の引用と#{Tag.count}件のタグを作成しました。"
