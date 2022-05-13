//
//  CardModelRealm.swift
//  MTG-Card-Search
//
//  Created by Nikolaj Høeg Jensen on 05/03/2021.
//

import Foundation
import RealmSwift

class CardModelRealm : Object {
    @objc dynamic var cardName : String = ""
    @objc dynamic var imageName : String = ""
    
    convenience init(cardName: String, imageName: String) {
        self.init()

        self.cardName = cardName
        self.imageName = imageName
    }
}
