require 'rails_helper'
require 'active_job/test_helper'

RSpec.describe FileToImport::Create do
  subject { described_class }
  let(:file_to_import) { Rack::Test::UploadedFile.new(Rails.root + "spec/files/products.csv", 'text/csv')}
  let(:invalid_file_to_import) { Rack::Test::UploadedFile.new(Rails.root + "spec/files/tak_bylo.jpeg", 'image/jpeg')}

  let(:result) { subject.call(file_to_import) }

  ActiveJob::Base.queue_adapter = :test

  describe '#call' do
    context 'with valid file' do
      it 'creates file to import' do
        expect { result }.to change(Spree::FileToImport, :count)
        expect(result.valid?).to be_truthy
        expect(Spree::FileToImport.count).to eq(1)
      end
    end
    context 'with invalid file' do
      let(:result) { subject.call(invalid_file_to_import) }

      it 'not creates file to import' do
        expect { result }.not_to change(Spree::FileToImport, :count)
        expect(Spree::FileToImport.count).to eq(0)
        expect(result.valid?).to be_falsey
        expect(result.errors[:csv_file].to_s).to match 'invalid_document_type'
      end
    end
  end
end
