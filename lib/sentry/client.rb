require "typhoeus"

module Sentry
  class Client
    attr_accessor :base_url, :token, :slug

    def initialize(token, slug)
      self.token = token
      self.slug = slug
      self.base_url = "https://sentry.io/api/0/projects/"
      self.prefix = "/"
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

    def upload_release_artifact(version, artifact_path)
      Typhoeus.post(
        "#{base_url}/#{slug}/releases/#{version}/files/",
        headers: { "Authorization" => "Bearer #{token}" },
        body: { 
          file: File.open(artifact_path, "r"),
          name: "#{prefix}#{File.open(artifact_path}")
        }
    end
  end
end
