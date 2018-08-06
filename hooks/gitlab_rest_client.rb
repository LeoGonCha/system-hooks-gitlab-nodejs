#!/opt/gitlab/embedded/bin/ruby


require 'net/http'
require 'openssl'
require 'json'
require 'uri'


class GitRestClient
  def initialize
    @private_token = 'private_token=hdTy7chH4TCsSNX2LJzb'
  end

  def users
    get('http://git/api/v3/users')
  end

  def get(url)
    users = []

    while !url.nil?
      response = Net::HTTP.get_response(URI.parse(insert_token(url)))
      users << JSON.parse(response.body)
      url = next_link(response)
    end

    users.reduce(:concat)
  end

  def user_by_id(id)
    get("http://git/api/v3/users/#{id}")
  end

  def user_by_key_id(key_id)
    get("http://git/api/v3/keys/#{key_id}")
  end

  def user_email_by_id(id)
    user_by_id(id)["email"]
  end

  def user_email_by_key_id(key_id)
    user_by_key_id(key_id)["user"]["email"]
  end

  def insert_token(url)
    return url if url.include?(@private_token)
    url.include?("?") ? "#{url}&#{@private_token}" : "#{url}?#{@private_token}"
  end

  def next_link(response)
    return nil if response["link"].nil?
    link = response["link"].split(',').select{|h| h.include?("next")}
    return nil if (link.empty? or link.nil?)
    link[0].match(/[<](.*)[>]/).captures[0]
  end

  def get_email_by_global_id(global_id)
    auth_mode, id = dismember_id(global_id)
    if auth_mode == :key
      return user_email_by_key_id(id)
    else
      return user_email_by_id(id)
    end
  end

  def dismember_id global_id
    if global_id =~ /\Akey\-\d+\Z/
      return [:key, global_id.gsub("key-", "")]
    elsif global_id =~ /\Auser\-\d+\Z/
      return [:user, global_id.gsub("user-", "")]
    end
  end
end


if __FILE__ == $0
  grc = GitRestClient.new
  puts grc.users.size
end

