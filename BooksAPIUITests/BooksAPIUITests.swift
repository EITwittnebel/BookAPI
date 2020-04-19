//
//  BooksAPIUITests.swift
//  BooksAPIUITests
//
//  Created by Field Employee on 4/18/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import XCTest

class BooksAPIUITests: XCTestCase {

  
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    let app = XCUIApplication()
    app.launchArguments.append("--uitesting")

  }
  
  func testGoingThroughOnboarding() {
    var app = XCUIApplication()
    app.launchArguments.append("--uitesting")
    app.launch()
    
    XCTAssertTrue(app.isEnabled)
    
    XCTAssert(app.searchFields.count == 1)
    XCTAssert(app.buttons.count == 1)
    app.buttons["Favourites"].press(forDuration: 0.5)
    
    XCTAssert(app.tables.count == 1)
  }
  
  
  
      override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}