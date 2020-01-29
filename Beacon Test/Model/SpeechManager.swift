//
//  SpeechManager.swift
//  Beacon Test
//
//  Created by Juan Colilla on 22/01/2020.
//  Copyright © 2020 Juan Colilla. All rights reserved.
//

import Foundation
import AVFoundation

struct SpeechManager {
    
    let synthesizer = AVSpeechSynthesizer()
    var voice = AVSpeechSynthesisVoice()
    
    init() {
        // voice.language = "es-ES" / Falta hacer que la app hable en Español.
    }
    
    func speak(textToSpeak: String) {
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }

}

