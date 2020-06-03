require 'footer'

class Commit
  attr_accessor :type, :scope, :breaking_change, :subject, :body
  attr_reader :footer

  def initialize
    @footer = Footer.new
  end

  def inspect
    "#<Commit type: #{type}, subject: #{subject}>"
  end

  def breaking_change?
    !breaking_change.nil?
  end
end
