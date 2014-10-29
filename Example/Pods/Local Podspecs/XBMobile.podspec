#
# Be sure to run `pod lib lint XBMobile.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "XBMobile"
  s.version          = "0.1.5"
  s.summary          = "TableView & CollectionView integrated with service, load more cell & pull to refresh. All automatically."
  s.description      = <<-DESC
                       The most powerful Mobile framework. Integrated with PlusIgniter & CodeIgnore. Everything you need to do is drag and drop. Anybody can be developer.
                       DESC
  s.homepage         = "https://github.com/EugeneNguyen/XBMobile"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Eugene Nguyen" => "xuanbinh91@gmail.com" }
  s.source           = { :git => "https://github.com/EugeneNguyen/XBMobile.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/LIBRETeamStudio'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/', 'Pod/Classes/Extension', 'Pod/Classes/ChatModule'
  s.resource_bundles = {
    'XBMobile' => ['Pod/Assets/**/*']
  }

  s.library = 'libxml2'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit', 'CoreData'
  s.library = 'libxml2'
  s.dependency 'ASIHTTPRequest'
  s.dependency 'JSONKit-NoWarning'
  s.dependency 'MBProgressHUD'
  s.dependency 'SDWebImage-ProgressView'
  s.dependency 'NSLogger-CocoaLumberjack-connector'
  s.dependency 'XMPPFramework', '~> 3.6'

end
