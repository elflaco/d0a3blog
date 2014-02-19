# encoding: UTF-8
class SpotsController < ApplicationController

	def index
		@group = Group.find(params[:group_id])
		@spots = @group.spots
	end

	def create
		@group = Group.find(params[:group_id])
		person = Person.find(params[:child_id])
		tutor = person.family_relations.first.family.responsible_id
		@spot = @group.spots.build( child_id: person.id, tutor_id: tutor, group_id: params[:group_id] )
		@group.save
	end

	def new
		@group = Group.find(params[:group_id])
		today = Date.today
		min_weeks = today-(@group.min_age).weeks
		max_weeks = today-(@group.max_age).weeks
		@childs = Person.where(dob: max_weeks..min_weeks)
	end

	def edit
		@group = Group.find(params[:group_id])
		@spot = @group.spots.find(params[:id])
	end

	def show
		@group = Group.find(params[:group_id])
		@spot = Spot.find(params[:id])
	end

	def update
		@group = Group.find(params[:group_id])
		@spot = Spot.find(params[:id])
	    if @spot.update_attributes(lecture_params)
	    	flash[:success] = "Actualización Exitosa"
	    	redirect_to @group
	    else
	    	render 'edit'
	    end
	end

	def destroy
		spot = Spot.find(params[:id])
		@group = Group.find(params[:group_id])
		@child = spot.child
		Spot.find(params[:id]).destroy
		#flash[:success] = "Spot borrado"
		#redirect_to new_group_spot_path(@group)
	end

	def search
		@group = Group.find(params[:group_id])
		@childs = Person.children.text_search(params[:query].downcase)
	end

	private

	def lecture_params
		params.require(:spot).permit( :child_id, :tutor_id, :group_id)
	end

end