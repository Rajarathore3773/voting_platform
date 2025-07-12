module Admin
  class CandidatesController < ApplicationController
    def new
      @election = Election.find(params[:election_id])
      @candidate = Candidate.new
    end

    def create
      @election = Election.find(candidate_params[:election_id])
      @candidate = @election.candidates.build(name: candidate_params[:name])
      if @candidate.save
        redirect_to admin_elections_path, notice: 'Candidate added!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def candidate_params
      params.require(:candidate).permit(:name, :election_id)
    end
  end
end
