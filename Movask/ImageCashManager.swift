//
//  ImageCashManager.swift
//  Movask
//
//  Created by Alina Yehorova on 02.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

typealias ImageCacheLoaderCompletionHandler = ((UIImage) -> ())

class CacheManager {
    
    static var cache = NSCache<NSString, UIImage>()
    
    var session: URLSession!
    
    init() {
        session = URLSession.shared
    }
    
    func obtainImageWithPath(_ imagePath: String, completionHandler: @escaping ImageCacheLoaderCompletionHandler) {
        
        if let image = CacheManager.cache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
        } else {
            
            let placeholder = UIImage(named: "ImageEmpty")!
            DispatchQueue.main.async {
                completionHandler(placeholder)
            }
            
            guard let url = URL(string: imagePath) else { return }
            let request = URLRequest(url: url)
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if data != nil, let img = UIImage(data: data!) {
                    CacheManager.cache.setObject(img, forKey: imagePath as NSString)
                    DispatchQueue.main.async {
                        completionHandler(img)
                    }
                }
            })
            task.resume()
        }
    }
}
