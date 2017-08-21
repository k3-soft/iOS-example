//
//  QRScannerVC.swift
//  Movask
//
//  Created by Alina Yehorova on 21.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerVC: BasicVC {
    
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var detectedText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = cameraView.layer.bounds
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.setVideoLayerOrientation()
        }
    }
    
    // MARK: - Set views
    
    func setNavigationBar() {
        
        title = "Scan QR code"
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.isTranslucent = false
            navigationBar.barTintColor = BrandColor.green
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont(name: MainFontSemibold, size: 18.0)!
            ]
        }
    }
    
    func setSession() {
        
        captureSession = QRManager.getSession(delegate: self)
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = cameraView.layer.bounds
        setVideoLayerOrientation()
        
        cameraView.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture
        captureSession?.startRunning()
    }
    
    func setVideoLayerOrientation() {
        
        let deviceOrientation = UIApplication.shared.statusBarOrientation
        if deviceOrientation == .landscapeLeft {
            videoPreviewLayer?.connection.videoOrientation = .landscapeLeft
        } else if deviceOrientation == .landscapeRight {
            videoPreviewLayer?.connection.videoOrientation = .landscapeRight
        }
    }
    
    // MARK: - Scan and receive quiz
    
    func acceptQRCode() {
        
        if detectedText != nil, let quizID = Int(detectedText!) {
            print("Detected ID is \(quizID)")
            startLoading()
            
            // TODO: Receive quiz from server
        }
    }
    
    func analyzeReceivedQuiz(_ quiz: QuizTest) {
        
        
    }
}

extension QRScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object
        if metadataObjects == nil || metadataObjects.isEmpty {
            return
        }
        
        if detectedText == nil {
            // Get the metadata object
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if metadataObj.type == AVMetadataObjectTypeQRCode {
                if metadataObj.stringValue != nil {
                    detectedText = metadataObj.stringValue
                    acceptQRCode()
                }
            }
        }
    }
}
