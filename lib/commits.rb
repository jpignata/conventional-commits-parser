class Commits
  include Enumerable

  def initialize
    @commits = []
  end

  def each(&block)
    @commits.each(&block)
  end

  def push(commit)
    @commits.push(commit)
  end

  def breaking_change?
    @commits.any?(&:breaking_change?)
  end

  def feat?
    @commits.any? { |commit| commit.type == :feat }
  end
end
