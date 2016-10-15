# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150318004252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_enum("inventorystatus", ["created", "client_released", "employee_released", "inventoryArchived", "inventoryCreated"])
  create_enum("ehticketstatus", ["unavailable", "transiting", "available", "released", "cancelled"])
  create_enum("eventstatus", ["Coming Soon", "Open", "Closing Soon", "Closed"])
  create_enum("eh_request_status", ["pending", "approved", "rejected"])

  create_table "approval_paths", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.datetime "created_at", default: '2015-03-20 10:40:10', null: false
    t.datetime "updated_at", default: '2015-03-20 10:40:10', null: false
    t.string   "path",                                                    array: true
  end

  create_table "clients_companies", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "company_id",                                 null: false
    t.uuid     "client_id",                                  null: false
    t.datetime "created_at", default: '2015-03-20 10:40:08', null: false
  end

  add_index "clients_companies", ["client_id"], name: "index_clients_companies_on_client_id", using: :btree
  add_index "clients_companies", ["company_id"], name: "index_clients_companies_on_company_id", using: :btree

  create_table "companies", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "manager_id"
    t.string   "name",          limit: 150,                                 null: false
    t.string   "friendly_name", limit: 150,                                 null: false
    t.string   "company_type",              default: "company"
    t.json     "address",                   default: {}
    t.json     "contact",                   default: {}
    t.json     "modules",                   default: {}
    t.json     "notifications",             default: {}
    t.datetime "created_at",                default: '2015-03-20 10:40:08', null: false
    t.datetime "updated_at",                default: '2015-03-20 10:40:08', null: false
    t.json     "config",                    default: {}
  end

  add_index "companies", ["manager_id"], name: "index_companies_on_manager_id", using: :btree

  create_table "companies_facilities", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid      "company_id",                  null: false
    t.uuid      "facility_id",                 null: false
    t.tstzrange "lease_period",                null: false
    t.boolean   "is_enabled",   default: true, null: false
    t.uuid      "owner_id"
  end

  add_index "companies_facilities", ["company_id"], name: "index_companies_facilities_on_company_id", using: :btree
  add_index "companies_facilities", ["facility_id"], name: "index_companies_facilities_on_facility_id", using: :btree
  add_index "companies_facilities", ["lease_period"], name: "index_companies_facilities_on_lease_period", using: :btree

  create_table "confirmed_options", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "client_id",                                    null: false
    t.text     "notes"
    t.json     "selection"
    t.datetime "created_at",   default: '2015-03-20 10:40:08', null: false
    t.uuid     "inventory_id",                                 null: false
    t.text     "host_details"
    t.json     "guests",       default: [],                    null: false
    t.boolean  "is_attending", default: false,                 null: false
    t.json     "data",         default: {},                    null: false
    t.datetime "deleted_at"
  end

  add_index "confirmed_options", ["client_id"], name: "index_confirmed_options_on_client_id", using: :btree
  add_index "confirmed_options", ["deleted_at"], name: "index_confirmed_options_on_deleted_at", using: :btree
  add_index "confirmed_options", ["inventory_id"], name: "index_confirmed_options_on_inventory_id", using: :btree

  create_table "departments", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "manager_id",                                             null: false
    t.uuid     "company_id",                                             null: false
    t.string   "name",       limit: 150,                                 null: false
    t.datetime "created_at",             default: '2015-03-20 10:40:08', null: false
    t.datetime "updated_at",             default: '2015-03-20 10:40:08', null: false
  end

  create_table "download_tickets_statuses", force: true do |t|
    t.uuid   "inventory_id"
    t.uuid   "client_id"
    t.string "status"
  end

  create_table "employees", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "company_id"
    t.uuid     "department_id"
    t.uuid     "approval_path_id"
    t.string   "email",            limit: 175,                                 null: false
    t.json     "permissions",                  default: {},                    null: false
    t.string   "password_digest",  limit: 60
    t.datetime "created_at",                   default: '2015-03-20 10:40:08', null: false
    t.datetime "updated_at",                   default: '2015-03-20 10:40:08', null: false
    t.string   "otp_secret",       limit: 16
    t.json     "config",                       default: {},                    null: false
  end

  add_index "employees", ["company_id"], name: "index_employees_on_company_id", using: :btree
  add_index "employees", ["email"], name: "index_employees_on_email", unique: true, using: :btree

  create_table "event_dates", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid      "event_id",                                     null: false
    t.string    "status"
    t.datetime  "created_at",   default: '2015-03-20 10:40:08', null: false
    t.datetime  "updated_at",   default: '2015-03-20 10:40:08', null: false
    t.tstzrange "event_period",                                 null: false
    t.json      "uploads",      default: {},                    null: false
    t.json      "data",         default: {},                    null: false
  end

  add_index "event_dates", ["event_id"], name: "index_event_dates_on_event_id", using: :btree
  add_index "event_dates", ["event_period"], name: "index_event_dates_on_event_period", using: :btree

  create_table "events", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string      "name",                                        null: false
    t.text        "description"
    t.string      "event_type"
    t.string      "category"
    t.uuid        "company_id"
    t.eventstatus "status",                                      null: false
    t.datetime    "created_at",  default: '2015-03-20 10:40:09', null: false
    t.datetime    "updated_at",  default: '2015-03-20 10:40:09', null: false
    t.json        "data",        default: {},                    null: false
    t.json        "uploads",     default: {},                    null: false
  end

  add_index "events", ["company_id"], name: "index_events_on_company_id", using: :btree

  create_table "facilities", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "facility_type", limit: 150,                                 null: false
    t.string   "name",          limit: 150,                                 null: false
    t.uuid     "company_id",                                                null: false
    t.integer  "capacity",                  default: 0,                     null: false
    t.datetime "created_at",                default: '2015-03-20 10:40:09', null: false
    t.datetime "updated_at",                default: '2015-03-20 10:40:09', null: false
  end

  add_index "facilities", ["company_id"], name: "index_facilities_on_company_id", using: :btree

  create_table "guests", id: :uuid, default: "uuid_generate_v1()", force: true do |t|
    t.uuid     "company_id"
    t.string   "encrypted_email"
    t.string   "encrypted_first_name"
    t.string   "encrypted_last_name"
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guests", ["company_id"], name: "index_guests_on_company_id", using: :btree

  create_table "inventory", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid            "event_date_id",                                 null: false
    t.uuid            "facility_id",                                   null: false
    t.uuid            "company_id",                                    null: false
    t.uuid            "client_id",                                     null: false
    t.inventorystatus "status"
    t.integer         "total",         default: 0,                     null: false
    t.integer         "remaining",     default: 0,                     null: false
    t.integer         "taken",         default: 0,                     null: false
    t.integer         "reserved",      default: 0,                     null: false
    t.datetime        "created_at",    default: '2015-03-20 10:40:09', null: false
    t.datetime        "updated_at",    default: '2015-03-20 10:40:09', null: false
    t.json            "options",       default: {},                    null: false
  end

  add_index "inventory", ["client_id"], name: "index_inventory_on_client_id", using: :btree
  add_index "inventory", ["company_id"], name: "index_inventory_on_company_id", using: :btree
  add_index "inventory", ["event_date_id"], name: "index_inventory_on_event_date_id", using: :btree
  add_index "inventory", ["facility_id"], name: "index_inventory_on_facility_id", using: :btree
  add_index "inventory", ["status"], name: "index_inventory_on_status", using: :btree

  create_table "inventory_releases", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "inventory_id",                            null: false
    t.uuid     "client_id",                               null: false
    t.uuid     "venue_id",                                null: false
    t.uuid     "department_id"
    t.integer  "total_released_count",                    null: false
    t.integer  "total_open_count",                        null: false
    t.integer  "total_approved_count",    default: 0,     null: false
    t.integer  "total_requested_count",   default: 0,     null: false
    t.string   "event_class"
    t.boolean  "catering_included",       default: false, null: false
    t.integer  "catering_value_cents",    default: 0,     null: false
    t.string   "catering_value_currency", default: "AUD", null: false
    t.json     "data",                    default: {},    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inventory_releases", ["client_id"], name: "index_inventory_releases_on_client_id", using: :btree
  add_index "inventory_releases", ["department_id"], name: "index_inventory_releases_on_department_id", using: :btree
  add_index "inventory_releases", ["inventory_id"], name: "index_inventory_releases_on_inventory_id", using: :btree
  add_index "inventory_releases", ["venue_id"], name: "index_inventory_releases_on_venue_id", using: :btree

  create_table "mail_templates", id: :uuid, default: "uuid_generate_v1()", force: true do |t|
    t.uuid     "company_id",                 null: false
    t.boolean  "partial",    default: false
    t.boolean  "editable",   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                       null: false
    t.string   "handler"
    t.string   "path"
    t.string   "format"
    t.string   "locale"
    t.text     "body"
    t.json     "data"
  end

  add_index "mail_templates", ["company_id"], name: "index_mail_templates_on_company_id", using: :btree

  create_table "profiles", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "first_name",  limit: 50,                                 null: false
    t.string   "last_name",   limit: 50,                                 null: false
    t.string   "sex",                                                    null: false
    t.date     "dob"
    t.datetime "created_at",             default: '2015-03-20 10:40:09', null: false
    t.datetime "updated_at",             default: '2015-03-20 10:40:09', null: false
    t.uuid     "employee_id"
    t.string   "klass",       limit: 4
  end

  add_index "profiles", ["employee_id"], name: "index_profiles_on_employee_id", using: :btree

  create_table "released_inventory_requests", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "inventory_release_id",                 null: false
    t.uuid     "requester_id",                         null: false
    t.uuid     "approval_path_id",                     null: false
    t.uuid     "last_approver_id"
    t.uuid     "next_approver_id"
    t.uuid     "strategic_reason_id",                  null: false
    t.integer  "total_attendee_count",                 null: false
    t.integer  "approved_attendee_count", default: 0,  null: false
    t.integer  "rejected_attendee_count", default: 0,  null: false
    t.json     "data",                    default: {}, null: false
    t.date     "next_reminder_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "released_inventory_requests", ["approval_path_id"], name: "index_released_inventory_requests_on_approval_path_id", using: :btree
  add_index "released_inventory_requests", ["inventory_release_id"], name: "index_released_inventory_requests_on_inventory_release_id", using: :btree
  add_index "released_inventory_requests", ["last_approver_id"], name: "index_released_inventory_requests_on_last_approver_id", using: :btree
  add_index "released_inventory_requests", ["next_approver_id"], name: "index_released_inventory_requests_on_next_approver_id", using: :btree
  add_index "released_inventory_requests", ["requester_id"], name: "index_released_inventory_requests_on_requester_id", using: :btree
  add_index "released_inventory_requests", ["strategic_reason_id"], name: "index_released_inventory_requests_on_strategic_reason_id", using: :btree

  create_table "request_attendances", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid              "released_inventory_request_id",                 null: false
    t.uuid              "partner_with"
    t.uuid              "attendee_id",                                   null: false
    t.string            "attendee_type",                                 null: false
    t.eh_request_status "status",                                        null: false
    t.boolean           "is_host",                       default: false, null: false
    t.datetime          "created_at"
    t.datetime          "updated_at"
    t.json              "data"
  end

  add_index "request_attendances", ["attendee_id"], name: "index_request_attendances_on_attendee_id", using: :btree
  add_index "request_attendances", ["attendee_type"], name: "index_request_attendances_on_attendee_type", using: :btree
  add_index "request_attendances", ["is_host"], name: "index_request_attendances_on_is_host", using: :btree
  add_index "request_attendances", ["partner_with"], name: "index_request_attendances_on_partner_with", using: :btree
  add_index "request_attendances", ["released_inventory_request_id"], name: "index_request_attendances_on_released_inventory_request_id", using: :btree
  add_index "request_attendances", ["status"], name: "index_request_attendances_on_status", using: :btree

  create_table "tickets", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid           "event_date_id"
    t.uuid           "facility_id"
    t.uuid           "inventory_id"
    t.uuid           "client_id"
    t.json           "storage",          default: {},                                                  null: false
    t.integer        "row"
    t.integer        "seat"
    t.string         "ticketek_id"
    t.datetime       "created_at"
    t.datetime       "updated_at"
    t.ehticketstatus "status",                                                                         null: false
    t.integer        "reference_number", default: "nextval('tickets_reference_number_seq'::regclass)", null: false
  end

  add_index "tickets", ["client_id"], name: "index_tickets_on_client_id", using: :btree
  add_index "tickets", ["event_date_id"], name: "index_tickets_on_event_date_id", using: :btree
  add_index "tickets", ["facility_id"], name: "index_tickets_on_facility_id", using: :btree
  add_index "tickets", ["inventory_id"], name: "index_tickets_on_inventory_id", using: :btree
  add_index "tickets", ["reference_number"], name: "index_tickets_on_reference_number", unique: true, using: :btree
  add_index "tickets", ["status"], name: "index_tickets_on_status", using: :btree
  add_index "tickets", ["ticketek_id"], name: "index_tickets_on_ticketek_id", unique: true, using: :btree

end
