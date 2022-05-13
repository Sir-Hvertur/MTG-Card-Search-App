//
//  DetailViewController.swift
//  MTG-Card-Search
//
//  Created by Nikolaj Høeg Jensen on 20/03/2021.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var image: UIImageView!
    var imageName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.sd_setImage(with: URL(string: imageName!), placeholderImage: UIImage(named: "card back"), options: .continueInBackground, completed: nil)
        
    }


}
