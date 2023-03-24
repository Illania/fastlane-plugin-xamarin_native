require 'fastlane/action'
require 'plist'
require 'nokogiri'
require_relative '../helper/xamarin_native_helper'

module Fastlane
  module Actions
    class BumpVersionAction < Action

      PLATFORM = %w(iOS Android).freeze
      VERSION_TYPE = %w(major minor patch).freeze

      def self.run(params)
        if params[:platform] == 'iOS'
          bump_version_ios(params)
        else
          bump_version_android(params)
        end
      end

      def self.description
        "Increments project version"
      end

      def self.authors
        ["illania"]
      end

      def self.bump(current_version,type)
        begin
          components = current_version.split('.')
          major = components[0].to_i
          minor = components[1].to_i
          patch = components[2].to_i

          if type == "major"
            major += 1
            minor = 0
            patch = 0
          elsif type == "minor"
            minor += 1
            patch = 0
          elsif type == "patch"
            patch += 1
          else
            abort("Unknown version bump type: #{type}\nValid options: major, minor, patch.")
          end

          return new_version = [major, minor, patch].join('.')
        rescue => ex
          UI.error(ex)
        end

      end

      def self.bump_version_ios(params)
        begin
          info_plist = params[:info_plist_pathes]
          info_plist.each do |path|
              current_version = get_info_plist_version(path)
              new_version = bump(current_version, params[:type])
              set_info_plist_version(path, new_version)
          end
        rescue => ex
          UI.error(ex)
        end
      end

      def self.get_info_plist_version(path)
        begin
          path = File.expand_path(path)
          plist = File.open(path) { |f| Plist.parse_xml(f) }
          value = plist['CFBundleShortVersionString']
          return value
        rescue => ex
          UI.error(ex)
        end
      end

      def self.set_info_plist_version(path, new_version)
        begin
          path = File.expand_path(path)
          plist = Plist.parse_xml(path)      
          plist['CFBundleShortVersionString'] = new_version
          new_plist = Plist::Emit.dump(plist)
          File.write(path, new_plist)
        rescue => ex
          UI.error(ex)
          UI.user_error!("Unable to set version '#{new_version}' to plist file at '#{path}'")
        end
      end

      def self.bump_version_android(params)
        begin
          version_type = params[:type]
          manifest_file = params[:manifest_file_path]
          doc = File.open() { |f| manifest_file
              @doc = Nokogiri::XML(f)
              manifest_node = @doc.xpath('//manifest')
              current_version = @doc.at('//manifest/@android:versionName').text
              new_version = bump(current_version, version_type)
              manifest_node.attr('android:versionName', new_version)
              File.write(manifest_file, @doc.to_xml)
          }
        rescue => ex
          UI.error(ex)
        end
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
            key: :type,
            env_name: 'FL_XN_BUILD_VERSION_TYPE',
            description: 'Sets how version should be incremented (major, minor, patch)',
            is_string: true,
            optional: false,
            default_value: 'minor',
            verify_block: proc do |value|
              UI.user_error!("Unsupported value! Use one of #{VERSION_TYPE.join '\' '}".red) unless VERSION_TYPE.include? value
            end
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
            optional: false,
            verify_block: proc do |value|
              UI.user_error!('File not found'.red) unless File.file? value
            end
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
