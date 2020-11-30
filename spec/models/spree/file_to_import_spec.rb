require 'rails_helper'

RSpec.describe Spree::FileToImport, type: :model do
  let(:file_to_import) { Rack::Test::UploadedFile.new(Rails.root + "spec/files/products.csv", 'text/csv')}
  let(:invalid_file_to_import) { Rack::Test::UploadedFile.new(Rails.root + "spec/files/tak_bylo.jpeg", 'image/jpeg')}

  describe 'validations' do
    it 'is no valid without csv_file' do
      file = Spree::FileToImport.new
      expect(file).not_to be_valid
    end

    it 'is no valid with jpeg file' do
      file = Spree::FileToImport.create({csv_file: invalid_file_to_import})
      expect(file).not_to be_valid
      expect(file.errors[:csv_file].to_s).to match 'invalid_document_type'
    end

    it 'is valid with file' do
      file = Spree::FileToImport.create({csv_file: file_to_import})
      expect(file).to be_valid
    end
  end
end
