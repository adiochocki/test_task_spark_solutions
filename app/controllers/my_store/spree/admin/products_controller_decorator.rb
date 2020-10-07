module MyStore::Spree::Admin::ProductsControllerDecorator
  require 'csv'

  def imports
    if params[:file].present? && params[:file].content_type == 'text/csv'
      saved_file = ::Spree::FileToImport.create!
      saved_file.csv_file.attach(params[:file])
      ScheduleImportProductsFromCsv.perform_async(saved_file.id)
      flash[:success] = 'Your file was successfully uploaded and is processed in the background. Refresh page to see imported products.'
    else
      flash[:error] = 'Please provide valid CSV file.'
    end

    redirect_to collection_url
  end
end

::Spree::Admin::ProductsController.prepend MyStore::Spree::Admin::ProductsControllerDecorator
