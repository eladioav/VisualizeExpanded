//
//  ViewModel.swift
//  Visualize
//
//  Created by Eladio Alvarez Valle on 13/08/21.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    private(set) var objects: [ImageObject]
    @Published var currentPos: CGFloat = 0.0
    
    let height: CGFloat = 160
    let width: CGFloat = 160
    private let minScale : CGFloat = 1.0
    let maxScaleGrow : CGFloat = 0.5
    
    private var currentImageObject: ImageObject?
    private var middleScreen: CGFloat = 0.0
    private var leadingStartArea: CGFloat = 0.0
    private var trailingStartArea: CGFloat = 0.0
    
    init() {
        objects = [ImageObject(name: "trash"), ImageObject(name: "pencil.tip"), ImageObject(name: "folder.circle"), ImageObject(name: "paperplane"), ImageObject(name: "externaldrive"), ImageObject(name: "doc.circle"), ImageObject(name: "doc.append"), ImageObject(name: "book"), ImageObject(name: "bookmark"), ImageObject(name: "power")]
    }

    func getScale(imageObject: ImageObject) -> CGFloat {
        guard imageObject == currentImageObject else { return 1.0 }
        let maxDistance = abs(middleScreen - leadingStartArea)
        let currentDistance = maxDistance - abs(middleScreen - currentPos)
        
        guard currentDistance <= maxDistance else { return 1.0 }
        let percentage = currentDistance / maxDistance
        return minScale + (percentage * maxScaleGrow)
    }
    
    func isOnBoundaries(middleImage: CGFloat) -> Bool {
        guard  middleImage > leadingStartArea && middleImage < trailingStartArea && currentPos != middleImage  else {
            return false
        }
        
        return true
    }
    
    func setPosition(for imageFrame: CGRect, imageObject: ImageObject) {
        let middleImage = imageFrame.origin.x + (imageFrame.width/2.0)
        if  isOnBoundaries(middleImage: middleImage)  {
            currentImageObject = imageObject
            currentPos = middleImage
        }
    }
    
    func set(screenFrame: CGRect) {
        self.middleScreen = screenFrame.midX
        self.leadingStartArea = middleScreen - (height/2.0)
        self.trailingStartArea = middleScreen + (height/2.0)
    }
}
