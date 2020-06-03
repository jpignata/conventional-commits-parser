require 'strscan'
require 'commit'

class Parser
  FOOTER_KEY = /(^[\w-]+: |^[\w-]+ #|^BREAKING CHANGES?: )/

  attr_reader :commit

  def initialize(msg)
    @breaking_change = false
    @commit = Commit.new
    @msg = StringScanner.new(msg.strip)
  end

  def parse
    read_type_and_scope
    read_subject
    read_body
    read_footer
  end

  private

  attr_reader :msg

  def read_type_and_scope
    commit.type = :change

    if msg.match?(/\w+(\([^\)]+\))?\!?: /)
      commit.type = msg.scan(/[^!:\(]+/).to_sym

      case msg.getch
      when '('
        commit.scope = msg.scan(/[^\)]+/)
        msg.skip_until(/\): /)
      when '!'
        breaking_change!
        msg.skip_until(/: /)
      when ':'
        msg.getch
      end
    end
  end

  def read_subject
    line = msg.scan(/[^\n]+/)
    commit.subject = line
    commit.breaking_change = line if breaking_change?
    msg.getch
  end

  def read_body
    commit.body = read_until_footer_key
  end

  def read_until_footer_key
    data = ''

    until (msg.match?(FOOTER_KEY) && msg.beginning_of_line?) || msg.eos?
      data << msg.getch
    end

    return data.strip
  end

  def read_footer
    return unless msg.check_until(FOOTER_KEY)

    while msg.rest?
      key = msg.scan_until(FOOTER_KEY)
      value = read_until_footer_key

      if key.match?(/BREAKING CHANGE/)
        commit.breaking_change = value
        commit.footer['BREAKING CHANGE'] = value
      elsif key.end_with?('#')
        commit.footer[key[0..-3]] = '#' + value
      else
        commit.footer[key[0..-3]] = value
      end
    end
  end

  def breaking_change?
    @breaking_change
  end

  def breaking_change!
    @breaking_change = true
  end
end
