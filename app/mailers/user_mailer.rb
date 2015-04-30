class UserMailer < ActionMailer::Base
  default from: "developer@trueinteraction.com"

	def contact(name, email, phone, text)
		@name = name
		@email = email
		@phone = phone
		@text = text
		mail(:to => "liam@trueinteraction.com", :subject => "Website Contact Form")
	end

	def contact_cms(name, email, phone)
		@name = name
		@email = email
		@phone = phone
		mail(:to => "liam@trueinteraction.com", :subject => "Website CMS Contact Form")
	end
end
