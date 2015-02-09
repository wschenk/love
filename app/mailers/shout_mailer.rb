class ShoutMailer < ApplicationMailer
  default from: "will@happyfuncorp.com"

  def welcome_sent_shout( user, current_shout )
    @user = user
    @current_shout = current_shout
    mail(to: @user.email, subject: "Welcome to Love")
  end

  def welcome_received_shout( user, current_shout )
    @user = user
    @current_shout = current_shout
    mail(to: @user.email, subject: "Getting some love")
  end

  def shout_message( user, current_shout )
    @user = user
    @current_shout = current_shout
    mail(to: @user.email, subject: "Getting some love")
  end
end
