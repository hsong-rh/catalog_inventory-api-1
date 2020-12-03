class InitTables < ActiveRecord::Migration[5.1]
  def change
    create_table :tenants do |t|
      t.string   :name
      t.text     :description
      t.string   :external_tenant, :null => false
      t.timestamps

      t.index [:external_tenant], :unique => true
    end

    create_table :sources do |t|
      t.string :name, :null => false, :default => ""
      t.string :uid, :null => false
      t.bigint :tenant_id, :null => false
      t.string :refresh_status
      t.timestamps

      t.index %i[tenant_id uid], :unique => true
    end

    create_table :service_credentials do |t|
      t.references :tenant, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :source, :type => :bigint, :index => false, :foreign_key => {:on_delete => :cascade}
      t.string :source_ref, :null => false
      t.string :name
      t.string :type_name
      t.text :description

      t.datetime :resource_timestamp
      t.jsonb :resource_timestamps, :default => {}
      t.datetime :resource_timestamps_max

      t.timestamps
      t.datetime :archived_at
      t.datetime :source_created_at
      t.datetime :source_updated_at
      t.datetime :last_seen_at

      t.bigint :service_credential_type_id

      t.index :archived_at
      t.index :last_seen_at
      t.index :service_credential_type_id

      t.index %i[source_id source_ref], :unique => true
    end

    create_table :service_credential_types do |t|
      t.references :tenant, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :source, :type => :bigint, :index => false, :foreign_key => {:on_delete => :cascade}
      t.string :name
      t.string :description
      t.string :kind
      t.string :namespace

      t.string :source_ref, :null => false

      t.datetime :resource_timestamp
      t.jsonb :resource_timestamps, :default => {}
      t.datetime :resource_timestamps_max

      t.timestamps
      t.datetime :archived_at
      t.datetime :source_created_at
      t.datetime :source_deleted_at
      t.datetime :last_seen_at

      t.index :archived_at
      t.index :last_seen_at

      t.index %i[source_id source_ref], :unique => true
    end

    create_table :service_inventories do |t|
      t.references :tenant, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :source, :type => :bigint, :index => false, :foreign_key => {:on_delete => :cascade}

      t.string :source_ref, :null => false
      t.string :name
      t.text :description

      t.jsonb :extra

      t.datetime :resource_timestamp
      t.jsonb :resource_timestamps, :default => {}
      t.datetime :resource_timestamps_max

      t.timestamps
      t.datetime :archived_at
      t.datetime :source_created_at
      t.datetime :source_updated_at
      t.datetime :last_seen_at

      t.index :archived_at
      t.index :last_seen_at

      t.index %i[source_id source_ref], :unique => true
    end

    create_table :service_instances do |t|
      t.references :source, :type => :bigint, :index => true
      t.string     :source_ref, :null => false
      t.string     :name
      t.references :service_offering, :type => :bigint, :index => true
      t.bigint     :service_plan_id, :index => true
      t.jsonb      :extra
      t.timestamps
      t.datetime   :source_deleted_at, :index => true
      t.bigint     :tenant_id, :null => false
      t.datetime   :source_created_at
      t.datetime   :archived_at, :index => true
      t.datetime   :resource_timestamp
      t.jsonb      :resource_timestamps, :default => {}
      t.datetime   :resource_timestamps_max
      t.datetime   :last_seen_at, :index => true
      t.string     :external_url
      t.references :service_inventory, :index => true, :null => true, :foreign_key => {:on_delete => :nullify}
      t.references :root_service_instance, :index => true, :null => true,
                   :foreign_key => {:on_delete => :nullify, :to_table => 'service_instances'}
      t.index      %i[source_id source_ref], :unique => true
      t.index      :tenant_id
    end

    create_table :service_instance_nodes do |t|
      t.references :tenant, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :source, :index => false, :null => false, :foreign_key => {:on_delete => :cascade}

      t.references :service_inventory, :index => true, :null => true, :foreign_key => {:on_delete => :nullify}
      t.references :service_instance, :index => true, :null => true, :foreign_key => {:on_delete => :nullify}
      t.references :root_service_instance, :index => true, :null => true,
                   :foreign_key => {:on_delete => :nullify, :to_table => 'service_instances'}

      t.string     :source_ref, :null => false
      t.string     :name
      t.jsonb      :extra

      t.datetime   :resource_timestamp
      t.jsonb      :resource_timestamps, :default => {}
      t.datetime   :resource_timestamps_max
      t.timestamps

      t.datetime :archived_at, :index => true
      t.datetime :source_created_at
      t.datetime :source_updated_at
      t.datetime   :last_seen_at, :index => true
    end

    create_table :service_offering_icons do |t|
      t.references :tenant, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :source, :index => false, :null => false, :foreign_key => {:on_delete => :cascade}

      t.string :source_ref, :null => false
      t.binary :data
      t.timestamps
      t.datetime :last_seen_at, :index => true
    end

    create_table :service_offerings do |t|
      t.references :source, :type => :bigint, :index => true
      t.string     :source_ref
      t.string     :name
      t.text       :description
      t.jsonb      :extra

      t.timestamps
      t.datetime   :source_deleted_at, :index => true
      t.bigint     :tenant_id, :null => false
      t.datetime   :source_created_at
      t.datetime   :archived_at, :index => true
      t.datetime   :resource_timestamp
      t.jsonb      :resource_timestamps, :default => {}
      t.datetime   :resource_timestamps_max
      t.datetime   :last_seen_at, :index => true
      t.string     :display_name
      t.string     :documentation_url
      t.text       :long_description
      t.string     :distributor
      t.string     :support_url
      t.references :service_offering_icon, :index => true, :null => true, :foreign_key => {:on_delete => :nullify}
      t.references :service_inventory, :index => true, :null => true, :foreign_key => {:on_delete => :nullify}

      t.index      :tenant_id
    end

    create_table :service_offering_nodes do |t|
      t.references :tenant, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :source, :index => false, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :service_inventory, :index => true, :null => true, :foreign_key => {:on_delete => :nullify}
      t.references :service_offering, :index => true, :null => true, :foreign_key => {:on_delete => :nullify}
      t.references :root_service_offering, :index => true, :null => true,
                   :foreign_key => {:on_delete => :nullify, :to_table => 'service_offerings'}

      t.string :source_ref, :null => false
      t.string :name

      t.jsonb :extra

      t.datetime   :resource_timestamp
      t.jsonb      :resource_timestamps, :default => {}
      t.datetime   :resource_timestamps_max

      t.timestamps
      t.datetime   :archived_at, :index => true
      t.datetime   :source_created_at
      t.datetime   :source_updated_at
      t.datetime   :last_seen_at, :index => true

      t.index %i[source_id source_ref], :unique => true
    end

    create_table :service_plans do |t|
      t.references :source, :index => false, :null => false, :foreign_key => {:on_delete => :cascade}
      t.string :source_ref, :null => false
      t.string :name
      t.text   :description

      t.references :service_offering, :type => :bigint, :index => true
      t.jsonb :extra
      t.timestamps

      t.datetime :source_deleted_at, :index => true
      t.bigint   :tenant_id, :null => false
      t.datetime :source_created_at
      t.jsonb    :create_json_schema
      t.jsonb    :update_json_schema
      t.datetime :archived_at, :index => true
      t.datetime :resource_timestamp
      t.jsonb    :resource_timestamps, :default => {}
      t.datetime :resource_timestamps_max
      t.datetime :last_seen_at, :index => true

      t.index %i[source_id source_ref], :unique => true
    end

    create_table :tags do |t|
      t.references :tenant, :type => :bigint, :index => false, :null => false, :foreign_key => {:on_delete => :cascade}

      t.string "name", :null => false
      t.string "namespace", :default => '', :null => false
      t.text "description"
      t.datetime "created_at", :null => false

      t.string :value, :null => false, :default => ""
      t.datetime :last_seen_at, :index => true
      t.index ["tenant_id", "namespace", "name"], :unique => true
    end

    create_table :service_inventory_tags do |t|
      t.references :tenant, :type => :bigint, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :tag, :index => false, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :service_inventory, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}

      t.datetime :last_seen_at, :index => true
      t.index %i[tag_id service_inventory_id], :unique => true, :name => "service_inventories_tags_unique_index"
    end

    create_table :service_offering_tags do |t|
      t.references :tenant, :type => :bigint, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :tag, :type => :bigint, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}

      t.datetime :last_seen_at, :index => true
      t.references :service_offering, :type => :bigint, :index => false, :null => false, :foreign_key => {:on_delete => :cascade}
      t.index [:service_offering_id, :tag_id], :name => "uniq_index_on_service_offering_id_tag_id", :unique => true
    end

    create_table :service_instance_service_credentials do |t|
      t.references :tenant, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :service_credential, :null => false, :index => false, :foreign_key => {:on_delete => :cascade}
      t.references :service_instance, :null => false, :index => false, :foreign_key => {:on_delete => :cascade}

      t.timestamps

      t.datetime :last_seen_at

      t.index %i[service_instance_id], :name => :index_service_instance_credentials_on_service_instance_id
      t.index %i[last_seen_at]
      t.index %i[service_credential_id service_instance_id], :unique => true, :name => :index_service_instance_credential_id
    end

    create_table :service_instance_node_service_credentials do |t|
      t.references :tenant, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :service_credential, :null => false, :index => false, :foreign_key => {:on_delete => :cascade}
      t.references :service_instance_node, :null => false, :index => false, :foreign_key => {:on_delete => :cascade}

      t.timestamps

      t.datetime :last_seen_at

      t.index %i[service_instance_node_id], :name => :index_instance_node_credentials_on_service_offering_id
      t.index %i[last_seen_at]
      t.index %i[service_credential_id service_instance_node_id], :unique => true, :name => :index_service_instance_node_credential_id
    end

    create_table :service_offering_node_service_credentials do |t|
      t.references :tenant, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :service_credential, :null => false, :index => false, :foreign_key => {:on_delete => :cascade}
      t.references :service_offering_node, :null => false, :index => false, :foreign_key => {:on_delete => :cascade}

      t.timestamps

      t.datetime :last_seen_at

      t.index %i[service_offering_node_id], :name => :index_offering_node_credentials_on_service_offering_id
      t.index %i[last_seen_at]
      t.index %i[service_credential_id service_offering_node_id], :unique => true, :name => :index_service_offering_node_credential_id
    end

    create_table :service_offering_service_credentials do |t|
      t.references :tenant, :index => true, :null => false, :foreign_key => {:on_delete => :cascade}
      t.references :service_credential, :null => false, :index => false, :foreign_key => {:on_delete => :cascade}
      t.references :service_offering, :null => false, :index => false, :foreign_key => {:on_delete => :cascade}

      t.timestamps

      t.datetime :last_seen_at

      t.index %i[service_offering_id], :name => :index_service_offering_credentials_on_service_offering_id
      t.index %i[last_seen_at]
      t.index %i[service_credential_id service_offering_id], :unique => true, :name => :index_service_offering_credential_id
    end

    create_table :tasks do |t|
      t.string :name
      t.string :status
      t.string :state
      t.jsonb :context
      t.references :tenant, :index => true, :null => false
      t.datetime :completed_at
      t.timestamps
      t.string :target_source_ref, :null => true
      t.string :target_type, :null => true
      t.jsonb :forwardable_headers

      t.references :source, :index => true, :null => true, :foreign_key => {:on_delete => :nullify}
      t.index %i[target_source_ref target_type]
    end
  end
end
