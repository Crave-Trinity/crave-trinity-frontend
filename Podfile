# Declare a global platform for iOS targets
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
  # No pods for CraveVision
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
  # No pods for CraveWatch

  target 'CraveWatch Watch AppTests' do
    inherit! :search_paths
  end

  target 'CraveWatch Watch AppUITests' do
    inherit! :search_paths
  end
end