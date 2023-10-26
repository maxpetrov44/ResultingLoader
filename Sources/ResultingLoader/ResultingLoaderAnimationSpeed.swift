//
//  ResultingLoaderAnimationSpeed.swift
//  
//
//  Created by Maksim Petrov on 25.10.2023.
//

import Foundation

public struct ResultingLoaderAnimationSpeed: Equatable {
    let duration: Double
    
    public init(_ rawDuration: Double) {
        self.duration = rawDuration
    }
    
    public static func normal() -> ResultingLoaderAnimationSpeed {
        return ResultingLoaderAnimationSpeed(1)
    }
    public static func fast() -> ResultingLoaderAnimationSpeed {
        return ResultingLoaderAnimationSpeed(0.5)
    }
}
