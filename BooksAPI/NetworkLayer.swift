//
//  NetworkLayer.swift
//  BooksAPI
//
//  Created by Field Employee on 4/18/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

func getJSON(searchString: String, table: UITableView, viewModel: BookViewModel?) {
  let suffixString = viewModel!.modifySearchInput(searchString: searchString)
  let prefixString = "https://www.googleapis.com/books/v1/volumes?q="
  let jsonURL = URL(string: prefixString + suffixString + "&maxResults=40")
  
  let task = URLSession.shared.dataTask(with: jsonURL!, completionHandler: { (data, response, error) in
    let json: JSON = JSON(data)
    viewModel?.parseJSON(apiResults: json)
    
    for index in 0..<viewModel!.apiBooksToDisplay.count {
      let imageURL = viewModel!.apiBooksToDisplay[index].thumbnailURL
      if let theURL = URL(string: imageURL) {
        
        var imageTask = URLSession.shared.dataTask(with: theURL, completionHandler: { (data, response, error) in
          if let imageData = data {
            viewModel!.apiBooksToDisplay[index].image = UIImage(data: imageData)
          }
          
          DispatchQueue.main.async {
            table.reloadData()
          }
        })
        imageTask.resume()
      } else {
        viewModel!.apiBooksToDisplay[index].image = UIImage(named: "heart.png")
      }
    }
    
    DispatchQueue.main.async {
      table.reloadData()
    }
  })
  task.resume()
}
