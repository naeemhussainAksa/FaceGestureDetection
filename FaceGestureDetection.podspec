

Pod::Spec.new do |spec|

  spec.ios.deployment_target  = '10.0'
  spec.name          = 'FaceGestureDetection'
  spec.summary       = 'Face Gesture detection application using Firebase MLKit'
  spec.requires_arc  = true


  spec.version       = '1.0.0'
  spec.platform      = :ios, "13.0"

  spec.license       = { :type => "MIT", :file => "LICENSE" }
  spec.authors       = { 'AKSA' => 'naeem.hussain@axabiztech.com' } 

  spec.homepage      = 'https://github.com/naeemhussainAksa/FaceGestureDetection'

  
  spec.source        = { :git => 'https://github.com/naeemhussainAksa/FaceGestureDetection.git', :tag => '1.0.0' }

  spec.static_framework = true
  spec.ios.framework  = 'UIKit'
  spec.ios.framework  = 'AVFoundation'
  spec.ios.framework  = 'Foundation'

  spec.source_files       = 'FaceGestureDetection/**/*.{swift}'
  spec.resources   = 'FaceGestureDetection/**/*.{storyboard,xib,xcassets,json,mlmodel}'

  spec.swift_version = '5.0'

  spec.dependency 'GoogleMLKit/FaceDetection'
  spec.dependency 'GoogleMLKit/TextRecognition'
 

end
