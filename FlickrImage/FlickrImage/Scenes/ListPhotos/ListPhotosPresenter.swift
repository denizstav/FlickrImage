//
//  ListPhotosPresenter.swift
//  FlickrImage
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

import Foundation

protocol ListPhotosPresentationLogic {
    func presentFetchedPhotos(response: ListPhotosModels.FetchPhotos.Response)
    func presentLoading()
    func hideLoading()
    func presentErrorView()
    func hideErrorView()
}

public class ListPhotosPresenter: ListPhotosPresentationLogic {
    fileprivate let errorText: String = "Sorry, No Result\nTry rewording your search or entering a new keyword."
    weak var viewController: ListPhotosDisplayLogic?
    
    // MARK: - Fetch photos
    
    func presentFetchedPhotos(response: ListPhotosModels.FetchPhotos.Response) {
        var displayePhotos: [ListPhotosModels.FetchPhotos.ViewModel.DisplayedPhoto] = []
        for photo in response.photos {
            let displayedPhoto = ListPhotosModels.FetchPhotos.ViewModel.DisplayedPhoto(
                image: photo.imageUrl(),
                name: photo.title)
            displayePhotos.append(displayedPhoto)
        }
        let viewModel = ListPhotosModels.FetchPhotos.ViewModel(displayedPhotos: displayePhotos)
        viewController?.displayFetchedPhotos(viewModel: viewModel)
    }
    // MARK: - Present Loading
    func presentLoading() {
        viewController?.displayLoading()
    }
    // MARK: - Hide Loading
    func hideLoading() {
        viewController?.hideLoading()
    }
    
    func presentErrorView() {
        viewController?.displayErrorView(text: errorText)
    }
    
    func hideErrorView() {
        viewController?.hideErrorView()
    }
}
