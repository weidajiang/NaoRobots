//
//  TurnTaking.swift
//  NaoRobots
//
//  Created by Weida Jiang on 6/5/20.
//

import Foundation
import Assistant
import AVFoundation
import Speech
import SpeechToText

class Greeting{
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    let queue = DispatchQueue(label: "serialQueue")
    
    var temp = true
    var result=""
    
    var timeout = 5.0
    var code = "0"
    
    var number_of_attempts = 3
    var temp_number_of_attempt = 0
    
    let httpRequest = httpRequestBySwift();
    
    private var controlle: ViewController?;
    
    
    func speakByPhone(resultData: Data) {
        
        let decoder = JSONDecoder()
        
        do{
            let decodeData = try decoder.decode(ResultData.self, from: resultData)
            print(decodeData.result)
            let speechSynthesizer = AVSpeechSynthesizer();
            
            let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: decodeData.result);
            
            speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0;
            
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US");
            speechSynthesizer.speak(speechUtterance);
            
        }catch {
            print(error)
        }
    }
    
    func speakByPhone(outofattempt: String) {
        
        let speechSynthesizer = AVSpeechSynthesizer();
        
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: outofattempt);
        
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.5;
        
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US");
        speechSynthesizer.speak(speechUtterance);
        
        
    }
    

}
