//
//  Extension.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 3/11/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
