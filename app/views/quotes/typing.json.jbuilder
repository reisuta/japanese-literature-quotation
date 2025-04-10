json.array! @quotes do |quote|
  json.array! [ quote.content_alphabet, quote.content ]
end
