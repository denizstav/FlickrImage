//
//  ListPhotosPresenterTests.swift
//  FlickrImageTests
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//
@testable import FlickrImage
import XCTest

class ListPhotosPresenterTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ListPhotosPresenter!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupListPhotosPresenter()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupListPhotosPresenter()
    {
        sut = ListPhotosPresenter()
    }
    
    // MARK: - Test doubles
    
    class ListPhotosDisplayLogicSpy: ListPhotosDisplayLogic
    {
        // MARK: Method call expectations
        
        var displayFetchedPhotosCalled = false
        var displayLoadingCalled = false
        var hideLoadingCalled = false
        var displayErrorCalled = false
        var hideErrorCalled = false
        
        // MARK: Argument expectations
        
        var viewModel: ListPhotosModels.FetchPhotos.ViewModel!
        
        // MARK: Spied methods
        
        func displayFetchedPhotos(viewModel: ListPhotosModels.FetchPhotos.ViewModel)
        {
            displayFetchedPhotosCalled = true
            self.viewModel = viewModel
        }
        
        func displayLoading() {
            displayLoadingCalled = true
        }
        
        func hideLoading() {
            hideLoadingCalled = true
        }
        
        func displayErrorView(text: String) {
            displayErrorCalled = true
        }
        
        func hideErrorView() {
            hideErrorCalled = true
        }
    }
    
    // MARK: - Tests
    
    func testPresentFetchedPhotosShouldAskViewControllerToDisplayFetchedPhotos()
    {
        // Given
        let listPhotosDisplayLogicSpy = ListPhotosDisplayLogicSpy()
        sut.viewController = listPhotosDisplayLogicSpy
        
        // When
        let photos = [Seeds.SeedPhotos.firstPhoto]
        let response = ListPhotosModels.FetchPhotos.Response(photos: photos)
        sut.presentFetchedPhotos(response: response)
        sut.presentLoading()
        sut.hideLoading()
        sut.hideErrorView()
        sut.presentErrorView()
        
        // Then
        XCTAssert(listPhotosDisplayLogicSpy.displayFetchedPhotosCalled, "Presenting fetched photos should ask view controller to display them")
        XCTAssert(listPhotosDisplayLogicSpy.displayLoadingCalled, "Presenting loading should ask view controller to display loading")
        XCTAssert(listPhotosDisplayLogicSpy.hideLoadingCalled, "Hiding loading should ask view controller to hide loading")
        XCTAssert(listPhotosDisplayLogicSpy.hideErrorCalled, "Hiding error should ask view controller to hide error")
        XCTAssert(listPhotosDisplayLogicSpy.displayErrorCalled, "Presenting error should ask view controller to display error")
    }
}
