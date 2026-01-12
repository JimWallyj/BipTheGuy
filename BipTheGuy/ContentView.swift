//
//  ContentView.swift
//  BipTheGuy
//
//  Created by Jim Walejko on 1/6/26.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
   // @State private var scale = 1.0 // 100% scale, or original size
    @State private var isFullSize = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage = Image("clown")
    
    var body: some View {
        VStack {
            Spacer()
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(isFullSize ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punchSound")
                    isFullSize = false  // will immediately shrink using .scaleEffect to 90% of size
                    //scale = scale + 0.1  // Increase scale by 10%
                    withAnimation(.spring(response: 03, dampingFraction: 0.3)) {
                        isFullSize = true // will go 90% to 100% size but using the .spring animation
                    }
                }
                //.animation(.spring(response: 0.3, dampingFraction: 0.03), value: scale)
            
            
               Spacer()
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .onChange(of: selectedPhoto) {
                Task{
                    guard let selectedImage = try? await
                            selectedPhoto?.loadTransferable(type: Image.self) else{
                        print("😡 ERROR: Could not get Image from loadTransferable")
                        return
                    }
                    bipImage = selectedImage
                }
            }
        }
        .padding()
    }
    func playSound(soundName: String){
        if audioPlayer != nil && audioPlayer.isPlaying{
                audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else{
            print("😡 Could not read file named \(soundName)")
            return
        }
        // Initialize the AVAudioPlayer & Play Sound
        do{
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        }catch{
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer")
        }
    }
}

#Preview {
    ContentView()
}
