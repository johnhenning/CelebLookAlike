//
//  ImageSearch.swift
//  CelebrityLookAlikeDemo
//
//  Created by John Henning on 1/11/18.
//  Copyright © 2018 Knock. All rights reserved.
//

import Alamofire
import UIKit

private class ImageSearchParams {
    var APIKey: String?
    var CustomSearchKey: String?
}

class ImageSearch {
    static let shared = ImageSearch()
    private static let imageSearchParams = ImageSearchParams()
    
    private var APIKey: String?
    private var CustomSearchKey: String?
    
    private init() {
        let apiKey = ImageSearch.imageSearchParams.APIKey
        let customSearchKey = ImageSearch.imageSearchParams.CustomSearchKey
        
        guard apiKey != nil, customSearchKey != nil else {
            fatalError("Error - you must call setupImageSearch before accessing ImageSearch.shared")
        }
        
        APIKey = apiKey
        CustomSearchKey = customSearchKey
    }
    
    class func setupImageSearch(APIKey: String, CustomSearchKey: String) {
        ImageSearch.imageSearchParams.APIKey = APIKey
        ImageSearch.imageSearchParams.CustomSearchKey = CustomSearchKey
    }
    
    func getImageURLWithSearchResult(searchTerm: String, completion:@escaping(_:Any)->Void) {
        let params = formatParameters(searchTerm: searchTerm)
        
        
        Alamofire.request("https://www.googleapis.com/customsearch/v1", method: .get, parameters: params, encoding: URLEncoding.queryString).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                if let error = json["error"] {
                    print(error)
                    completion(error)
                    return
                }
                let items = json["items"] as? [[String: Any]]
                let imageURL = URL(string: (items![0]["link"] as? String)!)
                completion(imageURL!)
            } else {
                let error = response.error!
                completion(error)
            }
        }
    }
    
    private func formatParameters(searchTerm: String, numResults: Int? = 3) -> Parameters {
        let params: Parameters = [
            "q": searchTerm,
            "num": numResults!,
            "imgSize": "medium",
            "searchType": "image",
            "key": APIKey!,
            "cx": CustomSearchKey!
            
        ]
        return params
    }
}

