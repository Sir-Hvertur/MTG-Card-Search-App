//
//  CardManager.swift
//  MTG-Card-Search
//
//  Created by Nikolaj Høeg Jensen on 23/02/2021.
//

import Foundation


protocol CardManagerDelegate {
    func didUpdateCard(_ cardManager: CardManager, card: CardModel)
    func didFailWithError(error: Error)
}

struct CardManager {
    let cardURL = "https://api.scryfall.com/cards/named?fuzzy="
    var correctCardName: String?
    var delegate: CardManagerDelegate?
    
    mutating func fetchCard(cardName: String) {
        let cardNameRequest = cardName.replacingOccurrences(of: " ", with: "%20")
        self.correctCardName = cardName
        print("\(cardName) was entered.")
        let urlString = "\(cardURL)\(cardNameRequest)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String) {
        //1. Create URL
        if let url = URL(string: urlString) {
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, resonse, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let card = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCard(self, card: card)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ cardData: Data) -> CardModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CardData.self, from: cardData)
            
            let name = decodedData.name
            let image = decodedData.image_uris.normal
            
            let card = CardModel(cardName: name,imageName: image)

            return card
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
