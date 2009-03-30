class User < ActiveRecord::Base
  #acts_as_authentic do |c|
  #  c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  #end # block optional  
  acts_as_authentic# :crypto_provider => Authlogic::CryptoProviders::BCrypt
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end  
end
