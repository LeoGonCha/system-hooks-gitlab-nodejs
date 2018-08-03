#!/opt/gitlab/embedded/bin/ruby

require 'logger'

$LOG = Logger.new('/var/log/gitlab/hooks/update_custom.log', 10, 1024 * 1024 * 1)
$LOG.level = Logger::INFO

class CustomUpdate
  def initialize
    @oldsha = ARGV[1]
    @newsha = ARGV[2]
    $LOG.error("old/new: #{@oldsha} #{@newsha}")
  end

  def execute
    halt(6,"Não é permitido deletar branches.") if is_delete_request?
    halt(7,"Não é permitido push force.") if is_force_push?
    exit 0
  end

  def is_delete_request?
    cmd = "git cat-file -t #{@newsha}"
    IO.popen(cmd).read == "delete"
  end

  def is_force_push?
    result = IO.popen("git rev-list #{@oldsha} ^#{@newsha}").read
    result.length > 0
  end

  def halt(code, message)
    $LOG.error("#{code}:#{message}")
    STDOUT.puts message
    exit code
  end

end

pc = CustomUpdate.new
pc.execute