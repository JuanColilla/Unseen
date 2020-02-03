//
//  SpeechManager.swift
//  Beacon Test
//
//  Created by Juan Colilla on 22/01/2020.
//  Copyright © 2020 Juan Colilla. All rights reserved.
//

import Foundation
import AVFoundation

/**
 Clase responsable de que la aplicación hable en voz alta al usuario. Se utiliza un sintetizador de voz integrado, en esta clase se configuran los detalles de dicho sintetizador tales como el idioma, el ritmo de habla, la voz, etc...
 */

struct SpeechManager {
    
    let synthesizer = AVSpeechSynthesizer()
    var voice = AVSpeechSynthesisVoice()
    
    init() {
        // voice.language = "es-ES" / Falta hacer que la app hable en Español.
    }
    
    /// <#Description#>
    /// - Parameter textToSpeak: <#textToSpeak description#>
    func speak(textToSpeak: String) {
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }

}

