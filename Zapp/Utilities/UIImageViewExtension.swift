//
//  UIImageViewExtension.swift
//  Zapp
//
//  Created by Nived Pradeep on 16/01/24.
//

import Foundation
import UIKit

extension UIImageView {
  
    func loadFrom(url:URL, in viewModel:ImageViewModel) {
        viewModel.loadImage(with: url){[weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
