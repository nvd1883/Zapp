//
//  ViewController.swift
//  Zapp
//
//  Created by Nived Pradeep on 15/01/24.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageViewCollectionView: UICollectionView!
    let viewModel = ImageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        fetchImages()
    }
    
    func registerCell() {
        let uiNib = UINib(nibName: "ImageCell", bundle: nil)
        imageViewCollectionView.register(uiNib, forCellWithReuseIdentifier: "ImageCell")
    }
    
    func fetchImages() {
        viewModel.fetchImages(page: 1) {[weak self] fetchedImages, error in
            DispatchQueue.main.async {
                if let fetchedImages = fetchedImages {
                   print("Images Fetched")
                }
                else if error != nil {
                    print("Error")
                }
                self?.reloadCollectionView()
            }
        }
    }
    
    func addConstraints(cell:ImageCell) {
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.clipsToBounds = true
        cell.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            cell.imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            cell.imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            cell.imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
        ])
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.imageViewCollectionView.reloadData()
        }
    }
    
    
}

extension ImageViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            fatalError("Unable to deque the cell")
        }
        addConstraints(cell: cell)
        cell.imageView.image = UIImage(systemName: "photo.fill")
        let imageModel = viewModel.image(at: indexPath.item)
        if let url = URL(string: imageModel.urls.regular) {
            cell.imageView.loadFrom(url: url, in: viewModel)
        }
        return cell
    }
}

extension ImageViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = viewModel.numberOfImages() - 1
        if indexPath.item == lastItem {
            viewModel.loadMoreImages{[weak self] result in
                switch result {
                case .success():
                    self?.reloadCollectionView()
                case .failure(let error):
                    print("Error loading more images \(error)")
                }
            }
        }
    }
}

extension ImageViewController:ImageViewModelDelegate {
    func imagesDidUpdate() {
        self.reloadCollectionView()
    }
    
    func didFailFetchingImages(error: Error) {
        print("Error")
    }
}

