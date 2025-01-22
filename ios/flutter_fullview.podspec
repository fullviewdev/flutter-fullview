#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_fullview.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_fullview'
  s.version          = '0.10.0'
  s.summary          = 'Effortlessly integrate screen-sharing, real-time assistance, and advanced data redaction for sensitive information, enhancing user support while prioritising security and privacy.'
  s.description      = <<-DESC
With Fullview SDK, you can effortlessly integrate screen-sharing, real-time assistance, and advanced data redaction for sensitive information, enhancing user support while prioritising security and privacy.
                       DESC
  s.homepage         = 'https://github.com/fullviewdev/flutter-fullview#readme'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Fullview' => 'support@fullview.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Daily', '~> 0.25.0'
  s.dependency 'DailySystemBroadcast', '~> 0.25.0'
  s.dependency 'FullviewSDK', '~> 0.10.0'

  s.platform = :ios, '15.0'
  s.source       = { :git => "https://github.com/fullviewdev/flutter-fullview.git", :tag => "#{s.version}" }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_fullview_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
