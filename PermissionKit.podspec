#
# Be sure to run `pod lib lint PermissionKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PermissionKit'
  s.version          = '1.0.0'
  s.summary          = 'Request user permission to access common iOS features.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An easy way to request permission to access common iOS features.
                       DESC

  s.homepage         = 'https://github.com/sgerardi/PermissionKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sam Gerardi' => 'sgerardi@seamgen.com' }
  s.source           = { :git => 'https://github.com/sgerardi/PermissionKit.git', :tag => s.version.to_s }
  s.social_media_url = 'http://www.seamgen.com'

  s.ios.deployment_target = '9.3'

  s.source_files = 'PermissionKit/Classes/**/*'

  s.frameworks = 'UIKit', 'CoreLocation', 'Contacts', 'AVFoundation', 'EventKit', 'Photos', 'Speech', 'MediaPlayer'
end
