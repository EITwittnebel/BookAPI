//
//  FavouritesViewController.swift
//  BooksAPI
//
//  Created by Field Employee on 4/14/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class FavouritesViewController: UITableViewController {
  
 // private let appDelegate = UIApplication.shared.delegate as! AppDelegate
 // private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var favouriteBooks: [Book] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favouriteBooks.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
    
    if let author = cell.viewWithTag(1000) as? UILabel {
      if (favouriteBooks.count > 0) {
        author.text = favouriteBooks[indexPath.row].author
      } else {
        author.text = "Loading"
      }
    }
    
    if let title = cell.viewWithTag(1001) as? UILabel {
      title.text = favouriteBooks[indexPath.row].title
    }
    
    if let heart = cell.viewWithTag(2000) as? UIButton {
      heart.setImage(UIImage(named: "heart2.png"), for: .normal)
    }
  
    return cell
  }
  
}
