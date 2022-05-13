//
//  AutoSearchManager.swift
//  MTG-Card-Search
//
//  Created by Nikolaj Høeg Jensen on 25/02/2021.
//

import Foundation


protocol SearchManagerDelegate {
    func didUpdateSearchResults(_ searchManager: SearchManager, searchResults: SearchModel)
    func didFailWithError(error: Error)
}

struct SearchManager {
    let searchURL = "https://api.scryfall.com/cards/autocomplete?q="
    
    var delegate: SearchManagerDelegate?

    func fetchSearchResults(searchString: String) {
        let searchStringRequest = searchString.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(searchURL)\(searchStringRequest)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString : String) {
        //1. Create URL
        if let url = URL(string: urlString) {
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                   if let searchResults = self.parseJSON(safeData) {
                    self.delegate?.didUpdateSearchResults(self, searchResults: searchResults)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ searchResultsData: Data) -> SearchModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SearchData.self, from: searchResultsData)
            
            let searchResultsArray = decodedData.data
            var newSearchResultsArray = [String]()
            
            //Removes quotation marks from the name of the card.
            for result in searchResultsArray! {
                let newResult = result.replacingOccurrences(of: "\"", with: "")
                newSearchResultsArray.append(newResult)
            }
            
         let searchResults = SearchModel(data: newSearchResultsArray)

            return searchResults
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}

