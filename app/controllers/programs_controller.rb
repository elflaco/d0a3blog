# encoding: UTF-8
class ProgramsController < ApplicationController

  def index
    @programs = Program.all.order("id ASC").paginate(page: params[:page])
  end

  def new
    @program = Program.new
  end

  def create
    @program = Program.new(program_params)
    if @program.save
      flash[:success] = 'Creación exitosa'
      redirect_to @program
    else
      render 'new'
    end
  end

  def show
    @lecture = 1
    @program = Program.find(params[:id])
    @exercises = @program.program_relations.where( :lecture => @lecture )
  end

  def edit
    @program = Program.find(params[:id])
  end

  def update
    @program = Program.find(params[:id])
    if @program.update_attributes(program_params)
      flash[:success] = "Actualización exitosa"
      redirect_to @program
    else
      render 'edit'
    end
  end

  def destroy
    flash[:success] = 'Programa borrado'
    Program.find(params[:id]).destroy
    redirect_to programs_path
  end

  private

    def program_params
      params.require(:program).permit(:min_age, :max_age, :lectures, :name, :description )
    end

end