//
//  ResultingLoaderResult.swift
//  
//
//  Created by Maksim Petrov on 25.10.2023.
//

import Foundation
import UIKit

public struct ResultingLoaderResult: Equatable {
    let resultColor: UIColor
    let imageTintColor: UIColor?
    let resultImage: UIImage?
    
    public init(
        resultColor: UIColor,
        resultImage: UIImage?,
        imageTintColor: UIColor? = nil
    ) {
        self.resultColor = resultColor
        self.resultImage = resultImage
        self.imageTintColor = imageTintColor
    }
    
    public static func success(associatedImage: UIImage?) -> ResultingLoaderResult {
        return ResultingLoaderResult(
            resultColor: .loaderSuccess,
            resultImage: associatedImage,
            imageTintColor: .tintLoaderSuccess
        )
    }
    public static func failure(associatedImage: UIImage?) -> ResultingLoaderResult {
        return ResultingLoaderResult(
            resultColor: .loaderFailure,
            resultImage: associatedImage,
            imageTintColor: .tintLoaderFailure
        )
    }
}

