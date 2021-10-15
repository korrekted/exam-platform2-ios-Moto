platform :ios, ‘12.0’
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Moto' do
  pod 'NotificationBannerSwift'
  pod 'lottie-ios'
  pod 'Kingfisher'
  
  pod 'RushSDK', :git => "https://github.com/AgentChe/RushSDK.git"
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      # Needed for building for simulator on M1 Macs
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
