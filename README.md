# PokemonDetect

## **Description**

The app was developed as a small project used to understand, learn and practise with CreateML and CoreML during an educational path.

PokemonDetect is an iOS app that allows detect pokemon using the camera or pictures from your photos.
It has been developed using SwiftUI, Vision, CreateML and CoreML. 
It consists in a model created and trained via CreateML that can detect types of pokemon: bulbasaur, charmander, pikachu, squirtle, snorlax and blastoise, and, if the object trying to be detected does not belong to any of these, it also detects that it's not a pokemon.
The model has been used in the project via vision by which a request and its results are handled. 
The image to test are taken using Photopicker and UIImagePickerController, used to browse pictures from photos and camera. 


## **Usage**
By tapping on the pokeball button, the user has to choose whether to use the camera and take a picture of the object to detect, or browse one among their photos. 
