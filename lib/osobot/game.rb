module Osobot
  class Game
    def initialize size, player, opponent
      @board = Array.new(size, Array.new(size))
      @player = player
      @opponent = opponent
      @score = 0
      @turn_first = true
    end

    attr_reader :board, :score, :player, :opponent

    def can_place? i, j
      board[i][j].nil?
    end

    def place who, i, j, letter
      if can_place? i, j
        board[i][j] = letter
        @score = score_if who, i, j, letter
      end

      turn_first = !turn_first

      if turn_first
        player.turn
      else
        opponent.turn
      end
    end

    def score_if who, i, j, letter
      sign = who == player ? 1 : -1

      difference = 0

      # Allow board wrap
      directions, amplitude = if letter == S
        [ [[1, 1], [1, 0], [1, -1], [0, 1]], 1 ]
      else
        [ [1, 0, -1].product [1, 0, -1], 2 ]
      end

      directions.each do |direction|
        start_i = i - amplitude * direction[0]
        start_j = j - amplitude * direction[1]
        difference += sign if check_oso direction, start_i, start_j
      end

      score + difference
    end

    private
    def check_oso direction, start_i, start_j
      board[i][j] == O &&
      board[i + direction[0]][j + direction[1]] == S &&
      board[i + 2 * direction[0]][j + 2 * direction[1]] == O
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
