require "typhoeus"

module Sentry
  class Client
    attr_accessor :base_url, :token, :slug

    def initialize(token, slug)
      self.token = token
      self.slug = slug
      self.base_url = "https://sentry.io/api/0/projects/"
    end

    def create_release(version)
      response = Typhoeus.get(
        "#{base_url}/#{slug}/releases/#{version}/",
        headers: {
          "Authorization" => "Bearer #{token}",
          "Content-Type" =>  "application/json"
        }
      )
      if response.response_code == 200
        # Release already present, skipping...
        return response
      end

      Typhoeus.post(
        "#{base_url}/#{slug}/releases/",
        headers: {
          "Authorization" => "Bearer #{token}",
          "Content-Type" =>  "application/json"
        },
        body: JSON.dump({ version: version })
      )
    end

    def upload_sourcemaps(version, sourcemaps)
      sourcemaps.each do |sourcemap|
        response = Typhoeus.post(
          "#{base_url}/#{slug}/releases/#{version}/files/",
          headers: { "Authorization" => "Bearer #{token}" },
          body: { file: File.open(sourcemap, "r") }
        )
        return false unless response.response_code == 201
      end
      true
    end
  end
end
