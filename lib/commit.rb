require 'footer'

class Commit
  attr_accessor :type, :scope, :breaking, :subject, :body
  attr_reader :footer

  def initialize
    @footer = Footer.new
  end

  def inspect
    "#<Commit type: #{type}, subject: #{subject}>"
  end
end
