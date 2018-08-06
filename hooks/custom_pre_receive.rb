#!/opt/gitlab/embedded/bin/ruby
ENV['PATH'] = '/opt/gitlab/bin:/opt/gitlab/embedded/bin:' + ENV['PATH']

#require_relative './gitlab_rest_client'
require 'logger'

$LOG = Logger.new('/var/log/gitlab/hooks/pre_receive_custom.log', 10, 1024 * 1024 * 1)
$LOG.level = Logger::INFO

class CustomPreReceive
  NOREV = "0000000000000000000000000000000000000000"
  GIT_BIN = '/opt/gitlab/embedded/bin/git'

  def initialize()
    @refs = ARGF.read
    @oldsha, @newsha, @target = @refs.split
    @global_id = ENV['GL_ID']
    @repo_path = Dir.pwd
  end

  def log
    $LOG.info("Repository: #{@repo_path}")
    $LOG.info("ID: #{@global_id}")
    $LOG.info("Commit info: #{@refs.to_s}")
  end

  def execute
    log
    validate
    exit 0
  end

  protected

  def halt(code, message)
    $LOG.error("#{code}:#{message}")
    STDOUT.puts message
    exit code
  end

  def get_revision_range
    ((@oldsha == NOREV) or (@newsha == NOREV)) ? "#{@newsha}" : "#{@oldsha}..#{@newsha}"
  end

  def get_push_pack_users
    %x(#{"#{GIT_BIN} log --pretty=format:'%ae' #{get_revision_range}"}).split.uniq
  end

  def is_heuristicaly_a_web_delete_request?
    @target.length > 0 && @commit_email.size == 0
  end

  def is_not_new_ref?
    @oldsha != NOREV
  end

  def validate
    commit_email = get_push_pack_users
    push_email = rest_api.get_email_by_global_id(@global_id)
    halt(3, "Tentativa de deletar branch via web.") if is_heuristicaly_a_web_delete_request?
    halt(3, "Mais de um usuario : #{commit_email.to_s}") if commit_email.size > 1 and is_not_new_ref?
    halt(4, "Usuarios diferentes no commit e no push: #{commit_email[0]} e #{push_email}") unless (push_email == commit_email[0])
  end

  def rest_api() GitRestClient.new  end

end

pc = CustomPreReceive.new
pc.execute



