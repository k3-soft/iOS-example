//
//  APIManager.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum ServerRequestError: Error {
    case emptyResponse
    case errorServer
    case errorAuthorization
}

class APIManager {
    
    let networking = Networking()
    
    private func getAuthorizationHeader() -> [String:String]? {
        guard let token = AuthorizationManager.token else { return nil }
        return ["device-id": token]
    }
    
    // MARK: - Profile
    
    func getCurrentUser(success: @escaping (Any)->(), failure: @escaping (Error)->()) {
        
        guard let header = getAuthorizationHeader() else {
            failure(ServerRequestError.errorAuthorization)
            return
        }
        
        networking.makeRequest(path: "profiles/own", method: .get, parameters: nil, headers: header, success: success, failure: failure)
    }
    
//    func updateUserProfile(userID: Int, data: ProfileForm, success: @escaping (Any)->(), failure: @escaping (Error)->()) {
//        
//        guard let header = getAuthorizationHeader() else {
//            failure(ServerRequestError.errorAuthorization)
//            return
//        }
//        
//        
//        let parameters = Mapper<ProfileForm>().toJSON(data)
//        
//        networking.makeRequest(path: "profiles/\(userID)", method: .patch, parameters: parameters, headers: header, success: success, failure: failure)
//    }
    
    // MARK: - Get commerce
    
    func getBuySellOffering(page: Int, success: @escaping (Any)->(), failure: @escaping (Error)->()) {
        
        guard let header = getAuthorizationHeader() else {
            failure(ServerRequestError.errorAuthorization)
            return
        }
        
        let parameters: Parameters = ["page": page,
                                      "sort": "offeringsBuySell.id"]
        
        networking.makeRequest(path: "commerce/offerings_buy_sell", method: .get, parameters: parameters, headers: header, success: success, failure: failure)
    }
    
    // MARK: - Delete
    
    func deleteComment(commentID: Int, success: @escaping (Any)->(), failure: @escaping (Error)->()) {
        
        guard let header = getAuthorizationHeader() else {
            failure(ServerRequestError.errorAuthorization)
            return
        }
        
        networking.makeRequest(path: "comments/\(commentID)", method: .delete, parameters: nil, headers: header, success: success, failure: failure)
    }
    
    // MARK: - New post
    
    func createBuySellPost(object: Mappable, path: String, success: @escaping (Any)->(), failure: @escaping (Error)->()) {
        
        guard let header = getAuthorizationHeader() else {
            failure(ServerRequestError.errorAuthorization)
            return
        }
        
//        var parameters: Parameters?
//        if object is OfferingBuySellForm {
//            parameters = Mapper<OfferingBuySellForm>().toJSON(object as! OfferingBuySellForm)
//        } else {
//            parameters = Mapper<LookingForBuySellForm>().toJSON(object as! LookingForBuySellForm)
//        }
        
        networking.makeRequest(path: path, method: .post, parameters: nil, headers: header, success: success, failure: failure)
    }
    
    // MARK: - Videos
    
    func addVideoWithFileURL(_ fileURL: URL, collectionID: Int, networking: Networking, success: @escaping (Any)->(), failure: @escaping (Error)->()) {
        
        guard let languageID = UserDefaultsManager.default.getValue(valueType: Int.self, forKey: .kLanguageID) else { return }
        
        let parameters = ["language_id": "\(languageID)",
                          "collection_id": "\(collectionID)"]
        
        var headers = getAuthorizationHeader()
        headers?["Content-Type"] = "form-data"
        
        networking.uploadData(fileURL: fileURL, parameters: parameters, headers: headers, success: success, failure: failure)
    }
}

