# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FaceGestureDetection' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FaceGestureDetection

  pod 'GoogleMLKit/FaceDetection'
  pod 'GoogleMLKit/TextRecognition'
  pod 'lottie-ios'

#  post_install do |installer|
#    installer.pods_project.targets.each do |target|
#      target.build_configurations.each do |config|
#        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
#      end
#    end
#  end
  
  post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
   end
  end
  
  target 'FaceGestureDetectionTests' do
    # Pods for testing
  end

end
