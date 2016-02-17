class AppMailer < ApplicationMailer
  default from: "lereseauphilanthropos@gmail.com"

  def contact_user_mail user, sender, message 
    @user = user
    @message = message
    @sender = sender
    @promo = sender.promo == 0 ? 'Institut' : sender.promo
    mail(to: @user.email, subject: "Nouveau message de #{sender.get_pre_nom_and_nom} (Promo #{@promo}) - LE RÉSEAU PHILANTHROPOS", cc: sender.email)
  end

end
