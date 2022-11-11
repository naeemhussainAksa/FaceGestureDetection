//
//  SelfieViewController.swift
//  KnowFace
//
//  Created by Naeem Hussain on 24/10/2022.
//

import UIKit
import AVFoundation

class SelfieViewController: BaseViewController {

    
    // MARK: - Navigation -
    
    @IBOutlet weak var cameraView: FacialGestureCameraView!
    @IBOutlet weak var cameraLayer: UIView! {
            didSet{
                //self.cameraLayer.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            }
        }
    @IBOutlet weak var scanLayerView: UIView!
    @IBOutlet weak var similarityLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var directionImage: UIImageView!
    
    // MARK: - Declarations -
    
    private let photoOutput = AVCapturePhotoOutput()
    private var captureSession : AVCaptureSession! = nil
    
    var inputDataDict = [String: Any]()
    var detectionModes = LivenessDetectionValues.blink_eyes
    var currentGoingMode = LivenessDetectionValues.blink_eyes
    var randomCases = [LivenessDetectionValues]()
    var randomCaseHandeledCount = 0
    var selfImagesTOCompare = [UIImage]()
    var detectioDone = false
    var randomArray = [1, 2, 3]
    var iteration = 0
    
    // MARK: - Controller's LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCameraViewDelegate()
        
        iteration = randomArray.randomElement() ?? 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //setupCaptureSession()
        startGestureDetection()
        
        print("Scan layer frame is :", scanLayerView.frame)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopGestureDetection()
    }
    
    // MARK: - custom Methods -

    private func modeHandlings()
    {
        currentGoingMode = detectionModes
        if detectionModes == .random {
            randomCaseHandeledCount = 0
            var cases = LivenessDetectionValues.allCases
            cases.shuffle()
            randomCases = [cases[0], cases[1]]
            currentGoingMode = randomCases[0]
        }
        else if detectionModes == .tuen_left_then_right {
            randomCaseHandeledCount = 0
            randomCases = [.turn_left, .turn_right]
            currentGoingMode = randomCases[0]
        }
        else if detectionModes == .move_up_then_down {
            randomCaseHandeledCount = 0
            randomCases = [.move_up, .move_down]
            currentGoingMode = randomCases[0]
        }
        
        directionHandlings()
        similarityLabel.text = ""
        directionLabel.text = ""
    }
    
    private func casesFullfillHandlings()
    {
        randomCaseHandeledCount += 1
        if (detectionModes == .random || detectionModes == .move_up_then_down || detectionModes == .tuen_left_then_right) && randomCaseHandeledCount < 2 {
            
            currentGoingMode = randomCases[randomCaseHandeledCount]
            directionHandlings()
        }
        else if iteration > 0 {
            iteration = iteration - 1
            
            showToast(message: detectionModes.detectionString, with: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.modeHandlings()
            }
        }
        else {
            detectioDone = true
            
            showToast(message: detectionModes.detectionString, with: true)
            directionImage.image = nil
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func directionHandlings()
    {
        if let imgName = currentGoingMode.imageName {
            directionImage.image = UIImage(named: imgName)
            detectioDone = false
            imageAnimateAtPoint()
        } else {
            
            directionLabel.text = currentGoingMode.rawValue
            similarityLabel.text = ""
        }
    }
    
    private func imageAnimateAtPoint()
    {
        if !detectioDone {
            
            var frame = directionImage.frame
            let defaultMargin : CGFloat = 25
            switch currentGoingMode {
            case .turn_left:
                frame.origin.x = frame.origin.x - defaultMargin
            case .turn_right:
                frame.origin.x = frame.origin.x + defaultMargin
            case .move_up:
                frame.origin.y = frame.origin.y - defaultMargin
            case .move_down:
                frame.origin.y = frame.origin.y + defaultMargin
            default:
                print("default")
            }
            
            frameMargin(frame: frame)
        }
    }
    
    private func frameMargin(frame: CGRect)
    {
        let defaultMarginIs = directionImage.frame
        
        UIView.animate(withDuration: 0.9) {
            self.directionImage.frame = frame
        } completion: { success in
            
            self.directionImage.frame = defaultMarginIs
            self.imageAnimateAtPoint()
        }
    }
//    private func setupCaptureSession() {
//        captureSession = AVCaptureSession()
//
//        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
//            do {
//                let input = try AVCaptureDeviceInput(device: captureDevice)
//                if captureSession.canAddInput(input) {
//                    captureSession.addInput(input)
//                }
//            } catch let error {
//                print("Failed to set input device with error: \(error)")
//            }
//
//            if captureSession.canAddOutput(photoOutput) {
//                captureSession.addOutput(photoOutput)
//            }
//
//            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//            cameraLayer.frame = UIScreen.main.bounds //self.cameraView.bounds
//            cameraLayer.videoGravity = .resizeAspectFill
//            //cameraLayer.cornerRadius = 20
//            self.cameraView.layer.addSublayer(cameraLayer)
//            captureSession.startRunning()
//
//            addCameraLayerAndScanLayer()
//        }
//    }
    
    
//    private func addCameraLayerAndScanLayer(){
//        // Draw a graphics with a mostly solid alpha channel
//        // and a square of "clear" alpha in there.
//
//        UIGraphicsBeginImageContext(UIScreen.main.bounds.size)
//        let cgContext = UIGraphicsGetCurrentContext()
//        cgContext?.fill(UIScreen.main.bounds)
//
//        //let frame = firstView.convert(buttons.frame, from:secondView)
//
//        cgContext?.clear(CGRect(x:self.scanLayerView.frame.origin.x, y:self.scanLayerView.frame.origin.y, width: self.scanLayerView.bounds.width, height: self.scanLayerView.bounds.height ))
//        let maskImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        // Set the content of the mask view so that it uses our
//        // alpha channel image
//        let maskView = UIView(frame: UIScreen.main.bounds)
//        maskView.layer.contents = maskImage?.cgImage
//        self.cameraLayer.mask = maskView
//    }
    
    private func handleDismiss() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Actions -
    
    @IBAction func backAction(_ sender: UIButton)
    {
        handleDismiss()
    }
    
    @IBAction func captureAction(_ sender: UIButton)
    {
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    @IBAction func rotateAction(_ sender: UIButton)
    {
        if let session = captureSession {
            //Remove existing input
            guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
                return
            }

            //Indicate that some changes will be made to the session
            session.beginConfiguration()
            session.removeInput(currentCameraInput)

            //Get new input
            var newCamera: AVCaptureDevice! = nil
            if let input = currentCameraInput as? AVCaptureDeviceInput {
                if (input.device.position == .back) {
                    newCamera = cameraWithPosition(position: .front)
                } else {
                    newCamera = cameraWithPosition(position: .back)
                }
            }

            //Add input to session
            var err: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let err1 as NSError {
                err = err1
                newVideoInput = nil
            }

            if newVideoInput == nil || err != nil {
                print("Error creating capture device input: \(err?.localizedDescription)")
            } else {
                session.addInput(newVideoInput)
            }

            //Commit all the configuration changes at once
            session.commitConfiguration()
        }
    }

}

extension SelfieViewController : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        if let previewImage = UIImage(data: imageData) {
            
            self.fixOrientation(img: previewImage) { image in
                
                self.showFullScreenImage(image) { isDone in
                    
                    if isDone {
                        
                        //                        self.selfImagesTOCompare.append(image)
                        //                        if self.selfImagesTOCompare.count == 2 {
                        
                        //                            FaceMatch.shared.matchFaces(self.selfImagesTOCompare[0], self.selfImagesTOCompare[1])
                        //                            self.selfImagesTOCompare.removeAll()
                        
                        //                            let similarity = self.selfImagesTOCompare[0].similarity(to: self.selfImagesTOCompare[1])
                        //
                        //                            print(similarity)
                        //                            print("Similarity found over here ")
                        //                            self.selfImagesTOCompare.removeAll()
                        //                        }
                        
                        //                        ****************************************
                        
                        guard let frontCardImg = self.inputDataDict[InputDataValues.cardFrontScaned.rawValue] as? UIImage else { return }
                        
                        VisionKitMethods.shared.faceDetection(frontCardImg) { detectedImg in
                            
                            if let img = detectedImg {
                                print("Image found ...")
                                
//                                FaceMatch.shared.matchFaces(img, image) { similarity, error in
////
//                                    if let error = error {
//                                        self.similarityLabel.text = "\(error.localizedDescription)"
//                                        return
//                                    }
//
//                                    let similarityStr = String(format: "%.5f", similarity ?? 0.0)
//                                    self.similarityLabel.text = "Similarity is: \(similarityStr)"
//                                }
                                
                                
                                /*
                                let similarity = img.similarity(to: image)
                                
                                print(similarity)
                                print("Similarity found over here ")
                                 */
                            }
                        }
                        
                        //                        ***********************************
                        
                        //                        let faceImg = UIImage(named: "self_img")!
                        //                        let similarity = image.similarity(to: faceImg)
                        //
                        //                        print(similarity)
                        //                        print("Similarity found over here ")
                    }
                }
            }
        }
    }
}

// MARK: - Camera View For MLKit Methods -

extension SelfieViewController {
    
    func addCameraViewDelegate() {
        cameraView.delegate = self
    }
    
    func startGestureDetection() {
        cameraView.beginSession()
    }
    
    func stopGestureDetection() {
        cameraView.stopSession()
    }
    
}

extension SelfieViewController: FacialGestureCameraViewDelegate {
   
    func doubleEyeBlinkDetected()
    {
        if currentGoingMode == .blink_eyes {
            //similarityLabel.text = "Double Eye Blink Detected"
            casesFullfillHandlings()
        }
    }

    func smileDetected() {
        if currentGoingMode == .smile {
            //similarityLabel.text = "Smile Detected"
            casesFullfillHandlings()
        }
    }

    func nodLeftDetected() {
        
        if currentGoingMode == .turn_left {
            //similarityLabel.text = "Left Detected"
            casesFullfillHandlings()
        }
    }

    func nodRightDetected() {
        
        if currentGoingMode == .turn_right {
            //similarityLabel.text = "Right Detected"
            casesFullfillHandlings()
        }
    }

    func leftEyeBlinkDetected() {
        
        return
        //similarityLabel.text = "Left Eye Blink Detected"
    }

    func rightEyeBlinkDetected() {
        //print("Right Eye Blink Detected")
        return
        //similarityLabel.text = "Right Eye Blink Detected"
    }
    
    func nodUpDetected() {
        if currentGoingMode == .move_up {
            //similarityLabel.text = "Face Up Detected"
            casesFullfillHandlings()
        }
    }
    
    func nodDownDetected()
    {
        if currentGoingMode == .move_down {
            
            //similarityLabel.text = "Face down Detected"
            casesFullfillHandlings()
        }
    }
    
    func faceDetectAtPosition() {
        self.showToast(with: true)
        modeHandlings()
    }
    
}
