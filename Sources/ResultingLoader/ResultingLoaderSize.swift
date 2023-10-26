//
//  ResultingLoaderSize.swift
//  
//
//  Created by Maksim Petrov on 25.10.2023.
//

import Foundation

public struct ResultingLoaderSize: Equatable {
    let loaderDimensionValue: CGFloat

    public init(_ rawSize: CGFloat) {
        self.loaderDimensionValue = rawSize
    }
    
    public static func large() -> ResultingLoaderSize {
        return ResultingLoaderSize(UIConstants.largeLoaderDimensionSize)
    }
    public static func medium() -> ResultingLoaderSize {
        return ResultingLoaderSize(UIConstants.mediumLoaderDimensionSize)
    }
}
