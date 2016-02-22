require "administrate/base_dashboard"

class ContactDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    account: Field::BelongsTo,
    card_company: Field::String,
    id: Field::Number,
    name: Field::String,
    last_name: Field::String,
    identifier: Field::String,
    amount: Field::String.with_options(searchable: false),
    card_number: Field::String,
    card_type: Field::String,
    card_company: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    padma_id: Field::String,
    instructor: Field::String,
    plan: Field::String,
    due_date: Field::String,
    payed: Field::Boolean,
    payment: Field::String,
    observations: Field::String,
    bill: Field::String,
    active: Field::Boolean,
    new_debit: Field::Boolean,
    secret: Field::Text,
    secret_key: Field::String.with_options(searchable: false),
    secret_iv: Field::String.with_options(searchable: false),
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :account,
    :card_company,
    :id,
    :name,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :account,
    :card_company,
    :id,
    :name,
    :last_name,
    :identifier,
    :amount,
    :card_number,
    :card_type,
    :card_company,
    :created_at,
    :updated_at,
    :padma_id,
    :instructor,
    :plan,
    :due_date,
    :payed,
    :payment,
    :observations,
    :bill,
    :active,
    :new_debit,
    :secret,
    :secret_key,
    :secret_iv,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :account,
    :card_company,
    :name,
    :last_name,
    :identifier,
    :amount,
    :card_number,
    :card_type,
    :card_company,
    :padma_id,
    :instructor,
    :plan,
    :due_date,
    :payed,
    :payment,
    :observations,
    :bill,
    :active,
    :new_debit,
    :secret,
    :secret_key,
    :secret_iv,
  ]

  # Overwrite this method to customize how contacts are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(contact)
  #   "Contact ##{contact.id}"
  # end
end
