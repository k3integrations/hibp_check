require 'resolv-replace' # Use better DNS resolver
require 'net/http'
require 'uri'
require 'digest'

class HibpCheck
  API_URL = 'https://api.pwnedpasswords.com/range/'

  attr_reader :prefix, :remainder, :hashes, :params, :request, :response

  def initialize(params={})
    @params = params
  end

  def password_used(password)
    return nil if password.nil?
    sha1_used Digest::SHA1.hexdigest(password.to_s)
  end

  def sha1_used(hashed)
    return nil unless hashed =~ /^[0-9a-f]{40}$/i
    @prefix = hashed.slice(0..4).upcase
    @remainder = hashed.slice(5..-1).upcase
    @hashes = fetch_hashes_by_prefix prefix
    if hashes
      return $1.to_i if hashes.match(/#{remainder}:(\d+)/)
      return 0
    end
    nil
  end

  private

  def fetch_hashes_by_prefix(prefix)
    fetch "#{API_URL}#{prefix}"
    return response.body if response.code == "200"
    nil
  end

  def fetch(url)
    uri = URI(url)

    Net::HTTP.start(uri.host, uri.port, params.merge(use_ssl: uri.scheme=='https')) do |http|
      @request = Net::HTTP::Get.new uri

      @response = http.request @request # Net::HTTPResponse object
    end
  end
end
