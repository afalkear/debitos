require "administrate/base_dashboard"

class CardCompanyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    responsible: Field::BelongsTo,
    contacts: Field::HasMany,
    id: Field::Number,
    establishment: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    name: Field::String,
    description: Field::String,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :responsible,
    :contacts,
    :id,
    :establishment,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :responsible,
    :contacts,
    :id,
    :establishment,
    :created_at,
    :updated_at,
    :name,
    :description,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :responsible,
    :contacts,
    :establishment,
    :name,
    :description,
  ]

  # Overwrite this method to customize how card companies are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(card_company)
  #   "CardCompany ##{card_company.id}"
  # end
end
