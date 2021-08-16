//
//  ViewModel.swift
//  Visualize
//
//  Created by Eladio Alvarez Valle on 13/08/21.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var scale: CGFloat = 1.0
    @Published var objects: [ImageObject]
    
    let height: CGFloat = 160
    let width: CGFloat = 160
    private let minScale : CGFloat = 1.0
    let maxScaleGrow : CGFloat = 0.5
    
    private var currentImage: String = ""
    private var middleScreen: CGFloat = 0.0
    private var leadingStartArea: CGFloat = 0.0
    private var trailingStartArea: CGFloat = 0.0

    var currentPos: CGFloat = 0.0 {
        didSet {
            guard currentImage != "" else { return }
            guard let currentImageObject = objects.filter({ $0.name == currentImage }).first else { return }
            //TODO: Remove set currentImageObject.scale, or verify if when is set updates UI (should, is a Publisher)
            currentImageObject.scale = getScale(imageName: currentImageObject.name)
            scale = currentImageObject.scale
        }
    }
    
    init() {
        objects = [ImageObject(name: "trash"), ImageObject(name: "pencil.tip"), ImageObject(name: "folder.circle"), ImageObject(name: "paperplane"), ImageObject(name: "externaldrive"), ImageObject(name: "doc.circle"), ImageObject(name: "doc.append"), ImageObject(name: "book"), ImageObject(name: "bookmark"), ImageObject(name: "power")]
    }

    func getScale(imageName: String) -> CGFloat {
        //TODO: Instead of use imageName, use ImageObject or id (create if necessary)
        guard imageName == currentImage else { return 1.0 }
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
    
    func setPosition(with imageFrame: CGRect, imageName: String) {
        //TODO: Instead of use imageName, use ImageObject or id (create if necessary)
        let middleImage = imageFrame.origin.x + (imageFrame.width/2.0)
        if  isOnBoundaries(middleImage: middleImage)  {
            currentImage = imageName
            currentPos = middleImage //Update imageObject could trigger UI update (imageObject.middle = middleImage)
        }
    }
    
    func set(screenFrame: CGRect) {
        let middleScreen = screenFrame.midX
        let leadingStartArea = middleScreen - (height/2.0)
        let trailingStartArea = middleScreen + (height/2.0)
        self.middleScreen = middleScreen
        self.leadingStartArea = leadingStartArea
        self.trailingStartArea = trailingStartArea
    }
}
