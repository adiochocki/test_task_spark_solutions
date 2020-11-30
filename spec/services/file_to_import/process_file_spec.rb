require 'rails_helper'
require 'active_job/test_helper'

RSpec.describe FileToImport::ProcessFile do
  subject { described_class }
  let(:file_to_import) { Spree::FileToImport.create(csv_file: Rack::Test::UploadedFile.new(Rails.root + "spec/files/products.csv", 'text/csv')) }

  let(:result) { subject.call(file_to_import) }

  ActiveJob::Base.queue_adapter = :test

  describe '#call' do
    context 'with valid params' do

      it 'is scheduling jobs' do
        expect { result }.to change(Spree::Product, :count)
        allow(ScheduleCreateProduct).to receive(:perform_now).exactly(3).times
      end

      it 'creates products' do
        expect { result }.to change(Spree::Product, :count)
        expect(Spree::Product.count).to eq(3)
      end
    end
  end
end
