//
//  UnsplashAPIManager.swift
//  Zapp
//
//  Created by Nived Pradeep on 15/01/24.
//

import Foundation

class UnsplashAPIManager {
    
    private let accessKey = "ofY7_zIyZlv5xv3bJy4lXI48ZEGvWEF4kwN0naIijuU"
    private let baseURL = "https://api.unsplash.com/photos/"
    
    func fetchImages(page:Int, completion: @escaping ([ImageModel]?,Error?) ->Void) {
        let endPoint = baseURL + "?page=\(page)&client_id=\(accessKey)"
        
        guard let url = URL(string: endPoint) else{
            completion(nil,NetworkingError.invalidURL)
            return
        }
        print(endPoint)
        
        let task = URLSession.shared.dataTask(with: url) {data,response, error in
            if let error = error {
                completion(nil,error)
                return
            }
            
            guard let data = data else{
                completion(nil,NetworkingError.noData)
                return
            }
            
            do {
                let images = try JSONDecoder().decode([ImageModel].self, from: data)
                completion(images,nil)
            }
            catch let decodingError {
               print("Decoding error \(decodingError)")
               completion(nil,decodingError)
            }
        }
        task.resume()
    }
}
