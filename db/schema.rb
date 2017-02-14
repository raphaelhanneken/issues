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

ActiveRecord::Schema.define(version: 20_160_311_161_156) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'activities', force: :cascade do |t|
    t.integer  'trackable_id'
    t.string   'trackable_type'
    t.integer  'owner_id'
    t.string   'owner_type'
    t.string   'key'
    t.text     'parameters'
    t.integer  'recipient_id'
    t.string   'recipient_type'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'activities', %w(owner_id owner_type), name: 'index_activities_on_owner_id_and_owner_type', using: :btree
  add_index 'activities', %w(recipient_id recipient_type), name: 'index_activities_on_recipient_id_and_recipient_type', using: :btree
  add_index 'activities', %w(trackable_id trackable_type), name: 'index_activities_on_trackable_id_and_trackable_type', using: :btree

  create_table 'comments', force: :cascade do |t|
    t.text     'content'
    t.integer  'user_id'
    t.integer  'report_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_index 'comments', ['report_id'], name: 'index_comments_on_report_id', using: :btree
  add_index 'comments', ['user_id'], name: 'index_comments_on_user_id', using: :btree

  create_table 'labels', force: :cascade do |t|
    t.string   'title'
    t.string   'color'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'labels_reports', id: false, force: :cascade do |t|
    t.integer 'label_id',  null: false
    t.integer 'report_id', null: false
  end

  add_index 'labels_reports', %w(label_id report_id), name: 'index_labels_reports_on_label_id_and_report_id', unique: true, using: :btree
  add_index 'labels_reports', %w(report_id label_id), name: 'index_labels_reports_on_report_id_and_label_id', unique: true, using: :btree

  create_table 'projects', force: :cascade do |t|
    t.string   'name', null: false
    t.string   'version', default: ''
    t.datetime 'created_at',              null: false
    t.datetime 'updated_at',              null: false
  end

  create_table 'reports', force: :cascade do |t|
    t.string   'title',                       null: false
    t.text     'description',                 null: false
    t.integer  'project_id',                  null: false
    t.datetime 'created_at',                  null: false
    t.datetime 'updated_at',                  null: false
    t.integer  'reporter_id'
    t.integer  'assignee_id'
    t.boolean  'closed', default: false
  end

  add_index 'reports', ['assignee_id'], name: 'index_reports_on_assignee_id', using: :btree
  add_index 'reports', ['project_id'], name: 'index_reports_on_project_id', using: :btree
  add_index 'reports', ['reporter_id'], name: 'index_reports_on_reporter_id', using: :btree

  create_table 'users', force: :cascade do |t|
    t.string   'firstname',                              null: false
    t.string   'lastname',                               null: false
    t.boolean  'admin', default: false
    t.datetime 'created_at',                             null: false
    t.datetime 'updated_at',                             null: false
    t.string   'email',                  default: '',    null: false
    t.string   'encrypted_password',     default: '',    null: false
    t.string   'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer  'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string   'current_sign_in_ip'
    t.string   'last_sign_in_ip'
  end

  add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
  add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree
end
