//
//  CarsViewModel.swift
//  Cars7peaks
//
//  Created by Roche on 19/05/21.
//

import UIKit

struct CarsViewModel {
    
    let title: String?
    let image: String?
    let ingress: String?
    let dateTime: String?
    let thumbnail: UIImage?
    
    init(with carItem: CarItem){
        // TODO: Guard'
        self.title = carItem.title as? String
        self.image = carItem.image as? String
        self.ingress = carItem.ingress as? String
        self.dateTime = carItem.dateTime as? String
        self.thumbnail = carItem.thumbnail as? UIImage
    }

}
