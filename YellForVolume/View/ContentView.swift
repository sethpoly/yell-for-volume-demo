//
//  ContentView.swift
//  YellForVolume
//
//  Created by Seth Polyniak on 12/7/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @State private var volume = 0.0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Press the button i guess")
                    .foregroundColor(.white)
                Button(action: {
                    audioRecorder.startRecording()
                }) {
                    Text("button?")
                        .foregroundColor(.white)
                }
                
                VolumeSlider(
                    value: $volume,
                    minTrackColor: .white,
                    maxTrackColor: .white.opacity(0.3)
                )
                .frame(width: 200, height: 20)

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
