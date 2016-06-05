require_relative "player"

module Osobot
  class Bot < Player
    def turn game
      puts "My turn!"
      
      [1, 1, O]
    end
  end
end
