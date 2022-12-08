//
//  YellForVolumeApp.swift
//  YellForVolume
//
//  Created by Seth Polyniak on 12/7/22.
//

import SwiftUI

@main
struct YellForVolumeApp: App {
    @StateObject private var audioRecorder = AudioRecorder()
    var body: some Scene {
        WindowGroup {
            ContentView(audioRecorder: audioRecorder)
        }
    }
}
