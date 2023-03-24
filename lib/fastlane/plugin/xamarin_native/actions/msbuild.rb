require 'fastlane/action'
require_relative '../helper/xamarin_native_helper'

module Fastlane
  module Actions
    class MsbuildAction < Action
       MSBUILD = '/Library/Frameworks/Mono.framework/Commands/msbuild'.freeze
       BUILD_TYPE = %w(Release Debug).freeze
       PLATFORM = %w(iPhone iPhoneSimulator AnyCPU).freeze
       TARGET = %w(Build Rebuild Clean).freeze
       PRINT_ALL = [true, false].freeze

      def self.run(params)
        build(params)
      end

      def self.build(params)
        platform = params[:platform]
        build_type = params[:build_type]
        target = params[:target]
        solution = params[:solution]
        output_path = params[:output_path]
        ipa_name = params[:ipa_name]
        sign_apk = params[:sign_apk]
        project = params[:project]
        android_signing_keystore = params[:android_signing_keystore]
        android_signing_key_pass = params[:android_signing_key_pass]
        android_signing_store_pass = params[:android_signing_store_pass]
        android_signing_key_alias = params[:android_signing_key_alias]

        command = "#{MSBUILD} "
        command << "/target:#{target} " if target != nil
        command << "/p:Platform=#{platform} " if platform != nil
        command << "/p:Configuration=#{build_type} " if build_type != nil
        command << "/p:OutputPath=#{output_path} " if output_path != nil
        
        command << "/p:BuildIpa=True " if ipa_name != nil
        command << "/p:IpaPackageName=#{ipa_name} " if ipa_name != nil
        command << "/p:IpaPackageDir=#{output_path} " if output_path != nil
        
        command << "/t:SignAndroidPackage " if sign_apk == true
        command << "/p:AndroidSigningKeyStore=#{android_signing_keystore} " if  android_signing_keystore != nil
        command << "/p:AndroidSigningKeyPass=#{android_signing_key_pass} " if android_signing_key_pass != nil
        command << "/p:AndroidSigningStorePass=#{android_signing_store_pass} " if  android_signing_store_pass != nil
        command << "/p:AndroidSigningKeyAlias=#{android_signing_key_alias} " if  android_signing_key_alias != nil
        
        command << project if project != nil
        command << solution if solution != nil
        Helper::XamarinNativeHelper.bash(command, !params[:print_all])
      end

      def self.description
         "Build Xamarin.Native iOS and Android projects using msbuild"
      end

      def self.authors
        ["illania"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :solution,
              env_name: 'FL_XN_BUILD_SOLUTION',
              description: 'Path to Xamarin .sln file',
              optional: true,
              verify_block: proc do |value|
                UI.user_error!('File not found'.red) unless File.file? value
              end
          ),
          
          FastlaneCore::ConfigItem.new(
              key: :project,
              env_name: 'FL_XN_BUILD_PROJECT',
              description: 'Project to build or clean',
              is_string: true,
              optional: true,
              verify_block: proc do |value|
                UI.user_error!('File not found'.red) unless File.file? value
              end
          ),

          FastlaneCore::ConfigItem.new(
            key: :platform,
            env_name: 'FL_XN_BUILD_PLATFORM',
            description: 'Build platform',
            type: String,
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("Unsupported value! Use one of #{PLATFORM.join '\' '}".red) unless PLATFORM.include? value
            end
          ),

          FastlaneCore::ConfigItem.new(
              key: :build_type,
              env_name: 'FL_XN_BUILD_TYPE',
              description: 'Release or Debug',
              type: String,
              optional: false,
              verify_block: proc do |value|
                UI.user_error!("Unsupported value! Use one of #{BUILD_TYPE.join '\' '}".red) unless BUILD_TYPE.include? value
              end
          ),

          FastlaneCore::ConfigItem.new(
            key: :target,
            env_name: 'FL_XN_BUILD_TARGET',
            description: 'Target build type',
            type: String,
            optional: false,
            verify_block: proc do |value|
              UI.user_error!("Unsupported value! Use one of #{TARGET.join '\' '}".red) unless TARGET.include? value
            end
          ),

          FastlaneCore::ConfigItem.new(
            key: :print_all,
            env_name: 'FL_XN_BUILD_PRINT_ALL',
            description: 'Print std out',
            default_value: true,
            is_string: false,
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("Unsupported value! Use one of #{PRINT_ALL.join '\' '}".red) unless PRINT_ALL.include? value
            end
          ),

          FastlaneCore::ConfigItem.new(
              key: :output_path,
              env_name: 'FL_XN_BUILD_OUTPUT_PATH',
              description: 'Build output path for ipa and apk files',
              is_string: true,
              optional: true
          ),
           FastlaneCore::ConfigItem.new(
              key: :ipa_name,
              env_name: 'FL_XN_BUILD_IPA_NAME',
              description: 'Ipa name for iOS app',
              is_string: true,
              optional: true
          ),
           FastlaneCore::ConfigItem.new(
              key: :sign_apk,
              env_name: 'FL_XN_BUILD_SIGN_APK',
              description: 'Sets if apk should be created and signed',
              is_string: false,
              optional: true,
              default_value: false
          ),
           FastlaneCore::ConfigItem.new(
              key: :android_signing_keystore,
              env_name: 'FL_XN_BUILD_DROID_SIGNING_KEYSTORE',
              description: 'Sets Android Signing KeyStore',
              is_string: true,
              optional: true
          ),
           FastlaneCore::ConfigItem.new(
              key: :android_signing_key_pass,
              env_name: 'FL_XN_BUILD_DROID_SIGNING_KEY_PASS',
              description: 'Sets Android Signing Key Password',
              is_string: true,
              optional: true
          ),
           FastlaneCore::ConfigItem.new(
              key: :android_signing_store_pass,
              env_name: 'FL_XN_BUILD_DROID_SIGNING_STORE_PASS',
              description: 'Sets Android Signing Store Password',
              is_string: true,
              optional: true
          ),
           FastlaneCore::ConfigItem.new(
              key: :android_signing_key_alias,
              env_name: 'FL_XN_BUILD_DROID_SIGNING_KEY_ALIAS',
              description: 'Sets Android Signing Key Alias',
              is_string: true,
              optional: true
          )
        ]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end

    end
  end
end
