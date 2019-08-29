//
//  PhotosWorkerTests.swift
//  FlickrImageTests
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//
@testable import FlickrImage
import XCTest

class PhotosWorkerTests: XCTestCase {
    
    // MARK: - Subject under test
    var sut: PhotosWorker!
    static var testResponse: FlickerResponse!
    
    // MARK: - Test lifecycle
    override func setUp()
    {
        super.setUp()
        setupPhotosWorker()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: - Test setup
    func setupPhotosWorker()
    {
        sut = PhotosWorker(photosStore: FlickrImageAPISpy())
        PhotosWorkerTests.testResponse = Seeds.SeedPhotos.response
    }
    
    class FlickrImageAPISpy: FlickrImageAPI
    {
        // MARK: Method call expectations
        
        var fetchPhotosCalled = false
        
        // MARK: Spied methods
        override func fetchPhotos(text: String, completionHandler: @escaping (FlickerResponse?) -> Void)
        {
            fetchPhotosCalled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                completionHandler (PhotosWorkerTests.testResponse)
            }
        }
    }
    
    func testFetchPhotosShouldReturnListOfPhotos()
    {
        // Given
        let flickrImageAPISpy = sut.photosStore as! FlickrImageAPISpy
        
        // When
        var fetchedPhotos = [Photo]()
        let expect = expectation(description: "Wait for fetchPhotos() to return")
        sut.fetchPhotos { (photos) in
            fetchedPhotos = photos ?? []
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.1)
        
        // Then
        XCTAssert(flickrImageAPISpy.fetchPhotosCalled, "Calling fetchPhotos() should ask the data store for a list of photos")
        XCTAssertEqual(fetchedPhotos.count, PhotosWorkerTests.testResponse.photos.photo.count, "fetchPhotos() should return a list of photos")
    }
}
