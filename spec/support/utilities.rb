include ApplicationHelper
def full_title(page_title)
	base_title = "Ruby on Rails Tutorial Sample"
	if page_title.empty?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end

def fillInfo(user)
	fill_in "Email", with: user.email
	fill_in "Password", with: user.password
end

def valid_signin(user)
	fillInfo(user)
	click_button "Sign in"
end

def sign_in(user)
	visit signin_path
	valid_signin(user)
	cookies[:remember_token] = user.remember_token
end


RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end
