class RegistrationsController < Devise::RegistrationsController
  def update_resource(resource, params)
    if resource.encrypted_password.blank? || params[:password].blank?
      resource.email = params[:email] if params[:email]
      if !params[:password].blank? && params[:password] == params[:password_confirmation]
        logger.info "Updating password"
        resource.password = params[:password]
        resource.save
      end
      if resource.valid?
        resource.update_without_password(params)
      end
    else
      resource.update_with_password(params)
    end
  end

  protected
  def sign_up_params
    allow = [:email, :password, :password_confirmation, :current_password, :name, :phone, :sms_notification, :shouts_notification, :daily_notification, :weekly_notification]
    params.require(resource_name).permit(allow)
  end

  def account_update_params
    sign_up_params
  end
end