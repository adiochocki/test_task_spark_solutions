module MyStore::Spree::Admin::ProductsControllerDecorator

  def imports
    saved_file = ::FileToImport::Create.call(params[:file])

    flash[:success] = 'Your file was successfully uploaded and is processed in the background. Refresh page to see imported products.' if saved_file.valid?
    flash[:error] = 'Please provide valid CSV file.' unless saved_file.valid?

    redirect_to collection_url
  end
end

::Spree::Admin::ProductsController.prepend MyStore::Spree::Admin::ProductsControllerDecorator
