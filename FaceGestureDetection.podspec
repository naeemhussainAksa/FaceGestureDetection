

Pod::Spec.new do |spec|
  spec.name          = 'FaceGestureDetection'
  spec.version       = '1.0.0'
  spec.license       = { :type => "MIT", :file => "LICENSE" }
  spec.homepage      = 'https://github.com/naeemhussainAksa/FaceGestureDetection'
  spec.authors       = { 'AKSA' => 'naeem.hussain@axabiztech.com' } 
  spec.summary       = 'Face Gesture detection application using Firebase MLKit'
  spec.source        = { :git => 'https://github.com/naeemhussainAksa/FaceGestureDetection.git', :tag => '#{s.version}' }
  spec.module_name   = 'FaceGestureDetection'
  spec.swift_version = '5.0'
  spec.static_framework = true

  spec.ios.deployment_target  = '11.0'

  spec.source_files       = 'FaceGestureDetection/**/*.{h,m,swift, storyboard, xib}'
  spec.ios.source_files   = 'FaceGestureDetection/Views/*.storyboard', 'FaceGestureDetection/Utilities/*.xcassets' , 'FaceGestureDetection/Controllers/*.swift' , 'FaceGestureDetection/Cell & Views/*.{swift, xib}' , 'FaceGestureDetection/Models/*.swift'

  spec.ios.framework  = 'UIKit'
  spec.osx.framework  = 'AVFoundation'
  spec.osx.framework  = 'Foundation'

  spec.dependency 'GoogleMLKit/FaceDetection'
  spec.dependency 'GoogleMLKit/TextRecognition'


end
