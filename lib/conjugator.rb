require "conjugator/version"

require "mojinizer"
require_relative "jay_verb"

module Conjugator
  class Error < StandardError; end
end

def Conjugator(spelling, reading) # rubocop:disable Naming/MethodName
  JayVerb.new(spelling, reading)
end
