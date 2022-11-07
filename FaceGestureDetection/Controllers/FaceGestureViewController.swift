//
//  FaceGestureViewController.swift
//  FaceGestureDetection
//
//  Created by Naeem Hussain on 07/11/2022.
//

import UIKit

class FaceGestureViewController: UIViewController {

    @IBOutlet weak var cameraView: FacialGestureCameraView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addCameraViewDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startGestureDetection()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopGestureDetection()
    }
}

extension FaceGestureViewController{
    
    private func addCameraViewDelegate() {
        cameraView.delegate = self
    }
    
    private func startGestureDetection() {
        cameraView.beginSession()
    }
    
    private func stopGestureDetection() {
        cameraView.stopSession()
    }
}

extension FaceGestureViewController: FacialGestureCameraViewDelegate {
    
    func doubleEyeBlinkDetected() {
        statusLabel.text = "Double Eye Blink Detected"
        //print("Double Eye Blink Detected")
    }

    func smileDetected() {
        statusLabel.text = "Smile Detected"
        //print("Smile Detected")
    }

    func nodLeftDetected() {
        statusLabel.text = "Nod Left Detected"
        //print("Nod Left Detected")
    }

    func nodRightDetected() {
        statusLabel.text = "Nod Right Detected"
        //print("Nod Right Detected")
    }

    func leftEyeBlinkDetected() {
        statusLabel.text = "Left Eye Blink Detected"
        //print("Left Eye Blink Detected")
    }

    func rightEyeBlinkDetected() {
        statusLabel.text = "Right Eye Blink Detected"
        //print("Right Eye Blink Detected")
    }
    
}
