class ScheduleCreateProduct < ApplicationJob
  sidekiq_options retry: false, queue: :default

  def perform(csv_row)
    Products::CreateFromCsv.call(csv_row)
  end
end
