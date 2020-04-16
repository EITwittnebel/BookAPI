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
}
