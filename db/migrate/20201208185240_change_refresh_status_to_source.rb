class ChangeRefreshStatusToSource < ActiveRecord::Migration[5.2]
  def change
    remove_column :sources, :refresh_status, :string
    add_column    :sources, :info, :jsonb
  end
end
