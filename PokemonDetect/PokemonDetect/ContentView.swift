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
    @State private var selectedImageData: Data? = nil

    @State var pokemon = ""
    var body: some View {
        VStack {
            if let selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                    }
            if let prediction = viewModel.prediction {
                Text(pokemon)
            }
            Spacer()
            PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            VStack{
                                Image("pokeball").resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                Text("Select a pokemon")
                            }
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                viewModel.prediction = nil
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData), viewModel.prediction == nil {
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
