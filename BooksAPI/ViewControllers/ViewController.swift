//
//  ViewController.swift
//  BooksAPI
//
//  Created by Field Employee on 4/13/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
import NVActivityIndicatorView

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var viewModel: BookViewModel?
  var favourites: [Book] = []
  
  @IBAction func favouriteButtonAction(_ sender: UIButton) {
    if let cell = sender.superview?.superview as? UITableViewCell {
      if let heart = cell.viewWithTag(2000) as? UIButton {
        
        var books: [Book] = []
        do {
          books = try context.fetch(Book.fetchRequest())
        } catch {
          print("Could not Fetch.")
        }
        
        let indexPath = searchTableView.indexPath(for: cell)
        let book = Book(entity: Book.entity(), insertInto: context)
        book.author = viewModel?.apiBooksToDisplay[indexPath!.row].authors[0]
        book.desc = viewModel?.apiBooksToDisplay[indexPath!.row].description
        book.image = viewModel?.apiBooksToDisplay[indexPath!.row].image?.pngData()
        book.title = viewModel?.apiBooksToDisplay[indexPath!.row].title
        
        if heart.currentImage == UIImage(named: "heart.jpg") {
          
          appDelegate.saveContext()
          favourites.append(book)
        
          heart.setImage(UIImage(named: "heart2.png"), for: .normal)
        } else {
          
          for item in books {
            if item.author == book.author && item.desc == book.desc && item.title == book.title {
              context.delete(item)
            }
          }
          
          for index in 0..<favourites.count {
            if favourites[index].author == book.author && favourites[index].desc == book.desc && favourites[index].title == book.title {
              favourites.remove(at: index)
              break
            }
          }
          
          context.delete(book)
          appDelegate.saveContext()
          heart.setImage(UIImage(named: "heart.jpg"), for: .normal)
        }
        
      }
    }

  }
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var searchTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    searchTableView.delegate = self
    searchTableView.dataSource = self
    
    searchBar.searchTextField.becomeFirstResponder()
    searchBar.delegate = self
    
    viewModel = BookViewModel()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    do {
      favourites = try context.fetch(Book.fetchRequest())
    } catch let error as NSError {
      print("Could not fetch. \(error)")
    }
    searchTableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel!.apiBooksToDisplay.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //get from modelview
    let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
    //cell.textLabel!.text = "\(indexPath.row)"
        
    if let author = cell.viewWithTag(1000) as? UILabel {
      if (viewModel!.apiBooksToDisplay[indexPath.row].authors.count > 0) {
        author.text = viewModel?.apiBooksToDisplay[indexPath.row].authors[0]
      } else {
        author.text = "Loading"
      }
    }
    
    if let title = cell.viewWithTag(1001) as? UILabel {
      title.text = viewModel?.apiBooksToDisplay[indexPath.row].title
    }
    
    if let heart = cell.viewWithTag(2000) as? UIButton {
      var isfavourite: Bool = false
      for item in favourites {
        if item.author == viewModel?.apiBooksToDisplay[indexPath.row].authors[0]
          && item.title == viewModel?.apiBooksToDisplay[indexPath.row].title
          && item.desc == viewModel?.apiBooksToDisplay[indexPath.row].description {
          heart.setImage(UIImage(named: "heart2.png"), for: .normal)
          isfavourite = true
          break
        }
      }
      
      if !isfavourite {
        heart.setImage(UIImage(named: "heart.png"), for: .normal)
      }
      heart.backgroundColor = .clear
    }
    
    if let myImageView = cell.viewWithTag(9001) as? UIImageView {
      myImageView.image = viewModel?.apiBooksToDisplay[indexPath.row].image ?? UIImage(named: "heart.png")
    }
    return cell
    
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel?.reset()
    getJSON(searchString: searchBar.searchTextField.text ?? "", table: self.searchTableView, viewModel: viewModel)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "favouriteSegue" {
      let dest = segue.destination as! FavouritesViewController
      dest.favouriteBooks = favourites
    }
    
    if segue.identifier == "displaySegue" {
      let dest = segue.destination as! DetailViewController
      if let cell = sender as? UITableViewCell {
        let indexPath = searchTableView.indexPath(for: cell)!
        dest.author = viewModel?.apiBooksToDisplay[indexPath.row].authors[0]
        dest.myTitle = viewModel?.apiBooksToDisplay[indexPath.row].title
        dest.desc = viewModel?.apiBooksToDisplay[indexPath.row].description
        dest.imageToDisplay = viewModel?.apiBooksToDisplay[indexPath.row].image
      }
    }
  }
}
