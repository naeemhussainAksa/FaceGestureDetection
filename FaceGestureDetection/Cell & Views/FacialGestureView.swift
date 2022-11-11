//
//  FacialGestureView.swift
//  KnowFace
//
//  Created by Naeem Hussain on 04/11/2022.
//

import Foundation
import UIKit
import AVFoundation
import MLKitVision
import MLKitFaceDetection

/// delegates for facial gesture detection
@objc public protocol FacialGestureCameraViewDelegate: AnyObject {

    @objc optional func faceDetectAtPosition()
    
    @objc optional func doubleEyeBlinkDetected()

    @objc optional func smileDetected()

    @objc optional func nodLeftDetected()

    @objc optional func nodRightDetected()
    
    @objc optional func nodUpDetected()
    
    @objc optional func nodDownDetected()

    @objc optional func leftEyeBlinkDetected()

    @objc optional func rightEyeBlinkDetected()
}

public class FacialGestureCameraView: UIView {
    
    private struct Constants {
        static let  videoDataOutputQueue = "VideoDataOutputQueue"
    }
    
    public weak var delegate: FacialGestureCameraViewDelegate?
    
    public var leftNodThreshold: CGFloat = 30.0
    
    public var rightNodThreshold: CGFloat = -30.0
    
    public var upNodThreshold: CGFloat = 20.5
    
    public var downNodThreshold: CGFloat = -20.5
    
    public var smileProbality: CGFloat = 0.5//0.8
    
    public var openEyeMaxProbability: CGFloat = 0.95
    
    public var openEyeMinProbability: CGFloat = 0.1
    
    private var restingFace: Bool = true
    
    private var isFaceDetected : Bool = false
    
    private lazy var options: FaceDetectorOptions = {
        
        let faceDetectorOpt = FaceDetectorOptions()
        faceDetectorOpt.performanceMode = .accurate
        faceDetectorOpt.landmarkMode = .all
        faceDetectorOpt.classificationMode = .all
        faceDetectorOpt.isTrackingEnabled = false
        faceDetectorOpt.contourMode = .none
        return faceDetectorOpt
    }()
    
    private lazy var videoDataOutput: AVCaptureVideoDataOutput = {
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        videoOutput.connection(with: .video)?.isEnabled = true
        return videoOutput
    }()
    
    private let videoDataOutputQueue: DispatchQueue = DispatchQueue(label: Constants.videoDataOutputQueue)
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    
    private let captureDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    
    private lazy var session: AVCaptureSession = {
        return AVCaptureSession()
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
}

extension FacialGestureCameraView {
    
    func beginSession() {
        isFaceDetected = false
        guard let captureDevice = captureDevice else { return }
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        }
        
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
        }
        
        layer.masksToBounds = true
        layer.addSublayer(previewLayer)
        print("Bounds of Capture device is: ", bounds)
        previewLayer.frame = bounds
        session.startRunning()
    }
    
    func stopSession() {
        session.stopRunning()
    }
}

extension FacialGestureCameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput,
                              didOutput sampleBuffer: CMSampleBuffer,
                              from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        let visionImage = VisionImage(buffer: sampleBuffer)
        visionImage.orientation = imageOrientation(
          deviceOrientation: UIDevice.current.orientation,
          cameraPosition: .front)
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
       // print("IMage size is = width:\(imageWidth), height:\(imageHeight)")
        DispatchQueue.global().async {
            self.detectFacesOnDevice(in: visionImage,
                                     width: imageWidth,
                                     height: imageHeight)
        }
        
    }
    
    private func imageOrientation(
        deviceOrientation: UIDeviceOrientation,
        cameraPosition: AVCaptureDevice.Position
    ) -> UIImage.Orientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return cameraPosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return cameraPosition == .front ? .upMirrored : .down
        case .faceDown, .faceUp, .unknown:
            return .up
        @unknown default:
            fatalError()
        }
    }
    
    private func detectFacesOnDevice(in image: VisionImage, width: CGFloat, height: CGFloat) {
        
        //let faceDetector = vision.faceDetector(options: options)
        
        let faceDetector = FaceDetector.faceDetector(options: options)
        faceDetector.process(image, completion: { features, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard error == nil, let features = features, !features.isEmpty else {
                return
            }
            
            if let face = features.first {
                
                print("Face rect is", face.frame)
                let leftEyeOpenProbability = face.leftEyeOpenProbability
                let rightEyeOpenProbability = face.rightEyeOpenProbability
                // left head nod
    
                //print("headEulerAngleX is:", "\(face.headEulerAngleX)")
//                print("openEyeMaxProbability is : ", rightEyeOpenProbability)
//                print("openEyeMinProbability is : ", leftEyeOpenProbability)
//                print("smilingProbability is : ", face.smilingProbability)
                
                if face.headEulerAngleX < 1 && face.headEulerAngleX > -1 {
                    
                    if !self.isFaceDetected {
                        self.delegate?.faceDetectAtPosition?()
                        self.isFaceDetected = true
                    }
                }
                
                if face.headEulerAngleY >= self.leftNodThreshold {
                    
                    if self.isFaceDetected {
                        if self.restingFace {
                            self.restingFace = false
                            self.delegate?.nodLeftDetected?()
                        }
                    }
                    
                } else if face.headEulerAngleY <= self.rightNodThreshold {
                    
                    //Right head tilt
                    if self.isFaceDetected {
                        if self.restingFace {
                            self.restingFace = false
                            self.delegate?.nodRightDetected?()
                        }
                    }
                    
                } else if face.headEulerAngleX >= self.upNodThreshold {
                    
                    if self.isFaceDetected {
                        if self.restingFace {
                            self.restingFace = false
                            self.delegate?.nodUpDetected?()
                        }
                    }
                    
                } else if face.headEulerAngleX <= self.downNodThreshold {
                    
                    if self.isFaceDetected {
                        if self.restingFace {
                            self.restingFace = false
                            self.delegate?.nodDownDetected?()
                        }
                    }
                }
                
                else if leftEyeOpenProbability > self.openEyeMaxProbability &&
                    rightEyeOpenProbability < self.openEyeMinProbability {
                    
                    // Right Eye Blink
                    if self.isFaceDetected {
                        if self.restingFace {
                            self.restingFace = false
                            self.delegate?.rightEyeBlinkDetected?()
                        }
                    }
                    
                } else if rightEyeOpenProbability > self.openEyeMaxProbability &&
                    leftEyeOpenProbability < self.openEyeMinProbability {
                    
                    // Left Eye Blink
                    if self.isFaceDetected {
                        if self.restingFace {
                            self.restingFace = false
                            self.delegate?.leftEyeBlinkDetected?()
                        }
                    }
                    
                } else if face.smilingProbability > self.smileProbality {
                    
                    // smile detected
                    if self.isFaceDetected {
                        if self.restingFace {
                            self.restingFace = false
                            self.delegate?.smileDetected?()
                        }
                    }
                    
                } else if leftEyeOpenProbability < self.openEyeMinProbability && rightEyeOpenProbability < self.openEyeMinProbability {
                    
                    // full/both eye blink
                    if self.isFaceDetected {
                        if self.restingFace {
                            self.restingFace = false
                            self.delegate?.doubleEyeBlinkDetected?()
                        }
                    }
                    
                } else {
                    
                    // Face got reseted
                    self.restingFace = true
                }
            }
        })
    }
    
}

