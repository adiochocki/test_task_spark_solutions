require 'csv'

module FileToImport
  class ProcessFile
    class << self
      def call(file)
        CSV.foreach(file.csv_on_disk, { headers: true, col_sep: ';' }) do |row|
          return if row.to_h['name'].nil?

          ScheduleCreateProduct.perform_now(row.to_h)
        end
      end
    end
  end
end
