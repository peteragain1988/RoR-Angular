class InitialDbSetup < ActiveRecord::Migration
  def up
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    enable_extension "hstore"
    enable_extension "uuid-ossp"

    create_enum("inventorystatus", ["created", "client_released", "employee_released", "inventoryArchived", "inventoryCreated"])
    create_enum("ehticketstatus", ["unavailable", "transiting", "available", "released", "cancelled"])
    create_enum("eventstatus", ["Coming Soon", "Open", "Closing Soon", "Closed"])
  end

  def down
    throw ActiveRecord::IrreversibleMigration
  end
end

