//
//  FavouritesViewController.swift
//  BooksAPI
//
//  Created by Field Employee on 4/14/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class FavouritesViewController: UITableViewController {
  
  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
      if favouriteBooks.count > 0 {
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

    if let myImageView = cell.viewWithTag(9001) as? UIImageView {
      myImageView.image = UIImage(data: favouriteBooks[indexPath.row].image!) ?? UIImage(named: "heart.png")
    }
  
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    var books: [Book] = []
    do {
      books = try context.fetch(Book.fetchRequest())
    } catch {
      print("Could not Fetch.")
    }
    
    let book = Book(entity: Book.entity(), insertInto: context)
    book.author = favouriteBooks[indexPath.row].author
    book.desc = favouriteBooks[indexPath.row].desc
    book.image = favouriteBooks[indexPath.row].image
    book.title = favouriteBooks[indexPath.row].title
    
    for item in books {
      if item.author == book.author && item.desc == book.desc && item.title == book.title {
        context.delete(item)
      }
    }
    
    favouriteBooks.remove(at: indexPath.row)
    context.delete(book)
    appDelegate.saveContext()
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "favDisplay" {
      let dest = segue.destination as! DetailViewController
      if let cell = sender as? UITableViewCell {
        let indexPath = tableView.indexPath(for: cell)!
        dest.author = favouriteBooks[indexPath.row].author
        dest.myTitle = favouriteBooks[indexPath.row].title
        dest.desc = favouriteBooks[indexPath.row].desc
        dest.imageToDisplay = UIImage(data: favouriteBooks[indexPath.row].image!)
      }
    }
  }
  
}
