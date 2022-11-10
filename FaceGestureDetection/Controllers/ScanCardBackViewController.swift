//
//  ScanCardBackViewController.swift
//  KnowFace
//
//  Created by Naeem Hussain on 26/10/2022.
//

import UIKit
import AVFoundation

class ScanCardBackViewController: BaseViewController {

    // MARK: - Navigation -
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraLayer: UIView! {
            didSet{
                //self.cameraLayer.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            }
        }
    @IBOutlet weak var scanLayerView: UIView!
    
    
    // MARK: - Declarations -
    
    
    private let photoOutput = AVCapturePhotoOutput()
    private var captureSession : AVCaptureSession! = nil
    private var capturedImage = UIImage()
    var inputDataDict = [String: Any]()
    
    // MARK: - Controller's Lifecycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCaptureSession()
    }


    // MARK: - custom Methods -
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch let error {
                print("Failed to set input device with error: \(error)")
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraLayer.frame = UIScreen.main.bounds //self.cameraView.bounds
            cameraLayer.videoGravity = .resizeAspectFill
            //cameraLayer.cornerRadius = 20
            self.cameraView.layer.addSublayer(cameraLayer)
            captureSession.startRunning()
            
            addCameraLayerAndScanLayer()
        }
    }
    
    private func addCameraLayerAndScanLayer(){
        // Draw a graphics with a mostly solid alpha channel
        // and a square of "clear" alpha in there.

        UIGraphicsBeginImageContext(UIScreen.main.bounds.size)
        let cgContext = UIGraphicsGetCurrentContext()
        cgContext?.fill(UIScreen.main.bounds)
        cgContext?.clear(CGRect(x:self.scanLayerView.frame.origin.x, y:self.scanLayerView.frame.origin.y, width: self.scanLayerView.bounds.width, height: self.scanLayerView.bounds.height ))
        let maskImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Set the content of the mask view so that it uses our
        // alpha channel image
        let maskView = UIView(frame: UIScreen.main.bounds)
        maskView.layer.contents = maskImage?.cgImage
        self.cameraLayer.mask = maskView
    }
    
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

extension ScanCardBackViewController : AVCapturePhotoCaptureDelegate
{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        if let previewImage = UIImage(data: imageData) {
            
            let width = self.scanLayerView.bounds.width
            let height = self.scanLayerView.bounds.height
            
            self.fixOrientation(img: previewImage) { image in
                self.capturedImage = image
                let scanVm = ScanCard()
                scanVm.delegate = self
                scanVm.scanCard(from: image)
            }
        }
    }
}

extension ScanCardBackViewController : ScanCardDelegate {
    
    func didReceiveImage(scanedImage: UIImage) {
        
        showImageForPreview(scanedImage)
        inputDataDict[InputDataValues.cardBackScaned.rawValue] = scanedImage
    }
    
    func didFailedWithError(error: String) {
        
        //self.showAlert(title: "Error", message: error)
        showImageForPreview(self.capturedImage)
    }
    
    func showImageForPreview(_ image: UIImage)
    {
        self.showFullScreenImage(image) { isDone in
            
            if isDone {
                
                self.inputDataDict[InputDataValues.cardBackOrginal.rawValue] = self.capturedImage
                DispatchQueue.main.async {
                    let detectionOptVc = self.storyboard?.instantiateViewController(withIdentifier: "LivenessDetectionViewController") as! LivenessDetectionViewController
                    detectionOptVc.inputDataDict = self.inputDataDict
                    self.navigationController?.pushViewController(detectionOptVc, animated: true)
                }
            }
        }
    }
    
}

//extension ScanCardBackViewController {
//    
//    private func textRecognizeFromImage(_ image: UIImage, _ compeletion: @escaping(([PopupFields])?) -> ())
//    {
//        guard let cgImage = image.cgImage else {return}
//        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
//
//        let request = VNRecognizeTextRequest { request, error in
//            
//            guard let observations =
//                    request.results as? [VNRecognizedTextObservation] else {
//                
//                compeletion(nil)
//                return
//            }
//            let recognizedStrings = observations.compactMap { observation in
//                
//                return observation.topCandidates(1).first?.string
//            }
//            
//            self.populateTextDataIntoModel(recognizedStrings) { detailModelArr in
//                
//                compeletion(detailModelArr)
//            }
//        }
//            
//        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
//        request.recognitionLanguages = ["en","ur"]
//        
//        do {
//            
//            try requestHandler.perform([request])
//        } catch {
//            
//            self.showAlert(title: "Error", message: "Unable to perform the requests: \(error).")
//        }
//    }
//    
//    func populateTextDataIntoModel(_ fullScanArr: [String], _ compeletion: @escaping(([PopupFields])?) -> ())
//    {
//        var detailObj = [PopupFields]()
//        
//        let group = DispatchGroup()
//        
//        for (index, element) in fullScanArr.enumerated() {
//            
//         
//        }
//        
//        group.notify(queue: .main, execute: { // executed after all async calls in for loop finish
//            print("done with all async calls")
//            if detailObj.count == 5 {
//                print("Object is Ready to")
//                compeletion(detailObj)
//            }
//        })
//    }
//}
