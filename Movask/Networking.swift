//
//  Networking.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkingDelegate: class {
    func uploadProgressChanged(progress: Double)
}

class Networking {
    
    weak var delegate: NetworkingDelegate?
    var uploadRequest: Request?
    
    func makeRequest(path: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
        
        let fullPath = BaseAPIUrl + path
        
        makeRequestToFullPath(path: fullPath, method: method, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    func makeRequestToFullPath(path: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
        
        var encoding: ParameterEncoding = URLEncoding.default
        if method != .get { encoding = JSONEncoding.default }
        
        Alamofire.request(path, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success(let data):
                success(data)
                
            case .failure(let error):
                
                print ("\n\(String(describing: method).uppercased()) \(path)")
                print ("ERROR: \(error.localizedDescription)")
                
                if let parameters = parameters {
                    print ("\nPARAMETERS:")
                    for item in parameters {
                        print (item)
                    }
                } else {
                    print ("\nPARAMETERS: nil")
                }
                
                if let headers = headers {
                    print ("\nHEADERS:")
                    for item in headers {
                        print (item)
                    }
                } else {
                    print ("\nHEADERS: nil")
                }
                
                if let debuggerLink = response.response?.allHeaderFields["X-Debug-Token-Link"] {
                    print("\nDEBUGGER LINK: \n\(debuggerLink)")
                }
                
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }
    
    func uploadData(fileURL: URL, parameters: [String:String], headers: HTTPHeaders?, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()){
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(fileURL, withName: "movie_file")
            
        }, to: "\(BaseAPIUrl)player-movies", method: .post, headers: headers, encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                self.uploadRequest = upload
                
                upload.uploadProgress(closure: { (progress) in
                    print(String(format: "Upload Progress: %.2f", progress.fractionCompleted))
                    self.delegate?.uploadProgressChanged(progress: progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    switch response.result {
                        
                    case .success(let data):
                        success(data)
                        
                    case .failure(let error):
                        print(response.result)
                        DispatchQueue.main.async {
                            failure(error)
                        }
                    }
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        })
    }
}

func JSONString(data: Any) -> String {
    
    if let JSONData = try? JSONSerialization.data(withJSONObject: data, options: []) {
        return String(data: JSONData, encoding: .utf8)!
    } else {
        return ""
    }
}
