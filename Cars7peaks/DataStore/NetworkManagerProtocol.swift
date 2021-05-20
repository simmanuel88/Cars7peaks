//
//  NetworkManagerProtocol.swift
//  Cars7peaks
//
//  Created by Roche on 19/05/21.
//  
//

import Foundation

enum Result <T, E>{
    
    case success(T)
    case error(E)
}

protocol NetworkManagerProtocol {
    
    func fetchDataWith(completion: @escaping (Result<Data?, Error?>) -> Void)
}
