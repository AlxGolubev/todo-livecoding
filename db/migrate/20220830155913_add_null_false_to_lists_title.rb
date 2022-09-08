class AddNullFalseToListsTitle < ActiveRecord::Migration[6.1]
  def change
    change_column_null :lists, :title, false
  end
end
