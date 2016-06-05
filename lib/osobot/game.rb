module Osobot
  class Game
    def initialize size, player, opponent
      @board = Array.new(size) { Array.new(size) }
      @player = player
      @opponent = opponent
      @score = 0
      @turn_first = true
    end

    attr_reader :board, :score, :player, :opponent

    def start
      new_turn
    end

    def new_turn
      if @turn_first
        place player, *player.turn(self)
      else
        place opponent, *opponent.turn(self)
      end
    end

    def can_place? i, j
      board[i][j].nil?
    end

    def place who, i, j, letter
      if can_place? i, j
        board[i][j] = letter
        @score = score_if who, i, j, letter
      end

      @turn_first = !@turn_first

      if board.any?{ |row| row.any? &:nil? } # if there are moves left
        new_turn
      else
        if score > 0
          "Player 1 wins!"
        elsif score < 0
          "Player 2 wins!"
        else
          "It's a draw!"
        end
      end
    end

    def score_if who, i, j, letter
      sign = who == player ? 1 : -1

      difference = 0

      # Allow board wrap
      directions, amplitude = if letter == S
        [ [[1, 1], [1, 0], [1, -1], [0, 1]], 1 ]
      else
        all = [1, 0, -1].product([1, 0, -1])
        all.delete [0, 0]
        [ all, 2 ]
      end

      prev = board[i][j]
      board[i][j] = letter
      directions.each do |direction|
        start_i = (i - amplitude * direction[0]) % board.size
        start_j = (j - amplitude * direction[1]) % board.size
        difference += sign if check_oso direction, start_i, start_j
      end
      board[i][j] = prev

      score + difference
    end

    def to_s
      board_text = (0 ... board.size).map do |row|
        inner = board[row].map{ |e| e.nil? ? " " : e }.join(" ")
        "#{row} #{inner}\n"
      end.join

      "Current score: #{score}\n" +
      "  " + (0 ... board.size).to_a.join(" ") + "\n" + board_text
    end

    private
    def check_oso direction, i, j
      board[i][j] == O &&
      board[(i + direction[0]) % board.size][(j + direction[1]) % board.size] == S &&
      board[(i + 2 * direction[0]) % board.size][(j + 2 * direction[1]) % board.size] == O
    end

    # We could disallow wrap via something like this:
    def possible_scores x, y, letter
      directions = [1, 0, -1].product [1, 0, -1]
      directions.delete [0, 0]

      bound = letter == O ? 2 : 1

      if x < bound
        directions.delete [1, -1]
        directions.delete [0, -1]
        directions.delete [-1, -1]
      end
      if y < bound
        directions.delete [-1, 1]
        directions.delete [-1, 0]
        directions.delete [-1, -1]
      end
      if x >= size - bound
        directions.delete [1, 1]
        directions.delete [0, 1]
        directions.delete [-1, 1]
      end
      if y >= size - bound
        directions.delete [1, 1]
        directions.delete [1, 0]
        directions.delete [1, -1]
      end

      directions
    end
  end
end
