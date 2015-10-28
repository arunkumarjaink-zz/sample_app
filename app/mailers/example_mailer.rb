class ExampleMailer < ActionMailer::Base
  default from: "priks2rhyme@gmail.com"

  def sample_email(user)
  	@user = user
  	mail(to: @user.email, subject: 'Sample Email')
  end

  def follow_email(user1,user2)
  	@user1 = user1
  	@user2 = user2
  	mail(to: @user1.email, subject: @user2.name)
  end

end