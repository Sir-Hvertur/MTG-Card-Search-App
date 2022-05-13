//
//  ViewController.swift
//  MTG-Card-Search
//
//  Created by Nikolaj Høeg Jensen on 19/02/2021.
//

import UIKit
import RealmSwift
import SDWebImage

class CardViewController: UIViewController {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var searchTextField: CustomSearchTextField!
    @IBOutlet weak var saveCardButton: UIButton!
    var cardManager = CardManager()
    var currentCard = CardModelRealm(cardName: "Ebon Praetor", imageName: "https://c1.scryfall.com/file/scryfall-cards/normal/front/6/4/6438dc8e-eb21-4db7-aeab-bb062acd6029.jpg?1562869024")

    let realm = try! Realm()
    var cards: Results<CardModelRealm>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        cardManager.delegate = self
        searchTextField.delegate = self
            cardManager.fetchCard(cardName: currentCard.cardName)
        
        loadCards()
        updateSaveSymbol(cardName: cardNameLabel.text!)
    }
// Changes the image of the save symbol depending on whether the card is saved in the collection or not.
    func updateSaveSymbol(cardName : String) {
        
        for c in cards! {
            
            if c.cardName == cardName && saveCardButton.currentImage?.imageAsset == UIImage(named: "saveImageSaved")?.imageAsset
            {
                saveCardButton.setImage(UIImage(named: "saveImageInitial"), for: .normal)
                deleteCard(card: c)
            }
            else if c.cardName == cardName && saveCardButton.currentImage?.imageAsset == UIImage(named: "saveImageInitial")?.imageAsset {
                saveCardButton.setImage(UIImage(named: "saveImageSaved"), for: .normal)
            }
        }
    }
    
    @IBAction func goToCollectionPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCollection", sender: self)
    }
    
    @IBAction func saveCardPressed(_ sender: UIButton) {
        
//        Avoids a card being saved if the cardName has been fetched, but the image is still loading.
        if currentCard.cardName != "Ebon Praetor" && currentCard.imageName == "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=1848&type=card" {
            return
        } else {
            saveCard(card: currentCard)
            updateSaveSymbol(cardName: currentCard.cardName)
            print("There is currently \(cards?.count ?? 0) cards in the collection view.")
        }
        
   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCollection" {
            let destinationVC = segue.destination as! CollectionTableViewController
            destinationVC.currentCardName = cardNameLabel.text ?? "Ebon Praetor"
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCard(card :CardModelRealm) {
        
        for card in cards! {
            if card.cardName == cardNameLabel.text {
                print("Already exists in the card collection")
                return
            }
        }
        do {
            try realm.write {
                let newCard = CardModelRealm(cardName: card.cardName, imageName: card.imageName)
                print("\(newCard.cardName) was saved to realm")
                realm.add(newCard)
            }
        } catch {
            print("Error saving card, \(error)")
        }
    }
    
    func loadCards() {
        cards = realm.objects(CardModelRealm.self)
    }
    
    func deleteCard(card: CardModelRealm) {
        do {
            try self.realm.write {
                self.realm.delete(card)
                print("card was deleted!")
            }
        } catch {
            print("Error deleting card, \(error)")
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension CardViewController: UITextFieldDelegate{
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        shouldTextFieldSearch()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldTextFieldSearch()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
            
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let card = searchTextField.text {
            cardManager.fetchCard(cardName: card)
        }
        searchTextField.text = ""
    }
    
    //Checks if there has been typed a proper search string.
    func shouldTextFieldSearch() {
        if searchTextField.text!.count >= 3 && searchTextField.resultsListArray?.count != 0 {
            if let searchString = searchTextField.resultsListArray?[0]  {
                searchTextField.text = searchString
                print(searchString)
                searchTextField.endEditing(true)
                searchTextField.tableView?.isHidden = true
            }
        }
        else {
            print("No results found with the current input.")
        }
    }
    
}
//MARK: - CardManagerDelegate
extension CardViewController: CardManagerDelegate {
    func didUpdateCard(_ cardManager: CardManager, card: CardModel) {
        DispatchQueue.main.async {
            self.currentCard.cardName = card.cardName ?? "Ebon Praetor"
            self.currentCard.imageName = card.imageName ?? "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=1848&type=card"
            
            self.cardNameLabel.text = card.cardName
            self.cardImageView.sd_setImage(with: URL(string: card.imageName!), placeholderImage: UIImage(named: "defaultCardImage"), options: .continueInBackground, completed: nil)
            self.cardImageView.heightAnchor.constraint(equalToConstant: 310).isActive = true
            self.cardImageView.widthAnchor.constraint(equalToConstant: 223).isActive = true
            
            self.saveCardButton.setImage(UIImage(named: "saveImageInitial"), for: .normal)
            self.updateSaveSymbol(cardName: card.cardName!)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}




