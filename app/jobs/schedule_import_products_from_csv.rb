class ScheduleImportProductsFromCsv < ApplicationJob
  require 'csv'

  sidekiq_options retry: false, queue: :default

  def perform(id)
    file = Spree::FileToImport.find(id)
    FileToImport::ProcessFile.call(file)
  end
end
