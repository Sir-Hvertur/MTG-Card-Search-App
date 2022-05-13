//
//  CollectionTableViewController.swift
//  MTG-Card-Search
//
//  Created by Nikolaj Høeg Jensen on 05/03/2021.
//

import UIKit
import RealmSwift
import SDWebImage

class CollectionTableViewController: SwipeTableViewController {
//    UITableViewController
    let realm = try! Realm()
    var cards: Results<CardModelRealm>?
    var currentCardName: String?
    var imageName: String?
    var cardController = CardViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCards()
//        self.tableView.rowHeight = 200
//        self.tableView.backgroundColor = .black
        tableView.register(UINib(nibName: "WholeCardCell", bundle: nil), forCellReuseIdentifier: "CollectionCell")
    }    

    @IBAction func backToSearchPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToSearch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearch" {
            let destinationVC = segue.destination as! CardViewController
            destinationVC.currentCard.cardName = currentCardName ?? "Ebon Praetor"
        } else if segue.identifier == "goToEnlargedImage" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.imageName = imageName
    }
    }
    //MARK: - Data Manipulation Methods

    func loadCards() {
        cards = realm.objects(CardModelRealm.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let cardForDeletion = self.cards?[indexPath.row]
        {
            do {
                try self.realm.write {
                    self.realm.delete(cardForDeletion)
                }
            } catch {
                print("Error deleting card, \(error)")
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! WholeCardCell
    
        cell.cardImageView.sd_setImage(with: URL(string: (cards?[indexPath.row].imageName)!), placeholderImage: UIImage(named: "defaultCardImage"), options: .continueInBackground, completed: nil)
    
        cell.cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.cardImageView.widthAnchor.constraint(equalToConstant: 223).isActive = true
        cell.cardNameLabel.text = cards?[indexPath.row].cardName

        cell.delegate = self
        
        return cell
    }
    
    
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let card = cards?[indexPath.row]
        {
            imageName = card.imageName
            performSegue(withIdentifier: "goToEnlargedImage", sender: self)

        }
    }

}
