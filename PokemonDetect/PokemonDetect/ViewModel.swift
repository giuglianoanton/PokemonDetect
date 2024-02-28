//
//  ViewModel.swift
//  PokemonDetect
//
//  Created by Antonella Giugliano on 28/02/24.
//

import Vision
import CoreML
import SwiftUI


class ViewModel: ObservableObject {
    @Published var prediction: Prediction?
    
    func classifyPokemon(image: UIImage){
        var handler: VNImageRequestHandler?
        do{
            let pokemonClassifier = try PokemonClassifier(configuration: MLModelConfiguration())
            let model = try VNCoreMLModel(for: pokemonClassifier.model)
            let request = VNCoreMLRequest(model: model)
#if targetEnvironment(simulator)
            request.usesCPUOnly = true;
#endif
            handler = VNImageRequestHandler(cgImage: (image.cgImage!))
            try handler!.perform([request])
            handleResults(request: request)
        } catch{
            print(error)
        }
    }
    
    func handleResults(request: VNRequest) {
        var highestPrediction: VNConfidence = 0
        guard let results = request.results as? [VNClassificationObservation] else {return}
        for classification in results {
            if classification.confidence > highestPrediction {
                print(classification.identifier, classification.confidencePercentageString)
                highestPrediction = classification.confidence
                prediction = Prediction(classification: classification.identifier, confidencePercentage: classification.confidencePercentageString)
            }
//            print(classification.identifier, classification.confidencePercentageString, classification.confidence)

        }
    }
}
