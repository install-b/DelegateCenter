#
# Be sure to run `pod lib lint DelegateCenter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DelegateCenter'
  s.version          = '1.1.0'
  s.summary          = ' Delegate Notification Center.'

  s.description      = <<-DESC
A protocol oriented notification Center
                       DESC

  s.homepage         = 'https://github.com/install-b/DelegateCenter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'install-b' => '645256685@qq.com' }
  s.source           = { :git => 'https://github.com/install-b/DelegateCenter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = "4.2"
  s.source_files = 'Classes/*.swift'
  
  s.default_subspec = 'MultiProxyObject', 'ForwardProxy'
  
  s.subspec 'SafeExcute' do |ss|
      ss.source_files = 'Classes/SafeExcute/**/*.swift'
  end
  
  s.subspec 'ForwardProxy' do |ss|
      ss.source_files = 'Classes/ForwardProxy/**/*.*'
  end
  
  s.subspec 'MultiProxyObject' do |ss|
      ss.source_files = 'Classes/MultiProxyObject/**/*.swift'
      ss.dependency 'DelegateCenter/SafeExcute'
  end

  # s.resource_bundles = {
  #   'DelegateCenter' => ['DelegateCenter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
