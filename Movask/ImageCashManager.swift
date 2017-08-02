//
//  ImageCashManager.swift
//  Movask
//
//  Created by Alina Yehorova on 02.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit
import AlamofireImage

class CacheManager {
    
    static var cachedImages = NSCache<AnyObject, AnyObject>()
    
    func setImageFor(imageView: UIImageView, path: String, imageID: Int) {
        
        if let cachedImage = getImage(id: imageID) {
            imageView.image = cachedImage
        } else {
            
            if let url = URL(string: path) {
                
                DispatchQueue.global(qos: .background).async {
                    imageView.af_setImage(withURL: url, completion: { [weak self] (response) in
                        if let image = response.value {
                            self?.saveImage(image, id: imageID)
                        }
                    })
                }
            }
        }
    }
    
    private func saveImage(_ image: UIImage, id: Int) {
        CacheManager.cachedImages.setObject(image, forKey: id as AnyObject)
    }
    
    private func getImage(id: Int) -> UIImage? {
        return CacheManager.cachedImages.object(forKey: id as AnyObject) as? UIImage
    }
}
