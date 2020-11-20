# coding: utf-8
require 'rails_helper'

describe 'Products', type: :feature, js: true do
  context 'as admin user' do
    ActiveJob::Base.queue_adapter = :test

    stub_authorization!

    def file_path(file_name)
      Rails.root + "spec/files/#{file_name}"
    end

    context 'Import products' do
        it 'is able to upload csv file' do
          visit spree.admin_products_path
          attach_file('import_products', file_path('products.csv'))
          expect {
            ScheduleImportProductsFromCsv.perform_later
          }.to have_enqueued_job

          expect(Spree::FileToImport.all.count).to be(1)
          expect(page).to have_content('Your file was successfully uploaded and is processed in the background. Refresh page to see imported products.')
        end

        it 'is not able to upload file different than csv' do
          visit spree.admin_products_path
          attach_file('import_products', file_path('tak_bylo.jpeg'))

          expect(Spree::FileToImport.all.count).to be(1)
          expect(page).to have_content('Please provide valid CSV file.')
        end
      end
  end
end
