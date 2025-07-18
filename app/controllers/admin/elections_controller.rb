module Admin
  class ElectionsController < ApplicationController
    def index
      @elections = Election.order(created_at: :desc)
    end

    def new
      @election = Election.new
    end

    def create
      @election = Election.new(election_params)
      if @election.save
        redirect_to admin_elections_path, notice: 'Election created successfully!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @election = Election.find(params[:id])
      @candidates = @election.candidates
    end

    def edit
      @election = Election.find(params[:id])
    end

    def update
      @election = Election.find(params[:id])
      if @election.update(election_params)
        redirect_to admin_elections_path, notice: 'Election updated successfully!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @election = Election.find(params[:id])
      @election.destroy
      redirect_to admin_elections_path, notice: 'Election deleted.'
    end

    private

    def election_params
      params.require(:election).permit(:title, :description, :start_time, :end_time)
    end
  end
end
