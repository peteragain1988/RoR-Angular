types = %w(eventstatus ehticketstatus inventorystatus eh_request_status)

module PgEnum

  # provide the enum DDL methods
  module PostgreSQLAdapter
    def create_enum(name, values)
      values = values.map { |v| "'#{v}'" }
      execute "DROP TYPE IF EXISTS #{name}"
      execute "CREATE TYPE #{name} AS ENUM (#{values.join(', ')})"
    end

    def drop_enum(name)
      execute "DROP TYPE #{name} IF EXISTS"
    end
  end

  # provide support for writing out the 'create_enum' calls in schema.rb
  module SchemaDumper
    extend ActiveSupport::Concern

    included do
      alias_method_chain :tables, :enums
    end

    def tables_with_enums(stream)
      enums(stream)
      tables_without_enums(stream)
    end

    private
    def enums(stream)
      enums = @connection.select_all("SELECT typname FROM pg_type WHERE typtype = 'e'").map { |r| r['typname'] }

      statements = []

      enums.each do |enum|
        values = @connection.select_all(
            "SELECT e.enumlabel FROM pg_enum e JOIN pg_type t ON e.enumtypid = t.oid WHERE t.typname = '#{enum}'"
        ).map { |v| v['enumlabel'].inspect }.join(', ')

        statements << "  create_enum(#{enum.inspect}, [#{values}])"
      end

      stream.puts statements.join("\n")
      stream.puts
    end
  end
end


class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  include PgEnum::PostgreSQLAdapter
end

module ActiveRecord::ConnectionAdapters
  include PgEnum::PostgreSQLAdapter
end

class ActiveRecord::SchemaDumper
  include PgEnum::SchemaDumper
end

# make activerecord aware of our enum types

types.each { |type|
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[type.to_sym] = {name: type}

  ActiveRecord::ConnectionAdapters::Column.class_eval do

    define_method("simplified_type_with_#{type}") do |field_type|
      if field_type == type
        field_type.to_sym
      else
        send("simplified_type_without_#{type}", field_type)
      end
    end

    alias_method_chain :simplified_type, type
  end

  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::TableDefinition.class_eval do

    define_method(type) do |*args|
      options = args.extract_options!
      column(args[0], type, options)
    end
  end

  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID.alias_type type, 'text'

  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.tap do |clazz|
    clazz::OID.register_type(type, clazz::OID::Identity.new)
  end
}