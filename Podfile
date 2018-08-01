# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!

target 'ooomiji' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  pod 'AffdexSDK-iOS'
  pod 'AFNetworking'
  # Pods for ooomiji
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if (target.name == "AWSCore") || (target.name == 'AWSKinesis')
            target.build_configurations.each do |config|
                config.build_settings['BITCODE_GENERATION_MODE'] = 'bitcode'
            end
        end
    end
end

