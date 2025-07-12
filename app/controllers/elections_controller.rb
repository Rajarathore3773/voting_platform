
class ElectionsController < ApplicationController
  before_action :set_election, only: [:show, :ballot, :submit_ballot, :results, :ballot_success]

  def show
  end

  def ballot
    @candidates = @election.candidates.order(:id)
  end

  def submit_ballot
    user = User.first
    rankings = Array(params[:rankings]).map(&:to_i) # rankings is now just an array of candidate IDs
    
    # Validate rankings
    if rankings.empty? || rankings.uniq.length != rankings.length
      redirect_to ballot_election_path(@election), alert: 'Please rank all candidates uniquely'
      return
    end
    
    # Check if user already voted
    if @election.ranked_ballots.exists?(user: user)
      redirect_to ballot_election_path(@election), alert: 'You have already voted in this election'
      return
    end
    
    RankedBallot.create!(user: user, election: @election, rankings: rankings)
    
    # Clear cache in background to avoid blocking the response
    Thread.new do
      @election.clear_irv_cache!
    end
    
    redirect_to ballot_success_election_path(@election), notice: 'Your vote has been submitted successfully!'
  end

  def ballot_success
    # Simple success page without expensive calculations
  end

  def results
    @candidates = @election.candidates.index_by(&:id)
    @ballots = @election.ranked_ballots
    @irv = @election.cached_instant_runoff_results_with_delegation

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(@irv), filename: "election-#{@election.id}-results.csv" }
      format.json { render json: @irv }
    end
  end

  private

  def set_election
    @election = Election.find(params[:id])
  end

  def generate_csv(irv)
    CSV.generate do |csv|
      csv << ["Round", "Candidate", "Votes", "Eliminated", "Winner"]
      irv[:rounds].each_with_index do |round, i|
        round[:tally].each do |cid, votes|
          csv << [i+1, @candidates[cid]&.name, votes, (round[:eliminated] == cid ? 'Yes' : ''), (round[:winner] == cid ? 'Yes' : '')]
        end
      end
    end
  end
end
