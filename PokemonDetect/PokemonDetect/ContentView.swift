//
//  ContentView.swift
//  PokemonDetect
//
//  Created by Antonella Giugliano on 28/02/24.
//

import SwiftUI
import Vision
import CoreML

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State var prediction = ""
    var body: some View {
        VStack {
            Image("charmander")
            Text(prediction)
        }
        .padding()
        .onAppear(perform: {
            viewModel.classifyPokemon()
            prediction = "\(viewModel.prediction!.classification) \(viewModel.prediction!.confidencePercentage)"
        })
        
    }
}


#Preview {
    ContentView()
}
