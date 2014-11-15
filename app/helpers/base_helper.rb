# encoding: utf-8
module BaseHelper

  # def current_user
  #   @current_user ||= get_user
  # end

  # def get_user
  #   if session[:user_id]
  #     user = User.confirmed.where(id: session[:user_id]).first
  #     if user
  #       return user
  #     else
  #       session[:user_id] = nil
  #       return nil
  #     end
  #   else
  #     nil
  #   end
  # end

  # def current_admin
  #   @current_admin ||= get_admin
  # end

  # def get_admin
  #   if session[:admin_id]
  #     admin = Administrator.where(id: session[:admin_id]).first
  #     if admin
  #       return admin
  #     else
  #       session[:admin_id] = nil
  #       return nil
  #     end
  #   else
  #     nil
  #   end
  # end

  # def filter_params(base_param, accept_params)
  #   base_param ||= {}
  #   handle_data "" if base_param.length > 100
  #   base_param.delete_if do |key, value|
  #     !accept_params.include?(key.to_sym)
  #   end
  #   base_param
  # end

  # def set_cookie(key, val, day=60)
  #   response.set_cookie \
  #     key, {
  #       value: val,
  #       path: '/',
  #       expires: Time.now + 24*60*day,
  #       http_only: true
  #     }
  # end

end
