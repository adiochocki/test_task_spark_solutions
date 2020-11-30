module Spree
  class FileToImport < Spree::Base

    has_one_attached :csv_file

    self.table_name = 'file_to_imports'

    validates :csv_file, presence: true
    validate :correct_document_mime_type

    def csv_on_disk
      ActiveStorage::Blob.service.send(:path_for, csv_file.key)
    end

    def schedule_import
      ScheduleImportProductsFromCsv.perform_later(id)
    end

    private

    def correct_document_mime_type
      if csv_file.attached? && !csv_file.content_type.in?(%w(text/csv))
        errors.add(:csv_file, 'invalid_document_type')
      end
    end
  end
end
