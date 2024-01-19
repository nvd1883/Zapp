//
//  ImageViewModel.swift
//  Zapp
//
//  Created by Nived Pradeep on 15/01/24.
//

import Foundation
import UIKit

class ImageViewModel {
    private var images = [ImageModel]()
    private var currentPage = 1
    private var apiManager = UnsplashAPIManager()
    weak var delegate:ImageViewModelDelegate?
    
    //caching for image loading
    private var imageCache = NSCache<NSString, UIImage>()
    
    func numberOfImages() -> Int {
        return images.count
    }
    
    func loadMoreImages(completion: @escaping (Result<Void, Error>) -> Void) {
        currentPage += 1
        fetchImages(page: currentPage) { [weak self] fetchedImages, error in
            if let fetchedImages = fetchedImages {
                DispatchQueue.main.async {
                    self?.images.append(contentsOf: fetchedImages)
                    self?.delegate?.imagesDidUpdate()
                    completion(.success(()))
                }
                
            } else if let error = error {
                print("Error fetching images \(error)")
                self?.delegate?.didFailFetchingImages(error: error)
                completion(.failure(error))
            } else {
                print("Unknown error during image fetching")
                completion(.failure(NSError(domain: "YourDomain", code: 999, userInfo: nil)))
            }
        }
    }
    
    func image(at index: Int) -> ImageModel {
        return images[index]
    }
    
    func fetchImages(page: Int, completion: @escaping ([ImageModel]?, Error?) -> Void) {
        print("Start fetching images for page \(page)")
        apiManager.fetchImages(page: page) { fetchedImages, error in
            if let fetchedImages = fetchedImages {
                print("Images fetched successfully for page \(page)")
                DispatchQueue.main.async {
                    self.images.append(contentsOf: fetchedImages)
                }
            }
            else if let error = error {
                fatalError("error occured \(error)")
            }
            completion(fetchedImages, error)
        }
    }
    
    //Function to load images with caching
    func loadImage(with url:URL, completion:@escaping (UIImage?) -> Void) {
        //Check if image is already in cache
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        
        //If not in cache download the image
        URLSession.shared.dataTask(with: url) {[weak self] data, _,error in
            guard let data = data, let image = UIImage(data: data), error == nil else{
                completion(nil)
                return
            }
            
            //Cache the image
            self?.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            completion(image)
        }.resume()
        
    }
}
