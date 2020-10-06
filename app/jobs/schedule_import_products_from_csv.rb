class ScheduleImportProductsFromCsv

  include Sidekiq::Worker
  require 'csv'
  sidekiq_options retry: false, queue: :default

  def perform(id)
    CSV.foreach(Spree::FileToImport.find(id).csv_on_disk, { headers: true, col_sep: ';' }) do |row|
      unless row.to_h['name'].nil?
        default_stock_location = Spree::StockLocation.find_or_create_by!(name: 'default')
        taxonomy = Spree::Taxon.find_or_create_by!(name: row.to_h['category'])
        ScheduleCreateProduct.perform_async(row.to_h, default_stock_location.id, taxonomy.id)
      end
    end
  end
end
