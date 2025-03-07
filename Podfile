# Podfile

platform :ios, '13.0'
use_frameworks!

# ---------------------------
# iOS: CravePhone
# ---------------------------
target 'CravePhone' do
  pod 'SentrySwiftUI', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '8.46.0'

  target 'CravePhoneTests' do
    inherit! :search_paths
  end

  target 'CravePhoneUITests' do
    inherit! :search_paths
  end
end

# ---------------------------
# iOS: CraveVision (No pods)
# ---------------------------
target 'CraveVision' do
  use_frameworks!
  target 'CraveVisionTests' do
    inherit! :search_paths
  end
end

# ---------------------------
# watchOS: CraveWatch Watch App (No pods)
# ---------------------------
target 'CraveWatch Watch App' do
  platform :watchos, '9.0'
  use_frameworks!
  target 'CraveWatch Watch AppTests' do
    inherit! :search_paths
  end
  target 'CraveWatch Watch AppUITests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  # Force all pod targets to iOS 13.0
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end

  # Option 1: Remove the xattr patch entirely.
  # (Comment out or remove the following block if you don’t need to strip extended attributes.)
  #
  # installer.aggregate_targets.each do |aggregate_target|
  #   if aggregate_target.respond_to?(:frameworks_script_path)
  #     frameworks_script_path = aggregate_target.frameworks_script_path
  #     if File.exist?(frameworks_script_path)
  #       script = File.read(frameworks_script_path)
  #       additional_cmd = "\n# (Optional) Remove extended attributes from Sentry frameworks only on device builds\n"
  #       additional_cmd += "if [ \"$PLATFORM_NAME\" != \"iphonesimulator\" ]; then\n"
  #       additional_cmd += "  if [ -d \"${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/Sentry.framework\" ]; then\n"
  #       additional_cmd += "    xattr -rc \"${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/Sentry.framework\"\n"
  #       additional_cmd += "  fi\n"
  #       additional_cmd += "  if [ -d \"${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/SentrySwiftUI.framework\" ]; then\n"
  #       additional_cmd += "    xattr -rc \"${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/SentrySwiftUI.framework\"\n"
  #       additional_cmd += "  fi\n"
  #       additional_cmd += "fi\n"
  #       script << additional_cmd
  #       File.write(frameworks_script_path, script)
  #     end
  #   else
  #     puts "[Post Install] aggregate target '#{aggregate_target.name}' does not support frameworks_script_path. Skipping patch."
  #   end
  # end
end
