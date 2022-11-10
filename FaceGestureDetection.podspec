Pod::Spec.new do |s|
    s.platform              = :ios
    s.ios.deployment_target = '13.0'
    s.name                  = "FaceGestureDetection"
    s.summary               = "iOS SDK for FaceDetection"
    s.requires_arc          = true
    
    
    s.version               = "1.0.0"
    
    s.license               = { :type => "MIT", :file => "LICENSE" }
    
    
    s.author                = { "AKSA" => "naeem.hussain@axabiztech.com" }
    
    s.homepage              = "https://github.com/naeemhussainAksa/FaceGestureDetection"
    
    
    s.source                = {
    :git => "https://github.com/naeemhussainAksa/FaceGestureDetection.git",
    :branch => "main",
    :tag => "#{s.version}"
    }
    
    s.static_framework      = true

    s.framework             = "UIKit"
    s.framework             = "AVFoundation"
    s.framework             = "Foundation"
    
    s.source_files          = "FaceGestureDetection/**/*.{h,m,swift, storyboard}"
    s.resources             = 'FaceGestureDetection/Views/*.storyboard'

    s.dependency 'GoogleMLKit/TextRecognition'
    s.dependency 'GoogleMLKit/FaceDetection'
    
    s.swift_version         = "5"
    
end
