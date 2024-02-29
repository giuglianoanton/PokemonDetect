//
//  ContentView.swift
//  PokemonDetect
//
//  Created by Antonella Giugliano on 28/02/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showCamera = false
    
    @State var pokemon = ""
    
    var body: some View {
        VStack {
            if let uiImage = selectedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
            if let prediction = viewModel.prediction {
                Text(pokemon)
            }
            Spacer()
            VStack{
                Image("pokeball").resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        
                        Text("Select a pokemon")
                    }
                Button(action: {
                    self.showCamera.toggle()
                }, label: {
                    Text("Camera")
                })
                .fullScreenCover(isPresented: self.$showCamera) {
                    CameraView(selectedImage: self.$selectedImage)
                }
                
            }
            
            .onChange(of: selectedItem) { newItem in
                Task {
                    viewModel.prediction = nil
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImage = UIImage(data: data)
                    }
                }
            }
        
            
            if let uiImage = selectedImage, viewModel.prediction == nil {
                Button(action: {
                    viewModel.classifyPokemon(image: uiImage)
                    pokemon = "\(viewModel.prediction!.classification) \(viewModel.prediction!.confidencePercentage)"
                }, label: {
                    Text("Detect this Pokemon")
                })
                
            }
        }
        .padding()
        
    }
}


#Preview {
    ContentView()
}
