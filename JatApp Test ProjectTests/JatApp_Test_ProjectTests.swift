//
//  JatApp_Test_ProjectTests.swift
//  JatApp Test ProjectTests
//
//  Created by Yevhen Kononenko on 20.04.2023.
//

import XCTest
@testable import JatApp_Test_Project

final class JatApp_Test_ProjectTests: XCTestCase {
    let movieDetailsModel = MovieDetailsModel(
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
        var result = movieDetailsModel.countCharactersSorted(with: "a")
        XCTAssertEqual(result.map(\.1), [1])

        // Test case 2: Input contains multiple characters
        result = movieDetailsModel.countCharactersSorted(with: "abca")
        XCTAssertEqual(result.map(\.1), [2, 1, 1])

        // Test case 3: Input contains only whitespace characters
        result = movieDetailsModel.countCharactersSorted(with: "  \n")
        XCTAssertEqual(result.map(\.0), [])
    }
}
