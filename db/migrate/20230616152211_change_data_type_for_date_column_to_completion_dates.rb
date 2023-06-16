class ChangeDataTypeForDateColumnToCompletionDates < ActiveRecord::Migration[7.0]
  def change
    change_column :completion_dates, :date, :date
  end
end
