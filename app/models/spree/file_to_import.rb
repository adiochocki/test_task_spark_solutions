module Spree
  class FileToImport < Spree::Base

    has_one_attached :csv_file

    self.table_name = 'file_to_imports'

    def csv_on_disk
      ActiveStorage::Blob.service.send(:path_for, csv_file.key)
    end
  end
end
