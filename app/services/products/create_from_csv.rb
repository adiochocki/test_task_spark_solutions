module Products
  class CreateFromCsv
    class << self
      def call(csv_row)
        shipping_category = find_shipping_category
        taxonomy = find_taxonomy(csv_row.to_h['category'])

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

        created_product.add_stock(find_stock_location, csv_row['stock_total'])
        created_product
      end

      private

      def find_shipping_category
        Spree::ShippingCategory.find_or_create_by!(name: 'Default')
      end

      def find_stock_location
        Spree::StockLocation.find_or_create_by!(name: 'default')
      end

      def find_taxonomy(category)
        Spree::Taxon.find_or_create_by!(name: category)
      end
    end
  end
end
