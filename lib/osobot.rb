require "osobot/version"

module Osobot
  # Your code goes here...
  O = :o
  S = :s
end

Dir[__dir__ + '/osobot/*.rb'].each { |file| require file }
