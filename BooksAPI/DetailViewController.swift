//
//  DetailViewController.swift
//  BooksAPI
//
//  Created by Field Employee on 4/14/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBAction func backButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var bookTitle: UILabel!
  @IBOutlet weak var bookAuthor: UILabel!
  @IBOutlet weak var bookDesc: UILabel!
  
  var imageToDisplay: UIImage?
  var myTitle: String?
  var author: String?
  var desc: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = imageToDisplay
    bookTitle.text = myTitle
    bookDesc.text = desc
    bookAuthor.text = author
  }
  
}
