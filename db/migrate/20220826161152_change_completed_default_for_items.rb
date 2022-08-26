class ChangeCompletedDefaultForItems < ActiveRecord::Migration[6.1]
  def up
    change_column_default :items, :completed, false
  end

  def down
    change_column_default :items, :completed, nil
  end
end
