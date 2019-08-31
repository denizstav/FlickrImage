//
//  ListPhotosInteractor.swift
//  FlickrImage
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

import Foundation

protocol ListPhotosBusinessLogic {
    func fetchPhotos(request: ListPhotosModels.FetchPhotos.Request)
}

protocol ListPhotosDataStore {
    var photos: [Photo] { get }
}

public class ListPhotosInteractor: ListPhotosBusinessLogic {
    var presenter: ListPhotosPresentationLogic?
    var photosWorker = PhotosWorker(photosStore: FlickrImageAPI())
    var photos: [Photo] = []
    
    // MARK: - Fetch photos
    func fetchPhotos(request: ListPhotosModels.FetchPhotos.Request) {
        presenter?.presentLoading()
        photosWorker.text = request.text
        photos.removeAll()
        photosWorker.fetchPhotos { [weak self] photos -> Void in
            for photo in photos! {
                self?.photos.append(photo)
            }
            let response = ListPhotosModels.FetchPhotos.Response(photos: self?.photos ?? [])
            if photos?.count ?? 0 > 0 {
                self?.presenter?.hideErrorView()
            } else {
                self?.presenter?.presentErrorView()
            }
            self?.presenter?.presentFetchedPhotos(response: response)
            self?.presenter?.hideLoading()
        }
    }
}
