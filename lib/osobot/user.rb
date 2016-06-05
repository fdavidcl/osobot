require_relative "player"

module Osobot
  class User < Player
    def turn game
      puts game

      print "Your move (letter) > "
      letter = gets[0].downcase
      while letter != "o" && letter != "s"
        puts "Only O or S allowed"
        print "Your move (letter) > "
        letter = gets[0].downcase
      end
      letter = letter == "o" ? O : S

      print "Your move (row) > "
      row = gets.chomp.to_i
      print "Your move (col) > "
      col = gets.chomp.to_i

      [row, col, letter]
    end
  end
end
