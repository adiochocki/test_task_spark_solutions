class ScheduleCreateProduct
  include Sidekiq::Worker

  sidekiq_options retry: false, queue: :default

  def perform(csv_row, stock_id, taxonomy_id)
    default_shipping_category = Spree::ShippingCategory.find_by!(name: 'Default')
    default_stock_location = Spree::StockLocation.find(stock_id)
    taxonomy = Spree::Taxon.find(taxonomy_id)

    Products::CreateFromCsv.call(default_shipping_category, default_stock_location, taxonomy, csv_row)
  end
end
