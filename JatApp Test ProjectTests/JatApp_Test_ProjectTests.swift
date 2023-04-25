//
//  JatApp_Test_ProjectTests.swift
//  JatApp Test ProjectTests
//
//  Created by Yevhen Kononenko on 20.04.2023.
//

import XCTest
@testable import JatApp_Test_Project

final class JatApp_Test_ProjectTests: XCTestCase {
    let movieDetails = MovieDetailsViewController(
        movie: Top250DataDetails(
            id: "1",
            rank: "2",
            title: "Matrix",
            fullTitle: "",
            year: "",
            image: "",
            crew: "",
            imdbRating: "",
            imdbRatingCount: ""
        )
    )
    
    func testCountCharactersSorted() {
        // Test case 1: Input contains only one character
        var result = movieDetails.countCharactersSorted(with: "a")
        XCTAssertEqual(result.map(\.1), [1])
        
        // Test case 2: Input contains multiple characters
        result = movieDetails.countCharactersSorted(with: "abca")
        XCTAssertEqual(result.map(\.1), [2, 1, 1])
        
        // Test case 3: Input contains only whitespace characters
        result = movieDetails.countCharactersSorted(with: "  \n")
        XCTAssertEqual(result.map(\.0), [])
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
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
