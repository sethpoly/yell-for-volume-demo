//
//  AudioRecorder.swift
//  YellForVolume
//
//  Created by Seth Polyniak on 12/7/22.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: ObservableObject {
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    private var audioRecorder: AVAudioRecorder? = nil
    private var timer: Timer? = nil

    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder()
            audioRecorder?.record()
            recording = true
            pollAveragePower()
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        recording = false
        timer?.invalidate()
    }
    
    func pollAveragePower() {
        timer = Timer(timeInterval: 1, repeats: true, block: { [weak self] t in
            let power = self?.audioRecorder?.averagePower(forChannel: 1)
            print("Power = \(power ?? -1)")
        })
    }
}
