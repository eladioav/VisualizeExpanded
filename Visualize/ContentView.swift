//
//  ContentView.swift
//  Visualize
//
//  Created by Eladio Alvarez Valle on 10/08/21.
//
// Note: Every method is called in the order is defined inside the body, e.g.: onAppear of ScrollView is gonna be called before Geometry Reader's onAppear

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel : ViewModel = ViewModel()
    
    var body: some View {
        GeometryReader { grGlobal in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: viewModel.width/2) {
                    ForEach(viewModel.objects, id:\.name) { imageObject in
                        Image(systemName: imageObject.name)
                            .resizable()
                            .scaledToFit()
                            .frame(height:viewModel.height)
                            .foregroundColor(.gray)
                            .scaleEffect(viewModel.getScale(imageName: imageObject.name))
                            .background(GeometryReader { grImage -> (Color) in
                                let rectImage = grImage.frame(in: .global)
                                let rectScreen = grGlobal.frame(in: .global)

                                viewModel.set(screenFrame: rectScreen)
                                viewModel.setPosition(with: rectImage, imageName: imageObject.name)
                                
                                return Color.clear
                            })
                    } //ForEach
                } //HStack
                .frame(height: viewModel.height + (viewModel.height * viewModel.maxScaleGrow))
                .padding(EdgeInsets(top: 0, leading: viewModel.width, bottom: 0, trailing: viewModel.width))
            } //ScrollView
        }//GR
    }//body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
