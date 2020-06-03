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

  def breaking?
    @commits.any? { |commit| !commit.breaking.nil? }
  end

  def feat?
    @commits.any? { |commit| commit.type == :feat }
  end
end
