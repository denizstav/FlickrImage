//
//  Seeds.swift
//  FlickrImageTests
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

@testable import FlickrImage
import XCTest

struct Seeds {
    struct SeedPhotos {
        static let firstPhoto = Photo(id: "12",
                                      secret: "secret",
                                      server: "server",
                                      farm: 0,
                                      title: "Image")
        static let secondPhoto = Photo(id: "13",
                                       secret: "secret",
                                       server: "server",
                                       farm: 0,
                                       title: "Image name 2")
        
        static let response = PhotosResponse(photos: Photos(page: 0, pages: 0, perpage: 1, total: "total", photo: [firstPhoto, secondPhoto] ) , stat: "ok")
        
        static let firstDisplay = ListPhotosModels.FetchPhotos.ViewModel.DisplayedPhoto(image: "imageString", name: "CollectionCell")
        static let secondDisplay = ListPhotosModels.FetchPhotos.ViewModel.DisplayedPhoto(image: "imageString", name: "CollectionCell")
        static let thirdDisplay = ListPhotosModels.FetchPhotos.ViewModel.DisplayedPhoto(image: "imageString", name: "CollectionCell")
        static let fourthDisplay = ListPhotosModels.FetchPhotos.ViewModel.DisplayedPhoto(image: "imageString", name: "CollectionCell")
        static let fifthDisplay = ListPhotosModels.FetchPhotos.ViewModel.DisplayedPhoto(image: "imageString", name: "CollectionCell")
        
        static let displayed = [firstDisplay, secondDisplay, thirdDisplay, fourthDisplay, fifthDisplay]
        static let photos = ListPhotosModels.FetchPhotos.ViewModel(displayedPhotos: displayed)
    }
}
