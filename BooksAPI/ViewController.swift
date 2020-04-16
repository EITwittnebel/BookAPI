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
        } catch let error as NSError {
          print("Could not Fetch.")
        }
        
        let indexPath = searchTableView.indexPath(for: cell)
        let book = Book(entity: Book.entity(), insertInto: context)
        book.author = viewModel?.apiBooksToDisplay[indexPath!.row].authors[0]
        book.desc = viewModel?.apiBooksToDisplay[indexPath!.row].description
        book.image = viewModel?.apiBooksToDisplay[indexPath!.row].image?.pngData()
        book.title = viewModel?.apiBooksToDisplay[indexPath!.row].title
        
        if (heart.currentImage == UIImage(named: "heart.jpg")) {
          
          appDelegate.saveContext()
          favourites.append(book)
          
          print(favourites.count)
        
          heart.setImage(UIImage(named: "heart2.png"), for: .normal)
        } else {
          
          for item in books {
            if item.author == book.author && item.desc == book.desc && item.title == book.title {
              context.delete(item)
            }
          }
          
          for index in 0..<favourites.count {
            print(index)
            if ((favourites[index].author == book.author) && (favourites[index].desc == book.desc) && (favourites[index].title == book.title)) {
              favourites.remove(at: index)
              break
            }
          }
          
          context.delete(book)
          appDelegate.saveContext()
          print(favourites.count)
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
    /*
    let task = URLSession.shared.dataTask(with: jsonURL!, completionHandler: { (data, response, error) in
      let json: JSON = JSON(data)
      self.viewModel?.parseJSON(apiResults: json)
      
      DispatchQueue.main.async {
        self.searchTableView.reloadData()
      }
    })
    task.resume()
    */
    
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //TODO: loading wheel
    viewModel?.reset()
    
    let suffixString = viewModel!.modifySearchInput(searchString: searchBar.searchTextField.text ?? "")
    let prefixString = "https://www.googleapis.com/books/v1/volumes?q="
    let jsonURL = URL(string: prefixString + suffixString)
    
    let task = URLSession.shared.dataTask(with: jsonURL!, completionHandler: { (data, response, error) in
      let json: JSON = JSON(data)
      self.viewModel?.parseJSON(apiResults: json)
      
      for index in 0..<self.viewModel!.apiBooksToDisplay.count {
        let imageURL = self.viewModel!.apiBooksToDisplay[index].thumbnailURL
        if let theURL = URL(string: imageURL) {
          
          var imageTask = URLSession.shared.dataTask(with: theURL, completionHandler: { (data, response, error) in
            if let imageData = data {
              self.viewModel!.apiBooksToDisplay[index].image = UIImage(data: imageData)
              //print(self.viewModel!.apiBooksToDisplay[index].image?.size.width)
            }
            //print("TEST")
            
            DispatchQueue.main.async {
              self.searchTableView.reloadData()
            }
          })
          imageTask.resume()
        } else {
          self.viewModel!.apiBooksToDisplay[index].image = UIImage(named: "heart.png")
        }
      }
      
      DispatchQueue.main.async {
        self.searchTableView.reloadData()
      }
    })
    task.resume()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "favouriteSegue") {
      let dest = segue.destination as! FavouritesViewController
      dest.favouriteBooks = favourites
    }
    
    if (segue.identifier == "displaySegue") {
      let dest = segue.destination as! DetailViewController
      if let cell = sender as? UITableViewCell {
        
      }
    }
  }
}
