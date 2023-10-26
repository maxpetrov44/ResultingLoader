//
//  File.swift
//  
//
//  Created by Maksim Petrov on 25.10.2023.
//

import UIKit

enum UIConstants {
    static let largeLoaderDimensionSize: CGFloat = 56
    static let mediumLoaderDimensionSize: CGFloat = 40
}

extension UIColor {
    static let loaderStroke: UIColor = UIColor(
        red: 0.839,
        green: 0.839,
        blue: 0.839,
        alpha: 1
    )
    static let loaderSuccess: UIColor = UIColor(
        red: 0.933,
        green: 0.988,
        blue: 0.851,
        alpha: 1
    )
    static let tintLoaderSuccess: UIColor = UIColor(
        red: 0.502,
        green: 0.729,
        blue: 0.153,
        alpha: 1
    )
    static let loaderFailure: UIColor = UIColor(
        red: 0.988,
        green: 0.878,
        blue: 0.835,
        alpha: 1
    )
    static let tintLoaderFailure: UIColor = UIColor(
        red: 1.000,
        green: 0.157,
        blue: 0.122,
        alpha: 1
    )
}

