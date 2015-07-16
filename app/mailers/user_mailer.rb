class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(okr)
    @okr = okr
    mail(
      to: @okr.admin_email,
      subject: "Congratulations on creating your first OKR, #{@okr.admin_name}!"
      )
  end

  def review(okr)
    @okr = okr

    mail(
      to: "to@example.org",
      subject: "yolo"
      )
  end
end
