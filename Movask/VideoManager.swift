//
//  VideoManager.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

extension Notification.Name {
    static let errorLoadingThumbnail = Notification.Name("errorLoadingThumbnail")
}

class VideoManager {
    
    class func getThumbnailFromPath(_ url: URL, needRetry: Bool, success: @escaping (UIImage)->(), failure: @escaping ()->()) {
        
        DispatchQueue.global(qos: .background).async {
            
            let asset = AVURLAsset(url: url, options: nil)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(Float64(1), 100)
            
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: img)
                
                DispatchQueue.main.async {
                    success(image)
                }
            } catch {
                print("Error creating thumbnail image with url: \(url)")
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .errorLoadingThumbnail, object: nil)
                }
                
                if needRetry {
                    self.getThumbnailFromPath(url, needRetry: false, success: success, failure: failure)
                } else {
                    DispatchQueue.main.async {
                        failure()
                    }
                }
            }
        }
    }
    
    class func getOriginalVideoResolution(url: URL, completionHandler: @escaping (URL)->()) {
        
        let ti = Date().timeIntervalSinceReferenceDate
        let fileName = String(format: "%f.MOV", ti)
        let tmpFile = NSTemporaryDirectory().appending("/\(fileName)")
        
        let outputURL = URL(fileURLWithPath: tmpFile)
        
        let asset = AVURLAsset(url: url)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exportSession?.outputURL = outputURL
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.outputFileType = AVFileTypeQuickTimeMovie
        
        exportSession?.exportAsynchronously(completionHandler: {
            print("Video export done")
            let url = URL(fileURLWithPath: tmpFile)
            completionHandler(url)
        })
    }
}
