//
//  Cars.swift
//  Cars7peaks
//
//  Created by Roche on 19/05/21.
//

import UIKit

struct Cars: Codable {
        
    let title: String?
    let dateTime: String?
    let ingress: String?
    let image: String?
    
    // Define the coding keys
    enum CodingKeys: String, CodingKey {
        
        case title           = "title"
        case dateTime        = "dateTime"
        case ingress         = "ingress"
        case image           = "image"

    }
    
    // Initialize all values
    init(from decoder:Decoder) throws{
            // Get the container
            let container = try decoder.container(keyedBy: CodingKeys.self)
            // Get the values
            title = try container.decodeIfPresent(String.self, forKey: .title)
            dateTime = try container.decodeIfPresent(String.self, forKey: .dateTime)
            ingress = try container.decodeIfPresent(String.self, forKey: .ingress)
            image = try container.decodeIfPresent(String.self, forKey: .image)
    }
}
