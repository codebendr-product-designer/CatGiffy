//
//  Cat.swift
//  CatGiffy
//
//  Created by codebendr on 22/06/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation

struct Image: Codable {
    var id: String
    var url:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
    }
}
