class Election < ApplicationRecord
  has_many :candidates, dependent: :destroy
  has_many :ranked_ballots, dependent: :destroy
  has_many :delegations, dependent: :destroy

  validates :title, presence: true

  # Returns a hash: user_id => final delegate user_id (resolving chains)
  def delegation_map
    # Cache delegation map to avoid recalculating
    Rails.cache.fetch("election-#{id}-delegation-map", expires_in: 5.minutes) do
      ballot_user_ids = ranked_ballots.pluck(:user_id)
      delegation_user_ids = delegations.pluck(:delegator_id, :delegate_id).flatten.uniq
      relevant_user_ids = (ballot_user_ids + delegation_user_ids).uniq
      
      # Preload users to avoid N+1 queries
      users = User.where(id: relevant_user_ids).index_by(&:id)
      delegations_map = self.delegations.index_by(&:delegator_id)
      map = {}
      
      users.each_key do |uid|
        visited = Set.new
        current = uid
        while delegations_map[current] && !visited.include?(current)
          visited << current
          current = delegations_map[current].delegate_id
        end
        map[uid] = current
      end
      map
    end
  end

  def vote_weights
    map = delegation_map
    weights = Hash.new(0)
    map.each_value { |final| weights[final] += 1 }
    weights
  end

  def instant_runoff_results_with_delegation
    # Preload candidates and ballots to avoid N+1 queries
    candidate_ids = candidates.pluck(:id)
    ballots = ranked_ballots.includes(:user).group_by(&:user_id)
    weights = vote_weights
    rounds = []
    active = candidate_ids.dup
    total_votes = weights.values.sum

    return { rounds: [], winner: nil } if total_votes == 0

    loop do
      tally = Hash.new(0)
      weights.each do |uid, weight|
        ballot = ballots[uid]&.first
        next unless ballot
        first = ballot.rankings.find { |cid| active.include?(cid) }
        tally[first] += weight if first
      end
      
      round = {
        tally: tally.dup,
        eliminated: nil,
        active: active.dup
      }
      rounds << round
      
      # Check for winner
      tally.each do |cid, count|
        if count > total_votes / 2.0
          round[:winner] = cid
          return { rounds: rounds, winner: cid }
        end
      end
      
      # Eliminate candidate with least votes
      min_votes = tally.values.min
      to_eliminate = tally.select { |_, v| v == min_votes }.keys
      eliminated = to_eliminate.sample
      active.delete(eliminated)
      round[:eliminated] = eliminated
      
      if active.size == 1
        rounds << { 
          tally: { active.first => total_votes }, 
          eliminated: nil, 
          active: active.dup, 
          winner: active.first 
        }
        return { rounds: rounds, winner: active.first }
      end
      
      if active.empty?
        return { rounds: rounds, winner: nil }
      end
    end
  end

  # Caching methods with better cache keys
  def cached_instant_runoff_results_with_delegation
    cache_key = "election-#{id}-irv-results-#{ranked_ballots.count}-#{delegations.count}"
    Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      instant_runoff_results_with_delegation
    end
  end

  def clear_irv_cache!
    # Clear all related caches
    Rails.cache.delete_matched("election-#{id}-*")
  end
end
