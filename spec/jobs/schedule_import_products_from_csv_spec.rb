require 'rails_helper'

RSpec.describe ScheduleImportProductsFromCsv, type: :job do
  describe '#perform_later' do
    it 'import products from csv' do
      expect {
        ScheduleImportProductsFromCsv.perform_later(1)
      }.to have_enqueued_job
    end
  end
end
