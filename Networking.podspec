#
# Be sure to run `pod lib lint Networking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  s.name         = "Networking"
  s.version      = "0.0.3"
  s.summary      = "A lib to manage the http config info in a plist file."

  s.homepage     = "https://github.com/kdjfqk/Networking"
  s.license      = "MIT"

  s.author             = { "kdjfqk" => "kdjfqk@126.com" }

  s.source       = { :git => "https://github.com/kdjfqk/Networking.git", :tag => "#{s.version}" }
  s.source_files = 'Networking/**/*.swift'

  s.ios.deployment_target = '8.0'

  s.dependency 'AlamofireObjectMapper', '4.0.2'

end
