//
//  ScanCardViewController.swift
//  KnowFace
//
//  Created by Naeem Hussain on 21/10/2022.
//

import UIKit
import AVFoundation
import CoreML

class ScanCardViewController: BaseViewController {

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
    
    var inputDataDict : [String: Any] = [:]
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickers = UIImagePickerController()
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            imagePickers.delegate = self
            imagePickers.sourceType = UIImagePickerController.SourceType.camera
            print("camera bonud", self.cameraView.bounds)
            var rect = CGRect(x: scanLayerView.bounds.minX, y: scanLayerView.bounds.minY, width: scanLayerView.bounds.width * 0.99, height: UIScreen.main.bounds.height * 0.5)
            print("scanLayerView bonud", rect)
            imagePickers.view.frame = rect
            imagePickers.allowsEditing = false
            imagePickers.showsCameraControls = false
        }
        return imagePickers
    }()
    
    
    // MARK: - Controller's Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //setupCaptureSession()
     
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //addCameraInView()
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
    
    private func addCameraInView(){
        // Add the imageviewcontroller to UIView as a subview

        self.scanLayerView.addSubview((imagePickerController.view))
    }
    
    private func addCameraLayerAndScanLayer(){
        // Draw a graphics with a mostly solid alpha channel
        // and a square of "clear" alpha in there.

        UIGraphicsBeginImageContext(UIScreen.main.bounds.size)
        let cgContext = UIGraphicsGetCurrentContext()
        
        cgContext?.fill(UIScreen.main.bounds)
        
        let rect = CGRect(x:self.scanLayerView.frame.origin.x, y:self.scanLayerView.frame.origin.y, width: self.scanLayerView.bounds.width, height: self.scanLayerView.bounds.height )
        
        cgContext?.clear(rect)
        //drawBlueCircle(in: cgContext!, bounds: rect)
       
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
        
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            self.imagePickerController.takePicture()
//        } else{
//            print("Error on taking picture")
//        }
    }
    
    @IBAction func rotateAction(_ sender: UIButton)
    {
        
//        if imagePickerController.cameraDevice == .front  {
//            imagePickerController.cameraDevice = .rear
//        }
//        else {
//            imagePickerController.cameraDevice = .front
//        }
        
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

// MARK: - AVCapturePhotoCaptureDelegate Methods -
extension ScanCardViewController : AVCapturePhotoCaptureDelegate
{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        if let previewImage = UIImage(data: imageData) {
            
            let width = self.scanLayerView.bounds.width
            let height = self.scanLayerView.bounds.height
            
            self.fixOrientation(img: previewImage) { orientedImage in
                    
                self.capturedImage = orientedImage
                let scanVm = ScanCard()
                scanVm.delegate = self
                scanVm.scanCard(from: orientedImage)
            }
//                self.textRecognizeFromImage(image) { modelArr in
//
//                    if let modelArr = modelArr {
//
//                        DispatchQueue.main.async {
//                            let scanVC = self.storyboard?.instantiateViewController(withIdentifier: "ScanCardBackViewController") as! ScanCardBackViewController
//                            scanVC.scanTextArr = modelArr
//                            self.navigationController?.pushViewController(scanVC, animated: true)
//                        }
//                    }
//                }
                
//                self.populateTextDataIntoModel(self.tempIDCardTextArray) { modelArr in
//                    if let modelArr = modelArr {
//
//                        DispatchQueue.main.async {
//                            let scanVC = self.storyboard?.instantiateViewController(withIdentifier: "ScanCardBackViewController") as! ScanCardBackViewController
//                            scanVC.scanTextArr = modelArr
//                            self.navigationController?.pushViewController(scanVC, animated: true)
//                        }
//                    }
//                }
                
               
//                self.drawFeatures(in: image) { modelArr in
//
//                    if let modelArr = modelArr {
//
//                        self.faceFind(image) { faceImage in
//
//                        }
//                    }
//                }
//            }
        }
    }
}

extension ScanCardViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            //self.drawFeatures(in: image)
            let width = self.scanLayerView.bounds.width
            let height = self.scanLayerView.bounds.height
            self.fixOrientation(img: image) { orientedImage in
                            
                self.capturedImage = orientedImage
                let scanVm = ScanCard()
                scanVm.delegate = self
                scanVm.scanCard(from: orientedImage)
            }
        }
    }
}

extension ScanCardViewController : ScanCardDelegate
{
    func didReceiveImage(scanedImage: UIImage) {
        
        self.inputDataDict[InputDataValues.cardFrontScaned.rawValue] = scanedImage
        showImageForPreview(scanedImage)
    }
    
    func didFailedWithError(error: String) {
        
        showImageForPreview(self.capturedImage)
//        self.showAlert(title: "Error", message: error)
    }
    
    
    func showImageForPreview(_ image: UIImage)
    {
        self.showFullScreenImage(image) { isDone in
            
            if isDone {
                
                self.inputDataDict[InputDataValues.cardFrontOrginal.rawValue] = self.capturedImage
                
                DispatchQueue.main.async {
                    let scanVC = self.storyboard?.instantiateViewController(withIdentifier: "ScanCardBackViewController") as! ScanCardBackViewController
                    scanVC.inputDataDict = self.inputDataDict
                    self.navigationController?.pushViewController(scanVC, animated: true)
                }
            }
        }
    }
}

