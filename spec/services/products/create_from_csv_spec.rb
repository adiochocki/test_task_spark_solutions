require 'rails_helper'

RSpec.describe Products::CreateFromCsv do
  subject { described_class }
  let(:result) { subject.call(csv_row) }

  describe '#call' do
    context 'with valid params' do
      let(:csv_row) do
        {
          "name" => "Ruby on Rails Bag",
          "description" => "Animi officia aut amet molestiae atque excepturi. Placeat est cum occaecati molestiae quia. Ut soluta ipsum doloremque perferendis eligendi voluptas voluptatum.",
          "price" => "22,99",
          "availability_date" => "2017-12-04T14:55:22.913Z",
          "slug" => "ruby-on-rails-bag",
          "stock_total" => "15",
          "category" => "Bags"
        }
      end

      it 'creates product' do
        expect { result }.to change(Spree::Product, :count)
        expect(result.valid?).to be true
        expect(result).to have_attributes(id: 1)
      end
    end

    context 'with invalid params' do
      let(:csv_row) do
        {}
      end

      it 'return errors' do
        expect { result }.to raise_error(ActiveRecord::RecordInvalid)
      end

      let(:csv_row) do
        {
          "name" => "Ruby on Rails Bag",
          "description" => "Animi officia aut amet molestiae atque excepturi. Placeat est cum occaecati molestiae quia. Ut soluta ipsum doloremque perferendis eligendi voluptas voluptatum.",
          "price" => "22,99",
          "availability_date" => "2017-12-04T14:55:22.913Z",
          "slug" => "ruby-on-rails-bag",
          "stock_total" => "15",
        }
      end

      it 'return errors without category' do
        expect { result }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
