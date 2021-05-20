//
//  DataStoreProtocol.swift
//  Cars7peaks
//
//  Created by Roche on 19/05/21.
//  
//

import Foundation

protocol DataStoreProtocol {
    
    associatedtype T
    func rowsCount(for section:Int) -> Int
    func itemAt(indexPath: IndexPath) -> T?
}
