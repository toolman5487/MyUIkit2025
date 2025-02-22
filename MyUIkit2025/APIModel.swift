//
//  APIModel.swift
//  MyUIkit2025
//
//  Created by Willy Hsu on 2025/2/3.
//

import Foundation
import Alamofire

class APIModel {
    static var share = APIModel()
    private init () {}
    private let apiURL = "https://randomuser.me/"
    
    func queryRandomUser(completion: @escaping (_ date: Data?, _ error: Error?)->()){
        let url = apiURL + "api/"
        let parameters:Parameters? = nil
        AF.request( url,
                    method: .get,
                    parameters: parameters,
                    encoding: URLEncoding.default).response { respons in
            switch respons.result{
            case .success(_):
                return completion(respons.data, nil)
            case .failure(let error):
                return completion(nil, error)
            
                
            }
            
        }
    }
}


