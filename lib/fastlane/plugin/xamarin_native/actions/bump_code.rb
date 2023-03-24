require 'fastlane/action'
require 'plist'
require 'nokogiri'
require_relative '../helper/xamarin_native_helper'

module Fastlane
  module Actions
    class BumpCodeAction < Action

      PLATFORM = %w(iOS Android).freeze

      def self.run(params)
        if params[:platform] == 'iOS'
          bump_build_number_ios(params)
        else
          bump_build_number_android(params)
        end
      end

      def self.description
        "Increments project build number"
      end

      def self.authors
        ["illania"]
      end


      def self.bump_build_number_ios(params)
        begin
          params[:info_plist_pathes].each do |path|  
            current_build_number = get_info_plist_build_number(path)
            new_build_number = (current_build_number.to_i+1).to_s
            set_info_plist_build_number(path, new_build_number)
          end
        rescue => ex
          UI.error(ex)
        end
      end

      def self.get_info_plist_build_number(path)
        begin
          path = File.expand_path(path)
          plist = File.open(path) { |f| Plist.parse_xml(f) }
          value = plist['CFBundleVersion']
          return value
        rescue => ex
          UI.error(ex)
        end
      end

      def self.set_info_plist_build_number(path, new_build_number)
        begin
          path = File.expand_path(path)
          plist = Plist.parse_xml(path)      
          plist['CFBundleVersion'] = new_build_number
          new_plist = Plist::Emit.dump(plist)
          File.write(path, new_plist)
          end
        rescue => ex
          UI.error(ex)
          UI.user_error!("Unable to set build number '#{new_build_number}' to plist file at '#{path}'")
        end
      end


      def self.bump_build_number_android(params)
        doc = File.open(params[:manifest_file_path]) { |f|
          @doc = Nokogiri::XML(f)
          manifest_node = @doc.xpath('//manifest')
          current_build_number = @doc.at('//manifest/@android:versionCode').text
          new_build_number = (current_build_number.to_i+1).to_s
          manifest_node.attr('android:versionCode', new_build_number)
          File.write(manifest_file, @doc.to_xml)
        }
      end

      def self.available_options
        [
            FastlaneCore::ConfigItem.new(
            key: :platform,
            env_name: 'FL_XN_BUILD_VERSION_PLATFORM',
            description: 'iOS or Android',
            type: String,
            optional: false
          ),
            FastlaneCore::ConfigItem.new(
            key: :info_plist_pathes,
            env_name: 'FL_XN_BUILD_VERSION_INFO_PLIST_PATHES',
            description: 'Info plist pathes',
            type: Array,
            optional: false
          ),
            FastlaneCore::ConfigItem.new(
            key: :manifest_file_path,
            env_name: 'FL_XN_BUILD_VERSION_MANIFEST_FILE_PATH',
            description: 'Android Manifest file path',
            type: String,
            optional: false
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
