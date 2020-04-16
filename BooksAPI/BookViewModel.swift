//
//  BookViewModel.swift
//  BooksAPI
//
//  Created by Field Employee on 4/14/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation
import SwiftyJSON

class BookViewModel {
  var apiBooksToDisplay: [BookData]
  
  init() {
    apiBooksToDisplay = []
  }
  
  func reset() {
    apiBooksToDisplay = []
  }
  
  func modifySearchInput(searchString: String) -> String {
    return searchString.replacingOccurrences(of: " ", with: "_")
  }
  
  func parseJSON(apiResults: JSON) {
    for item in apiResults["items"].arrayValue {
      let bookTitle: String = item["volumeInfo"]["title"].stringValue
      let bookAuthors: [String] = item["volumeInfo"]["authors"].object as? [String] ?? [""]
      let bookDescription: String = item["volumeInfo"]["description"].stringValue
      let thumbnailURL = item["volumeInfo"]["imageLinks"]["smallThumbnail"].stringValue
      
      apiBooksToDisplay.append(BookData(title: bookTitle, authors: bookAuthors, numAuthors: bookAuthors.count, description: bookDescription, thumbnailURL: thumbnailURL))
    }
  }
     
      /*
      let thumbnailSemaphore = DispatchSemaphore(value: 0)

      let imageURL = URL(string: item["volumeInfo"]["imageLinks"]["smallThumbnail"].stringValue)
      var bookThumbnail: UIImage?
      print("alright")
      
      if (imageURL == nil) {
        //itemToAppend.thumbnailImage = UIImage(named: "placeholder.png")
      } else {
        let session = URLSession(configuration: .default)
        session.dataTask(with: imageURL!) { (data, response, error) in
          // The download has finished.
          if let err = error {
            print("Error downloading picture: \(err)")
          } else {
            // No errors found.
            // It would be weird if we didn't have a response, so check for that too.
            if let _ = response as? HTTPURLResponse {
            //  print("Downloaded picture with response code \(res.statusCode)")
              if let imageData = data {
                let image = UIImage(data: imageData)
                bookThumbnail = image

              } else {
                print("Couldn't get image: Image is nil")
              }
            } else {
              print("Couldn't get response code for some reason")
            }
          }
          thumbnailSemaphore.signal()
        }.resume()
      }
      
    }*/
  /*
  func downloadImage(urlString: String) {
    let imageURL = URL(string: item["volumeInfo"]["imageLinks"]["smallThumbnail"].stringValue)
    let session = URLSession(configuration: .default)
    session.dataTask(with: imageURL!) { (data, response, error) in
      // The download has finished.
      if let err = error {
        print("Error downloading picture: \(err)")
      } else {
        // No errors found.
        // It would be weird if we didn't have a response, so check for that too.
        if let _ = response as? HTTPURLResponse {
        //  print("Downloaded picture with response code \(res.statusCode)")
          if let imageData = data {
            let image = UIImage(data: imageData)
            bookThumbnail = image

          } else {
            print("Couldn't get image: Image is nil")
          }
        } else {
          print("Couldn't get response code for some reason")
        }
      }
      thumbnailSemaphore.signal()
    }.resume()
  }*/
}
