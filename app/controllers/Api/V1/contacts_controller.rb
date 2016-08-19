module Api
  module V1
    class ContactsController < ActionController::Base
      before_action :restrict_access, :except => [:new]
      skip_before_action :verify_authenticity_token


      def new

        error = false
        result = {}

        required_fields = ['email', 'first_name', 'last_name', 'phone']

        if params['type'] == 'contact'
          contact = Contact.where(email: params['email']).first
        elsif params['type'] == 'lead'
          contact = Lead.where(email: params['email']).first
        else
          return
        end

        if contact
          error = true
          result['error'] = 'Contact already exist'
          render json: result
          return
        end

        required_fields.each do |r|
          if !params["#{r}"] || params["#{r}"] =~ /^\s*$/
            error = true
            result['error'] = 'Missing information'
            render json: result
            return
          end
        end
        columns = Contact.column_names

        if params.length - columns.length > 10
          error = true
          result['error'] = 'Possible attack'
          render json: result
          return
        end

        if params['type'] == 'contact'
          contact = Contact.new
        else
          contact = Lead.new
        end

        params.each do |key, value|
          if columns.include? key
            contact.send("#{key}=".to_sym, value)
          end
          if columns.include? "cf_#{key}"
            contact.send("cf_#{key}=".to_sym, value)
          end
        end

        contact.status = 'new'

        contact.save

        if params['redirect']
          redirect_to params['redirect']
        else
          result['success'] = 'Contact was saved'
          render json: result
        end

      end



      def get_contact_housing
        contacts = Contact.where.not(cf_current_address: nil)
        respond_with do |format|
          format.csv { send_data Contact.to_csv(contacts) }
          format.json { render locals: {contacts: contacts} }

          # year = params(:year)
          # if year.nil?
          # else
          # end
        end
      end


      private
      def restrict_access
        authenticate_or_request_with_http_token do |token, options|
          user = User.find_by(api_token: token)
        end
      end

      # def find_contact(email)
      #   User.find_by(email: email)
      # end

    end
  end
end