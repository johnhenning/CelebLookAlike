//
//  SightEngine.swift
//  CelebrityLookAlikeDemo
//
//  Created by John Henning on 1/11/18.
//  Copyright © 2018 Knock. All rights reserved.
//

import Alamofire
import UIKit

let sightEngineURL = "https://api.sightengine.com/1.0/"

enum Check: String {
    case celebrities = "celebrities"
    case nudity = "nudity"
    case weaponsAlchoholDrugs = "wad"
    case faceAttributes = "face-attributes"
    case scam = "scam"
    case type = "type"
    case text = "text"
    case imageProperties = "properties"
}

class SightEngineParams {
    var APIUser: String?
    var APISecret: String?
}

class SightEngineClient {
    static let shared = SightEngineClient()
    private static let params = SightEngineParams()
    
    private var APIUser: String?
    private var APISecret: String?
    
    private init() {
        let apiUser = SightEngineClient.params.APIUser
        let apiSecret = SightEngineClient.params.APISecret
        
        
        guard apiUser != nil, apiSecret != nil else {
            fatalError("Error - you must call setupClient before accessing SightEnginerClient.shared")
        }
        
        APIUser = apiUser
        APISecret = apiSecret
    }
    
    class func setupClient(APIUser: String, APISecret: String) {
        SightEngineClient.params.APIUser = APIUser
        SightEngineClient.params.APISecret = APISecret
    }
    
    func checkImage(image: UIImage, check: Check, completion:@escaping(_:Any)->Void) {
        let url = formatURL(baseURL: sightEngineURL, check: check)
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let params = formatParameters(imageData: imageData!, check: check)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(imageData!, withName: "media", fileName: "image.jpg", mimeType: "image/jpg")
        }, to: url, method: .post) { result in
            
            switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        if let json = response.result.value {
                            completion(json)
                        } else {
                            completion(response.error!)
                        }
                    }
                    break
                case .failure(let encodingError):
                    completion(encodingError)
                    break
            }
        }
    }
    
    private func formatURL(baseURL: String, check: Check) -> String {
        var url = baseURL
        if !(check == .type || check == .imageProperties) {
            url += "check.json"
        } else if check == .type {
            url += "type.json"
        } else {
            url += "properties.json"
        }
        return url
    }
    
    private func formatParameters(imageData: Data, check: Check) -> [String: String] {
        var params: [String: String] = [
            "api_user": APIUser!,
            "api_secret": APISecret!,
            "media": String(data: imageData, encoding: .ascii)!
        ]
        
        if !(check == .type || check == .imageProperties) {
            params["models"] = check.rawValue
        }
        return params
    }
}
