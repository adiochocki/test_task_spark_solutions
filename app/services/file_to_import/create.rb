module FileToImport
  class Create
    class << self
      def call(file)
        saved_file = ::Spree::FileToImport.create({
                                                    csv_file: file
                                                  })
        saved_file.schedule_import if saved_file.valid?
        saved_file
      end
    end
  end
end
