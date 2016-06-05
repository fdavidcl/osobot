require_relative "player"

module Osobot
  class NaiveBot < Player
    def turn game
      puts "My turn!"

      # Choose best inmediate movement
      movements = (0 ... game.board.size).to_a.product((0 ... game.board.size).to_a, [O, S])
      movements.min_by do |i, j, letter|
        if game.can_place? i, j
          game.score_if self, i, j, letter
        else
          Float::INFINITY
        end
      end
    end
  end
end
