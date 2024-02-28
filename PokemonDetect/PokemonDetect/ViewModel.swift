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
    
    var pokemonClassifier: PokemonClassifier?
    var model: VNCoreMLModel?
    var request: VNCoreMLRequest?
    var handler: VNImageRequestHandler?
    
    @Published var prediction: Prediction?
    
    func classifyPokemon(){
        do{
            model = try VNCoreMLModel(for: PokemonClassifier(configuration: MLModelConfiguration() ).model)
            
            request = VNCoreMLRequest(model: model!)
#if targetEnvironment(simulator)
            request!.usesCPUOnly = true;
#endif
            handler = VNImageRequestHandler(cgImage: (UIImage(named: "charmander")?.cgImage!)!)
            try handler!.perform([request!])
            handleResults(request: request!)
        } catch{
            print(error)
        }
    }
    
    func handleResults(request: VNRequest) {
        var highestPrediction: VNConfidence = 0
        guard let results = request.results as? [VNClassificationObservation] else { return}
        for classification in results {
            if classification.confidence > highestPrediction {
                highestPrediction = classification.confidence
                prediction = Prediction(classification: classification.identifier, confidencePercentage: classification.confidencePercentageString)
            }
//            print(classification.identifier, classification.confidencePercentageString)
        }
    }
}
