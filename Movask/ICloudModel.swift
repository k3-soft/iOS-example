//
//  ICloudModel.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import CloudKit

protocol ModelDelegate {
    func errorUpdating(_ error: NSError)
    func modelUpdated()
}

class ICloudModel {
    
    let establishmentType = "Token"
    static let sharedInstance = ICloudModel()
    var delegate: ModelDelegate?
    
    let container: CKContainer
    let privateDB: CKDatabase
    
    init() {
        container = CKContainer.default()
        privateDB = container.privateCloudDatabase
    }
    
    func getToken(completion: @escaping (_ results: [Token]?, _ error: Error?) -> ()) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: establishmentType, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { [unowned self] results, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdating(error! as NSError)
                    print("Cloud Query Error - Refresh: \(error)")
                    completion(nil, error!)
                }
                return
            }
            
            var tokens = [Token]()
            
            for record in results! {
                let token = Token(record: record)
                tokens.append(token)
            }
            
            print("Received \(tokens.count) tokens")
            
            DispatchQueue.main.async {
                self.delegate?.modelUpdated()
                completion(tokens, nil)
            }
        }
    }
    
    func writeToken(token: String) {
        
        let recordID = CKRecordID(recordName: "1")
        let postToken = CKRecord(recordType: establishmentType, recordID: recordID)
        postToken.setObject(token as CKRecordValue?, forKey: "Name")
        
        privateDB.save(postToken) { (record, error) in
            guard error == nil else {
                print("Error saving token: \(error?.localizedDescription)")
                return
            }
            print("Token saved successfully")
        }
    }
}
