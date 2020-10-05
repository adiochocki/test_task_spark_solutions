class ScheduleImportProductsFromCsv

  include Sidekiq::Worker
  require 'csv'
  sidekiq_options retry: false, queue: :default

  def perform(id)
    CSV.foreach(Spree::FileToImport.find(id).csv_on_disk, { headers: true, col_sep: ';' }) do |row|
      unless row.to_h['name'].nil?
        ScheduleCreateProduct.perform_async(row.to_h)
      end
    end
  end
end
