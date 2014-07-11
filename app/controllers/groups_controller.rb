# encoding: UTF-8
class GroupsController < ApplicationController
	
	# helper_method :valid_user
	# before_action :correct_user, only: [:edit, :update, :show, :new, :create, :destroy, :delete]
	load_and_authorize_resource except: [:create]
	# check_authorization

	def index
		if params[:filter]
			@groups = Group.where("finish_date <= :start_date", { start_date: Date.today }).paginate(page: params[:page])
		else
			@groups = Group.where("finish_date >= :start_date", { start_date: Date.today }).paginate(page: params[:page])
		end
	end

	def create
		@group = Group.new(group_params)
		if @group.save
			flash[:success] = "Creación Exitosa"
			redirect_to @group
		else
			render 'new'
		end
	end

	def admin
		@group = Group.find(params[:id])
		@lecture = @group.lectures.first
	end

	def new
		@group = Group.new
	end

	def edit
		@group = Group.find(params[:id])
	end

	def show
		@group = Group.find(params[:id])
		@lecture = @group.lectures.where( "date >= :start_date", { start_date: Date.today }).order('date ASC').first
		if !@lecture
			@lecture = @group.lectures.where( "date <= :start_date", { start_date: Date.today }).order('date DESC').first
		end
		if params[:lecture]
			@lecture = @group.lectures.find(params[:lecture])
		end
	end

	def update
		@group = Group.find(params[:id])
		if @group.update_attributes(group_params)
			flash[:success] = "Actualización Exitosa"
			redirect_to @group
		else
			render 'edit'
		end
	end

	def destroy
		flash[:success] = "Grupo Borrado"
		group = Group.find(params[:id])
		group.destroy
		redirect_to groups_path
	end

	def lecture
		@lecture = Lecture.new(lecture_params)
		if @lecture.save
			@new_lecture = true
		else
			@new_lecture = false
		end
	end

	def calendar
		@lecture = Lecture.find(params[:lecture_id])
		@init_time = @lecture.date.to_time
		new_date = "#{params[:new_date].to_date} #{@init_time}".to_datetime
		@group = @lecture.group
		if @lecture.date >= Date.today.beginning_of_day
			if (new_date < Date.today.to_datetime)
				@message = "Error: Sólo puedes cambiar la clase a días después de hoy"
			else
				lectures_in_day = @group.lectures.where(date: new_date.beginning_of_day..new_date.end_of_day)
				if lectures_in_day.count>0
					@message = "Error: Este día ya tiene una clase asignada" 
				else
					@lecture.date = new_date
					if @lecture.save
						@message = "Actualización exitosa"
					else
						@message = "Error: No se pudo guardar el cambio"
					end
				end
			end
		else
			@message = "Error: Esta clase ya ha sido dada, no puede moverse"
		end
		render :json => @message
	end

	def relations
		@group = Group.find(params[:id])
		@lecture = Lecture.find(params[:lecture_id])
	end

	private

		def group_params
			params.require(:group).permit(:name, :user_id, :assistant_id, :location, :cost, :min_age, :max_age, :init_date, :finish_date)
		end

		def lecture_params
			params.require(:lecture).permit( :date, :group_id, :observation, :objective )
		end

	protected

	    def correct_user
			redirect_to(:back, notice: "No tienes permitido crear, editar o borrar grupos.") unless valid_user
		end

		def valid_user
			current_user.admin? || current_user.instructor?
		end

end