//
//  ImageModel.swift
//  Zapp
//
//  Created by Nived Pradeep on 15/01/24.
//

import Foundation

struct ImageModel:Codable {
    let id:String
    let urls:ImageUrls
}

struct ImageUrls:Codable {
    let regular:String
}
