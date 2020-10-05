module Products
  class CreateFromCsv
    class << self
      def call(shipping_category, stock_location, taxonomy, csv_row)

        created_product = Spree::Product.where(name: csv_row['name']).first_or_create! do |product|
          product.name = csv_row['name']
          product.price = csv_row['price'].gsub(',', '.').to_f
          product.description = csv_row['description']
          product.available_on = csv_row['availability_date'].to_datetime
          product.slug = csv_row['slug']
          product.sku = [csv_row['slug'], csv_row['name']].join('_')
          product.shipping_category = shipping_category
          product.taxons << taxonomy
        end

        add_stock(created_product, stock_location, csv_row['stock_total'])
      end

      private

      def add_stock(product, stock_location, number)
        product.stock_items.find_by!(stock_location: stock_location).update!(count_on_hand: number)
      end
    end
  end
end
