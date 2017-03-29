# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

target 'FlyTour' do
    use_frameworks!

    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'Alamofire', '~> 4.4'
    pod 'ObjectMapper', '~> 2.2'
    pod 'ReachabilitySwift', '~> 3'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
