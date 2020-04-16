//
//  BooksAPITests.swift
//  BooksAPITests
//
//  Created by Field Employee on 4/16/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import XCTest
@testable import BooksAPI
import SwiftyJSON

class BooksAPITests: XCTestCase {
  
  let mainVC: ViewController = ViewController()
  let testSearchBar = UISearchBar()
  var viewModel: BookViewModel = BookViewModel()
  
  func testModelViewCount1() {
    mainVC.viewModel = viewModel
    testSearchBar.searchTextField.text = "banana"
    mainVC.searchBarSearchButtonClicked(testSearchBar)
    XCTAssert(mainVC.favourites.count == viewModel.apiBooksToDisplay.count)
  }
  
  func testModelResetTest() {
    mainVC.viewModel = viewModel
    testSearchBar.searchTextField.text = "harry potter"
    mainVC.searchBarSearchButtonClicked(testSearchBar)
    mainVC.viewModel?.reset()
    testSearchBar.searchTextField.text = "apples"
    mainVC.searchBarSearchButtonClicked(testSearchBar)
    mainVC.viewModel?.reset()
    XCTAssert(mainVC.viewModel?.apiBooksToDisplay.count == 0)
  }
  
  func testModelView2() {
    let res = viewModel.modifySearchInput(searchString: "hello world    !")
    XCTAssert(res == "hello_world____!")
  }
  
  func testModelViewFail1() {
    let res = viewModel.modifySearchInput(searchString: "Sample__ ")
    XCTAssertNotEqual(res, "Sample__")
  }

  
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
