require "sentry"

module Fastlane
  module Actions
    class RavenAction < Action
      def self.run(params)
        client = Sentry::Client.new(params[:token], "#{params[:organization]}/#{params[:project]}")
        UI.message("Creating new Release")
        response = client.create_release(params[:version])
        if response.response_code == 200
          UI.message("Release already exists..")
        elsif response.response_code == 201
          UI.success("Created new Release for Version: #{params[:version]}")
        else
          UI.user_error!("Failed to lookup/create a new Release")
        end
        UI.message("Uploading Sourcemaps")

        sourcemaps.each do |sourcemap|
          response = client.upload_release_artifact(params[:version], sourcemap)
          unless (200..300).cover?(response.response_code)
            UI.user_error!("Failed to upload Sourcemaps for Version: #{params[:version]}")
          end
        end
        UI.success("Uploaded all Sourcemaps for Version: #{params[:version]}")
      end

      def self.description
        "Create new Sentry/Raven Release and Upload Sourcemaps"
      end

      def self.authors
        ["Marten Klitzke"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :token,
            env_name: "RAVEN_SENTRY_TOKEN",
            description: "A valid Sentry API Token",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :organization,
            env_name: "RAVEN_SENTRY_ORG",
            description: "Your Sentry Organization name",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :project,
            env_name: "RAVEN_SENTRY_PROJECT",
            description: "Your Sentry Project name",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :version,
            env_name: "RAVEN_SENTRY_VERSION",
            description: "The Version of the new Release",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :sourcemaps,
            env_name: "RAVEN_SENTRY_SOURCEMAPS",
            description: "Path to the Sourcemaps",
            optional: false,
            type: Array
          )
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
