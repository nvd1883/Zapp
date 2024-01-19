//
//  ImageViewModelDelegate.swift
//  Zapp
//
//  Created by Nived Pradeep on 18/01/24.
//

import Foundation

protocol ImageViewModelDelegate: AnyObject {
    func imagesDidUpdate()
    func didFailFetchingImages(error:Error)
}
