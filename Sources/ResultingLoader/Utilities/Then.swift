//
//  Then.swift
//  
//
//  Created by Maksim Petrov on 25.10.2023.
//

import UIKit
import CoreGraphics

protocol Then {}

extension Then where Self: AnyObject {
    @discardableResult
    func then( _ block: (Self) -> Void ) -> Self {
        block(self)
        return self
    }
}

extension Then where Self: UIView {
    @discardableResult
    func then( useAutolayout: Bool = true, _ block: (Self) -> Void ) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = !useAutolayout
        block(self)
        return self
    }
}

extension NSObject: Then {}

