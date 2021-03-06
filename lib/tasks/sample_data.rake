namespace :db do
	desc "fill database with sample data"
	task populate: :environment do
		User.create!(
			name: "Admin User",
			email: "admin@example.com",
			password: "password",
			password_confirmation: "password",
			admin: true
			)
		99.times do |n|
			name=Faker::Name.name
			email="user-#{n+1}@example.com"
			password="password"
			User.create!(
				name: name,
				email: email,
				password: password,
				password_confirmation: password
				)
		end
	end #task populate(environment)
end #namespace :db