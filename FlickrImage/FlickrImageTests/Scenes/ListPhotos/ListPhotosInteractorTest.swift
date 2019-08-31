//
//  ListPhotosInteractorTest.swift
//  FlickrImageTests
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//
@testable import FlickrImage
import XCTest

class ListPhotosInteractorTest: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ListPhotosInteractor!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupListPhotosInteractor()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupListPhotosInteractor()
    {
        sut = ListPhotosInteractor()
    }
    
    // MARK: - Test doubles
    
    class ListPhotosPresentationLogicSpy: ListPhotosPresentationLogic
    {
        // MARK: Method call expectations
        
        var presentFetchedPhotosCalled = false
        var presentLoadingCalled = false
        var hideLoadingCalled = false
        var presentErrorCalled = false
        var hideErrorCalled = false
        
        // MARK: Spied methods
        func presentFetchedPhotos(response: ListPhotosModels.FetchPhotos.Response) {
            presentFetchedPhotosCalled = true
        }
        
        func presentLoading() {
            presentLoadingCalled = true
        }
        
        func hideLoading() {
            hideLoadingCalled = true
        }
        
        func presentErrorView() {
            presentErrorCalled = true
        }
        
        func hideErrorView() {
            hideErrorCalled = true
        }
    }
    
    class PhotosWorkerSpy: PhotosWorker
    {
        // MARK: Method call expectations
        
        var fetchPhotosCalled = false
        
        // MARK: Spied methods
        
        override func fetchPhotos(completionHandler: @escaping ([Photo]?) -> Void)
        {
            fetchPhotosCalled = true
            completionHandler([Seeds.SeedPhotos.firstPhoto, Seeds.SeedPhotos.secondPhoto])
        }
    }
    
    class PhotosWorkerEmptyResultSpy: PhotosWorker
    {
        // MARK: Spied methods
        
        override func fetchPhotos(completionHandler: @escaping ([Photo]?) -> Void)
        {
            completionHandler([])
        }
    }
    
    // MARK: - Tests
    
    func testFetchPhotosShouldAskPhotosWorkerToFetchPhotosAndPresenterToShowResult()
    {
        // Given
        let listPhotosPresentationLogicSpy = ListPhotosPresentationLogicSpy()
        sut.presenter = listPhotosPresentationLogicSpy
        let photosWorkerSpy = PhotosWorkerSpy(photosStore: FlickrImageAPI())
        sut.photosWorker = photosWorkerSpy
        
        // When
        let request = ListPhotosModels.FetchPhotos.Request(text: "Cat")
        sut.fetchPhotos(request: request)
        
        // Then
        XCTAssert(photosWorkerSpy.fetchPhotosCalled, "FetchPhotos() should ask PhotosWorker to fetch Photos")
        XCTAssert(listPhotosPresentationLogicSpy.presentFetchedPhotosCalled, "FetchPhotos() should ask presenter to format Photos result")
        XCTAssert(listPhotosPresentationLogicSpy.presentLoadingCalled, "FetchPhotos() should ask presenter to show loading")
        XCTAssert(listPhotosPresentationLogicSpy.hideLoadingCalled, "FetchPhotos() should ask presenter to hide loading")
        XCTAssert(listPhotosPresentationLogicSpy.hideErrorCalled, "FetchPhotos() should ask presenter to hide error view")
    }
    
    func testFetchPhotosShouldAskPresenterToShowErrorView()
    {
        // Given
        let listPhotosPresentationLogicSpy = ListPhotosPresentationLogicSpy()
        sut.presenter = listPhotosPresentationLogicSpy
        let photosWorkerSpy = PhotosWorkerEmptyResultSpy(photosStore: FlickrImageAPI())
        sut.photosWorker = photosWorkerSpy
        
        // When
        let request = ListPhotosModels.FetchPhotos.Request(text: "Cat")
        sut.fetchPhotos(request: request)
        
        // Then
        XCTAssert(listPhotosPresentationLogicSpy.presentErrorCalled, "FetchPhotos() should ask presenter to show error")
    }
}
