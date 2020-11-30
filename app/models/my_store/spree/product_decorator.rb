module MyStore::Spree::ProductDecorator
  def add_stock(stock_location, number)
    stock_items.find_by!(stock_location: stock_location).update!(count_on_hand: number)
  end
end

Spree::Product.prepend MyStore::Spree::ProductDecorator if ::Spree::Product.included_modules.exclude?(MyStore::Spree::ProductDecorator)
