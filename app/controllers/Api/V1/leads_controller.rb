module Api
  module V1
    class LeadsController < ActionController::Base
      before_action :restrict_access
      skip_before_action :verify_authenticity_token


      def get_leads
        leads = Lead.where.not(id: nil)

        respond_with do |format|
          format.csv { send_data Lead.to_csv(leads) }
          format.json { render locals: { leads: leads } }
        end
      end


      def new
        error = false
        result = {}

        required_fields = ['email', 'first_name', 'last_name', 'phone']

        lead = Lead.where(email: params['email']).first

        if lead
          error = true
          result['error'] = 'Lead already exist'
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
        columns = Lead.column_names

        if params.length - columns.length > 10
          error = true
          result['error'] = 'Possible attack'
          render json: result
          return
        end

        contact = Contact.new

        params.each do |key, value|
          if columns.include? key
            lead.send("#{key}=".to_sym, value)
          end
          if columns.include? "cf_#{key}"
            lead.send("cf_#{key}=".to_sym, value)
          end
        end

        lead.save

        if params['redirect']
          redirect_to params['redirect']
        else
          result['success'] = 'Lead was saved'
          render json: result
        end
      end

      def convert_lead
        lead_value = {}
        result = {}
        lead_value['email'] = params[:email]
        lead = {}
        lead = Lead.find_by(email: lead_value['email'])

        account = Account.create(
            name: lead.company,
            access: lead.access
        )

        contact = Contact.create(
            first_name: lead.first_name,
            last_name: lead.last_name,
            email: lead.email,
            phone: lead.phone,
            lead_id: lead.id
        )

        account_contact = AccountContact.create(
            account_id: account.id,
            contact_id: contact.id

        )

        if account.save! and contact.save! and account_contact.save!
          lead.destroy
          result[:lead_upgraded] = true
        else
          account.destroy
          contact.destroy
          account_contact.destroy
          result[:error] = 'lead failed to upgrade'
        end

        render json: result
      end


      private
      def restrict_access
        authenticate_or_request_with_http_token do |token, options|
          user = User.find_by(api_token: token)
        end
      end

    end
  end
end
