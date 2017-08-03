//
//  QRManager.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit
import AVFoundation

class QRManager {
    
    class func getSession<T: AVCaptureMetadataOutputObjectsDelegate>(delegate: T) -> AVCaptureSession? {
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            // Initialize the captureSession object.
            let captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            return captureSession
            
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    class func generateQRCodeWith(text: String, andSize size: CGSize) -> CIImage? {
        
        let data = text.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        guard let qrcodeImage = filter?.outputImage else { return nil }
        
        // Scale for view size to avoid bluring
        let scaleX = size.width / qrcodeImage.extent.size.width
        let scaleY = size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        return transformedImage
    }
}
