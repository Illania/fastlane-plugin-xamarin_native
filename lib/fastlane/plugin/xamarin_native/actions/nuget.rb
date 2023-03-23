require 'fastlane/action'
require_relative '../helper/xamarin_native_helper'

module Fastlane
  module Actions
    class NugetAction < Action
      def self.run(params)
        sh "nuget restore #{params[:sln]} -verbosity #{params[:verbosity]}"
      end

      def self.description
        "Downloads and installs any packages missing from the packages folder"
      end

      def self.authors
        ["illania"]
      end

      def self.available_options
        [
            FastlaneCore::ConfigItem.new(
            key: :sln,
            env_name: 'FL_XN_BUILD_NUGET_SOLUTION',
            description: 'Path to Xamarin .sln file',
            type: String,
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :verbosity,
            env_name: 'FL_XN_BUILD_NUGET_VERBOSITY',
            description: 'Specifies the amount of detail displayed in the output: normal (the default), quiet, or detailed',
            type: String,
            default_value: 'detailed',
            optional: true,
          )                            
        ]
      end

      def self.is_supported?(platform)
          [:ios, :android].include?(platform)
        true
      end
    end
  end
end
