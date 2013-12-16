FactoryGirl.define do
	factory :user do
		name "David Stanke"
		email "dstanke@home.com"
		password "foobar"
		password_confirmation "foobar"
	end
end
