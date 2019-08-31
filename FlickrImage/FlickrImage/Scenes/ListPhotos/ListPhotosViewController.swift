//
//  ListPhotosViewController.swift
//  FlickrImage
//
//  Created by Deniz Tav on 29/08/2019.
//  Copyright © 2019 Deniz Tav. All rights reserved.
//

import UIKit

protocol ListPhotosDisplayLogic: class {
    func displayFetchedPhotos(viewModel: ListPhotosModels.FetchPhotos.ViewModel)
    func displayLoading()
    func hideLoading()
    func displayErrorView(text: String)
    func hideErrorView()
}

class ListPhotosViewController: UIViewController, ListPhotosDisplayLogic, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    // MARK: - Constants
    fileprivate let insetTop: CGFloat = 5
    fileprivate let inset: CGFloat = 10
    fileprivate let indicatorWidth: CGFloat = 50
    fileprivate let indicatorHeight: CGFloat = 50
    fileprivate let startLoadingAtLast: Int = 2
    fileprivate let cellIdentifier: String = "PhotoCollectionCell"
    fileprivate let titleText: String = "Flickr Images"

    // MARK: - Variables
    var searchText = ""
    var loadMore = false
    var interactor: ListPhotosBusinessLogic?
    var displayedPhotos: [ListPhotosModels.FetchPhotos.ViewModel.DisplayedPhoto] = [] {
        didSet {
            self.collectionView.reloadData()
            if !loadMore {
                collectionView?.setContentOffset(CGPoint.zero, animated: true)
            }
        }
    }
    let loading = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    // MARK: - IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var errorView: UIView!
    @IBOutlet var errorLabel: UILabel!
    
    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    // MARK: - Setup
    private func setup() {
        let viewController = self
        let interactor = ListPhotosInteractor()
        let presenter = ListPhotosPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: inset, y: insetTop, width: indicatorWidth, height: indicatorHeight))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        loading.view.addSubview(loadingIndicator)
        
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Business Logic
    func searchImage(text: String) {
        let request = ListPhotosModels.FetchPhotos.Request(text: text)
        interactor?.fetchPhotos(request: request)
    }
    
    // MARK: - Display Logic
    func displayFetchedPhotos(viewModel: ListPhotosModels.FetchPhotos.ViewModel) {
        if loadMore {
            displayedPhotos.append(contentsOf: viewModel.displayedPhotos)
        } else {
            displayedPhotos = viewModel.displayedPhotos
        }
    }
    
    func displayLoading() {
        present(loading, animated: true, completion: nil)
    }
    
    func hideLoading() {
        dismiss(animated: false, completion: nil)
    }
    
    func displayErrorView(text: String) {
        errorLabel.text = text
        errorView.isHidden = false
    }
    
    func hideErrorView() {
        errorView.isHidden = true
    }
}
// MARK: - CollectionView
extension ListPhotosViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        if let photoCell = cell as? PhotoCollectionCell {
            photoCell.photo = displayedPhotos[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.displayedPhotos.count - startLoadingAtLast {
            loadMore = true
            searchImage(text: searchText)
        }
    }
}

// MARK: - SearchBar Delegate
extension ListPhotosViewController {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        searchText = text
        loadMore = false
        searchImage(text: text)
    }
}
