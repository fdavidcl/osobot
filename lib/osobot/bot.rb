require_relative "player"

module Osobot
  class Bot < Player
    def turn game
      puts "My turn!"

      minimax game, self, 3
      raise StandardError, "Something happened" if @choice.nil?
      @choice
    end

    def minimax game, next_player, max_depth, alpha = -1000, beta = 1000
      return game.score if max_depth == 0

      scores = [] # an array of scores
      moves = []  # an array of moves
      human = game.opponent == self ? game.player : game.opponent
      max_player = game.player

      game.get_available_moves.each do |move|
        possible_game = game.state_if next_player, *move
        score = minimax(possible_game, next_player == self ? human : self, max_depth - 1)
        scores << score
        moves << move
        if max_player == next_player
          alpha = score
        else
          beta = score
        end
        break if alpha >= beta
      end

      # Do the min or the max calculation
      if next_player == max_player
          # This is the max calculation
          max_score_index = scores.each_with_index.max[1]
          @choice = moves[max_score_index]
          return scores[max_score_index]
      else
          # This is the min calculation
          min_score_index = scores.each_with_index.min[1]
          @choice = moves[min_score_index]
          return scores[min_score_index]
      end
    end
  end
end
