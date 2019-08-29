//
//  FlickrImageAPITests.swift
//  FlickrImageTests
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

@testable import FlickrImage
import XCTest

class FlickrImageAPITests: XCTestCase {
    
    var sut: FlickrImageAPI!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPageShouldBeOneWhenFetchPhotosCalledFirstTime()
    {
        // When
        sut = FlickrImageAPI()
        let expect = expectation(description: "Wait for fetchPhotos() to return")
        sut.fetchPhotos(text: "Dog", completionHandler: {(photos) in
            expect.fulfill()
        })
        waitForExpectations(timeout: 3.0)
        
        // Then
        print(sut.page)
        XCTAssertEqual(sut.page, 1, "page should be 1 when fetchPhotos() called first time")
    }
    
    func testPageShouldBeTwoWhenFetchPhotosCalledWithSameItem()
    {
        // When
        sut = FlickrImageAPI()
        let searchText = "Cat"
        let expect = expectation(description: "Wait for fetchPhotos() to return")
        sut.fetchPhotos(text: searchText, completionHandler: {(photos) in
            expect.fulfill()
        })
        waitForExpectations(timeout: 3.0)
        
        let expect2 = expectation(description: "Wait for fetchPhotos() to return")
        sut.fetchPhotos(text: searchText, completionHandler: {(photos) in
            expect2.fulfill()
        })
        waitForExpectations(timeout: 3.0)
        
        // Then
        XCTAssertEqual(sut.page, 2, "page should be 2 when fetchPhotos() called first time")
    }
}
