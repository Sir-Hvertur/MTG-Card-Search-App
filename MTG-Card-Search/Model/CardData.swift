//
//  cardData.swift
//  MTG-Card-Search
//
//  Created by Nikolaj Høeg Jensen on 23/02/2021.
//

import Foundation

struct CardData: Codable {
    let name: String?
    let image_uris: Image_uris
}

struct Image_uris: Codable {
    let normal: String?
}
