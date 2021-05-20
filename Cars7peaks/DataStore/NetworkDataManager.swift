//
//  NetworkDataManager.swift
//  Cars7peaks
//
//  Created by Roche on 19/05/21.
//  
//

import Foundation
import Alamofire
import AlamofireURLCache5

class NetworkDataManager: NSObject{
    
    // Create a singleton
    private override init() {
        
    }
    static let _shared = NetworkDataManager()
    
    class func shared()-> NetworkDataManager{
        
        return _shared
    }
}

extension NetworkDataManager: NetworkManagerProtocol{
    
    func fetchDataWith(completion: @escaping (Result<Data?, Error?>) -> Void) {
        
        AF.request("https://www.apphusetreach.no/application/119267/article/get_articles_list")
            .validate()
            .responseJSON { (response) in
                
              /*  guard response.result else{
                    let err = NSError(domain: "Unknown", code: 0, userInfo: nil)
                    completion(.error(err))
                    return
               }*/
                                
                guard let json = response.data else{
                    let err = NSError(domain: "Unknown", code: 0, userInfo: nil)
                    completion(.error(err))
                    return
                }
                
                completion(.success(json))
                
            }.cache(maxAge: 100)
    }
    
    
}
