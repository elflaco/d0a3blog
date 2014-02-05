require 'spec_helper'

describe Group do
	
	let(:user) { FactoryGirl.create(:user) }

	before do
		@group = Group.new( name: "Primer Curso", user_id: user.id, cost: 123, init_date: '12/01/2014', finish_date: '12/02/2014', min_age: 3, max_age: 12, location: 'Aula uno' )
	end

	subject { @group }

	it { should respond_to(:name) }
	it { should respond_to(:user_id) }
	it { should respond_to(:cost) }
	it { should respond_to(:init_date) }
	it { should respond_to(:finish_date) }
	it { should respond_to(:location) }
	it { should respond_to(:min_age) }
	it { should respond_to(:max_age) }

	it { should be_valid }

	describe "when user_id is not present" do
		before { @group.user_id = nil }
		it { should_not be_valid }
	end

	describe "when invalid atribute" do
		before do
			@group.name = " "
			@group.cost = " "
			@group.init_date = " "
			@group.finish_date = " "
			@group.min_age = " "
			@group.max_age = " "
			@group.location = " "
		end

		it { should have(1).error_on(:name) }
		it { should have(1).error_on(:cost) }
		it { should have(1).error_on(:init_date) }
		it { should have(1).error_on(:finish_date) }
		it { should have(1).error_on(:min_age) }
		it { should have(1).error_on(:max_age) }
		it { should have(1).error_on(:location) }
	end

	describe "when name is too long" do
		before { @group.name = "a" * 61 }
		it { should_not be_valid }
	end

end