class CreateFileToImports < ActiveRecord::Migration[6.0]
  def change
    create_table :file_to_imports do |t|
      t.binary :file
      t.string :workflow_state
      t.timestamps
    end
  end
end
