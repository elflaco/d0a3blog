class Lesson < ActiveRecord::Base

	has_many :program_relations
	has_many :exercises, through: :program_relations #, :dependent => :restrict_with_error
	belongs_to :program

	validates_uniqueness_of :program_id, :scope => :order_day

end