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
                                      owner: "Deniz Tav",
                                      secret: "secret",
                                      server: "server",
                                      farm: 0,
                                      title: "Image",
                                      ispublic: 1,
                                      isfriend: 1,
                                      isfamily: 1)
        static let secondPhoto = Photo(id: "13",
                                       owner: "Deniz Tav",
                                       secret: "secret",
                                       server: "server",
                                       farm: 0,
                                       title: "Image name 2",
                                       ispublic: 1,
                                       isfriend: 1,
                                       isfamily: 1)
        
        static let response = FlickerResponse(photos: Photos(page: 0, pages: 0, perpage: 1, total: "total", photo: [firstPhoto, secondPhoto] ) , stat: "ok")
    }
}
