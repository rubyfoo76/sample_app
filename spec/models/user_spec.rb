require 'spec_helper'

describe User do
	before { @user = User.new(name:"Example User", email: "user@home.com", password: "foobar", password_confirmation: "foobar")}

	subject { @user }
	it { should respond_to(:name)}
	it { should respond_to(:email)}
	it { should respond_to(:password_digest)}
	it { should respond_to(:password)}
	it { should respond_to(:password_confirmation)}
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate)}

	it { should be_valid }

	describe "when name is not present should fail validation" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "when name is too long should fail validation" do
		before { @user.name = (('a'..'z').to_a * 2).shuffle.join[0..50] }
		it { should_not be_valid }
	end

	describe "when email is not present should fail validation" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should fail validation" do
			bad_addresses = [
				"user@foo,com",
				"user_at_foo.com",
				"example.user@foo.foo@bar_baz.com",
				"foo@bar+baz.com",
				"user@foo"
			]
			bad_addresses.each do |address|
				@user.email = address
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should pass validation" do
			good_addresses = [
				"user@foo.COM",
				"A_US-ER@f.b.org",
				"a+b@baz.cn"
			]
			good_addresses.each do |address|
				@user.email = address
				expect(@user).to be_valid
			end
		end
	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when password is blank" do
		before do
			@user = User.new(name: "Example user", email:"user@home.com", password:" ", password_confirmation: " ")
		end
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch!" }
		it { should_not be_valid }
	end	

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "12345"}
		it { should be_invalid }
	end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by(email: @user.email )}

		describe "with valid password" do
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { should_not eq user_for_invalid_password }
			specify { expect(user_for_invalid_password).to be_false }
		end
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

end









