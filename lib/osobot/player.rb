module Osobot
  class Player
    def initialize
      if !respond_to? :turn
        raise StandardError "Method :turn not implemented"
      end
    end
  end
end
