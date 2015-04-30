class ContactController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def submit
		UserMailer.contact(params[:name], params[:phone], params[:email], params[:text]).deliver
		redirect_to "/"
	end

	def submit_cms
		UserMailer.contact_cms(params[:name], params[:phone], params[:email]).deliver
		redirect_to "/"
	end

end
