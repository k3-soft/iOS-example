source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target ‘Movask’ do
pod 'Alamofire', '~> 4.4'
pod 'AlamofireObjectMapper', '~> 4.1'
pod 'AlamofireImage', '~> 3.2'
pod 'SwiftyJSON'
pod 'Fabric'
pod 'Crashlytics'
pod 'IQKeyboardManagerSwift', '~> 4.0'
pod 'PKHUD', '~> 4.2'
pod 'FirebaseMessaging'
pod 'Firebase'
pod 'ASPVideoPlayer', '~> 2.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = "3.0"
            configuration.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
        end
    end
end
