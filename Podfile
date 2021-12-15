platform :ios, '12.0'

inhibit_all_warnings!

use_frameworks!

target 'LockScreenText' do
    pod 'SwiftLint'
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
end

