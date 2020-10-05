class ScheduleCreateProduct
  include Sidekiq::Worker

  sidekiq_options retry: false, queue: :default

  def perform(csv_row)
    default_shipping_category = Spree::ShippingCategory.find_by!(name: 'Default')
    default_stock_location = Spree::StockLocation.find_or_create_by!(name: 'default')
    taxonomy = Spree::Taxon.find_or_create_by!(name: csv_row['category'])

    Products::CreateFromCsv.call(default_shipping_category, default_stock_location, taxonomy, csv_row)
  end
end
