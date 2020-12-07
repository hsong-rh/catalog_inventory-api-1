class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks, :id => :uuid do |t|
      t.references :tenant, :index => true, :null => false
      t.references :source, :index => true, :null => true, :foreign_key => {:on_delete => :nullify}
      t.string :name
      t.string :status
      t.string :state
      t.string :message
      t.string :type
      t.jsonb :input
      t.jsonb :output
      t.jsonb :context
      t.datetime :completed_at
      t.datetime :archived_at, :index => true
      t.timestamps
      t.string :target_source_ref, :null => true
      t.string :target_type, :null => true
      t.jsonb :forwardable_headers

      t.index %i[target_source_ref target_type]
    end
  end
end
