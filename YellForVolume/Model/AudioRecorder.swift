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
    
    static let minimumPower = -50.0
    static let maximumPower = 0.0
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    private var audioRecorder: AVAudioRecorder? = nil
    private var timer: Timer? = nil

    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    @Published var averagePower = 0.0
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            audioRecorder?.isMeteringEnabled = true
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
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] t in
            self?.audioRecorder?.updateMeters()
            let power = self?.audioRecorder?.averagePower(forChannel: 0) ?? Float(AudioRecorder.minimumPower)
            self?.averagePower = self?.normalizePower(power: power) ?? 50.0
            print("Raw decibels = \(power)")
        })
    }
    
    private func normalizePower(power: Float) -> Double {
        var power = Double(power)
        if power < AudioRecorder.minimumPower {
            power = AudioRecorder.minimumPower
        } else if power > AudioRecorder.maximumPower {
            power = AudioRecorder.maximumPower
        }
        
        return (Double(power) - AudioRecorder.minimumPower) / (AudioRecorder.maximumPower - AudioRecorder.minimumPower) * 100
    }
}
