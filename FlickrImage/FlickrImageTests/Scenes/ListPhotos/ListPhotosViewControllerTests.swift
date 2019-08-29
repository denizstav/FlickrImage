//
//  ListPhotosViewControllerTests.swift
//  FlickrImageTests
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//
@testable import FlickrImage
import XCTest

class ListPhotosViewControllerTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ListPhotosViewController!
    var window: UIWindow!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        setupListPhotosViewController()
    }
    
    override func tearDown()
    {
        window = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupListPhotosViewController()
    {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "ListPhotosViewController") as? ListPhotosViewController
    }
    
    func loadView()
    {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Test doubles
    
    class ListPhotosBusinessLogicSpy: ListPhotosBusinessLogic
    {
        // MARK: Method call expectations
        var fetchPhotosCalled = false
        
        // MARK: Spied methods
        func fetchPhotos(request: ListPhotosModels.FetchPhotos.Request) {
            fetchPhotosCalled = true
        }
    }
    
    // MARK: - Tests
    
    func testShouldFetchPhotosWhenSearchAnItem()
    {
        // Given
        let listPhotosBusinessLogicSpy = ListPhotosBusinessLogicSpy()
        sut.interactor = listPhotosBusinessLogicSpy
        loadView()
        
        // When
        sut.searchImage(text: "Dog")
        
        // Then
        XCTAssert(listPhotosBusinessLogicSpy.fetchPhotosCalled, "Should fetch photos when user search an item")
    }
    
    func testShouldFetchPhotosWhenSearchAnItemFromSearchBar()
    {
        // Given
        let listPhotosBusinessLogicSpy = ListPhotosBusinessLogicSpy()
        sut.interactor = listPhotosBusinessLogicSpy
        loadView()
        sut.searchBar.text = "Cat"
        
        // When
        sut.searchBarSearchButtonClicked(sut.searchBar)
        
        // Then
        XCTAssert(listPhotosBusinessLogicSpy.fetchPhotosCalled, "Should fetch photos when user search an item")
    }
    
    func testShouldNotWhenSearchBarTextIsEmpty()
    {
        // Given
        let listPhotosBusinessLogicSpy = ListPhotosBusinessLogicSpy()
        sut.interactor = listPhotosBusinessLogicSpy
        loadView()
        sut.searchBar.text = ""
        
        // When
        sut.searchBarSearchButtonClicked(sut.searchBar)
        
        // Then
        XCTAssertFalse(listPhotosBusinessLogicSpy.fetchPhotosCalled, "Should not fetch photos when search bar is empty")
    }
    
    func testShouldDisplayFetchedPhotos()
    {
        // Given
        loadView()
        
        // When
        let displayedPhotos = Seeds.SeedPhotos.photos
        sut.loadMore = false
        sut.displayFetchedPhotos(viewModel: displayedPhotos)
        
        // Then
        XCTAssertEqual(sut.displayedPhotos.count, displayedPhotos.displayedPhotos.count, "Displaying fetched Photos should be same number with response when load more is false")
    }
    
    func testShouldDisplayFetchedPhotosShouldAppend()
    {
        // Given
        loadView()
        
        // When
        let displayedPhotos = Seeds.SeedPhotos.photos
        sut.loadMore = false
        sut.displayFetchedPhotos(viewModel: displayedPhotos)
        sut.loadMore = true
        sut.displayFetchedPhotos(viewModel: displayedPhotos)
        
        // Then
        XCTAssertGreaterThan(sut.displayedPhotos.count, displayedPhotos.displayedPhotos.count, "Displaying fetched Photos should be same number with response when load more is false")
    }
    
    
    func testNumberOfRowsInAnySectionShouldEqaulNumberOfPhotosToDisplay()
    {
        loadView()
        
        // Given
        let collectionView = sut.collectionView
        let displayedPhotos = Seeds.SeedPhotos.photos.displayedPhotos
        sut.displayedPhotos = displayedPhotos
        
        // When
        let numberOfRows = sut.collectionView(collectionView!, numberOfItemsInSection: 0)
        // Then
        XCTAssertEqual(numberOfRows, displayedPhotos.count, "The number of collection view rows should equal the number of Photos to display")
    }
    
    
    func testShowLoadingShouldLoadingVisible()
    {
        // Given
        loadView()
        
        // When
        sut.displayLoading()
        
        // Then
        XCTAssertNotNil(sut.presentedViewController, "DisplayLoading should make loading visible")
    }
    
    func testHideLoadingShouldLoadingIsNotVisible()
    {
        // Given
        loadView()
        
        // When
        sut.hideLoading()
        
        // Then
        XCTAssertNil(sut.presentedViewController, "DisplayLoading should make loading invisible")
    }
    
    func testShouldConfigureTableViewCellToDisplayOrder()
    {
        loadView()
        // Given
        let collectionView = sut.collectionView
        let displayedPhotos = Seeds.SeedPhotos.photos.displayedPhotos
        sut.displayedPhotos = displayedPhotos
        
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.collectionView(collectionView!, cellForItemAt: indexPath) as? PhotoCollectionCell
        
        // Then
        XCTAssertEqual(cell?.nameLabel?.text, "CollectionCell", "A properly configured collection view cell should display the searchString")
    }
    
    func testShouldCallLoadMoreWhenCellDisplayed()
    {
        loadView()
        // Given
        let listPhotosBusinessLogicSpy = ListPhotosBusinessLogicSpy()
        sut.interactor = listPhotosBusinessLogicSpy
        loadView()
        let collectionView = sut.collectionView
        let displayedPhotos = Seeds.SeedPhotos.photos.displayedPhotos
        sut.displayedPhotos = displayedPhotos
        
        // When
        let indexPath = IndexPath(row: displayedPhotos.count - 2, section: 0)
        let cell = sut.collectionView(collectionView!, cellForItemAt: indexPath) as? PhotoCollectionCell
        sut.collectionView(collectionView!, willDisplay: cell!, forItemAt: indexPath)
        
        // Then
        XCTAssertTrue(sut.loadMore,"When user display last 2nd cell, it should call load more")
        XCTAssertTrue(listPhotosBusinessLogicSpy.fetchPhotosCalled, "Should fetch photos when user scrollDown")
    }
}
