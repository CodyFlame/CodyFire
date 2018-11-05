#
# Be sure to run `pod lib lint CodyFire.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CodyFire'
  s.version          = '1.7.1'
  s.summary          = '❤️ Powerful codable API requests builder and manager for iOS based on Alamofire'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This is a powerful lib that provide you ability to send requests and receive responses with Codable protocol'

  s.homepage         = 'https://github.com/MihaelIsaev/CodyFire'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MihaelIsaev' => 'isaev.mihael@gmail.com' }
  s.source           = { :git => 'https://github.com/MihaelIsaev/CodyFire.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CodyFire/Classes/**/*'

  # s.resource_bundles = {
  #   'CodyFire' => ['CodyFire/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Starscream', '~> 3.0.2'
  s.dependency 'Alamofire', '~> 4.7.3'
end
