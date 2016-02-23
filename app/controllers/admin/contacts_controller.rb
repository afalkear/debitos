module Admin
  class ContactsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    def index
     super
     page = params[:page] || 1
     @resources = Contact.all.paginate(page: page)
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Contact.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
