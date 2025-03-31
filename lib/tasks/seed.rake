namespace :import do
  desc "青空文庫から引用を取り込む"
  task aozora: :environment do
    require "nokogiri"
    require "open-uri"

    # 青空文庫のURLリスト（例）
    urls = [
      { url: "https://www.aozora.gr.jp/cards/000148/files/773_14560.html", author: "夏目漱石", work: "こころ", era: "明治" }
      # 他の作品も追加
    ]

    urls.each do |url_data|
      doc = Nokogiri::HTML(URI.open(url_data[:url]))
      # 本文のパースはサイトの構造によって調整が必要
      content = doc.css("div.main_text").text.strip

      quotes = content.split("。").select { |s| s.length > 50 && s.length < 200 }.map { |s| s + "。" }

      quotes.sample(5).each do |quote_text|
        quote = Quote.create(
          content: quote_text,
          author: url_data[:author],
          work: url_data[:work],
          era: url_data[:era]
        )

        modern = Tag.find_or_create_by(name: "近代文学")
        novel = Tag.find_or_create_by(name: "小説")
        QuoteTag.create(quote: quote, tag: modern)
        QuoteTag.create(quote: quote, tag: novel)
      end
    end
  end
end
