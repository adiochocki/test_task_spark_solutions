module MyStore::Spree::Admin::ProductsControllerDecorator
  require 'csv'

  def imports
    flash[:success] = Spree.t('notice_messages.product_deleted')

    if params[:file].present?
      saved_file = ::Spree::FileToImport.create!
      saved_file.csv_file.attach(params[:file])
      ScheduleImportProductsFromCsv.perform_async(saved_file.id)
    end
    redirect_to collection_url
  end

end

::Spree::Admin::ProductsController.prepend MyStore::Spree::Admin::ProductsControllerDecorator
