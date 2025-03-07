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
  # Force all pod targets to iOS 13.0 if needed.
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
