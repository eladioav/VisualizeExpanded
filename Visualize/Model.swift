//
//  Model.swift
//  Visualize
//
//  Created by Eladio Alvarez Valle on 13/08/21.
//

import SwiftUI

class ImageObject {
    var name: String
    var scale: CGFloat
    
    init(name: String, scale: CGFloat = 1.0) {
        self.name = name
        self.scale = scale
    }
}

extension ImageObject: Equatable {
    static func == (lhs: ImageObject, rhs: ImageObject) -> Bool {
        return lhs.name == rhs.name
    }
}
