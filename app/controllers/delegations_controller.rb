class DelegationsController < ApplicationController
  def new
    @election = Election.find(params[:election_id])
    @users = User.where.not(id: User.first.id) # Exclude self
    @delegation = Delegation.new
  end

  def create
    @delegation = Delegation.new(delegation_params)
    @delegation.delegator = User.first # For demo
    if @delegation.save
      redirect_to delegations_path(election_id: @delegation.election_id), notice: 'Delegation set!'
    else
      @election = @delegation.election
      @users = User.where.not(id: User.first.id)
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @election = Election.find(params[:election_id])
    @delegations = Delegation.where(election: @election)
    @users = User.all.index_by(&:id)
  end

  private

  def delegation_params
    params.require(:delegation).permit(:election_id, :delegate_id)
  end
end
