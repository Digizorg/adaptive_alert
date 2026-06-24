#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint adaptive_alert.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'adaptive_alert'
  s.version          = '0.0.3'
  s.summary          = 'Native iOS alerts and action sheets with adaptive Flutter fallbacks.'
  s.description      = <<-DESC
A Flutter plugin to show native alerts and action sheets on iOS, with adaptive fallbacks for other platforms.
                       DESC
  s.homepage         = 'https://digizorg.app/'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = 'Digizorg'
  s.source           = { :path => '.' }
  s.source_files = 'adaptive_alert/Sources/adaptive_alert/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.resource_bundles = {'adaptive_alert_privacy' => ['adaptive_alert/Sources/adaptive_alert/PrivacyInfo.xcprivacy']}
end
