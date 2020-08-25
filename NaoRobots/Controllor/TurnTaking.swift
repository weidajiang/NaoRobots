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

class TurnTaking{
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    let queue = DispatchQueue(label: "serialQueue")
    
    var temp = true
    var result=""
    var winresult=""
    
    var timeout = 5.0
    var code = "0"
    
    var temp_final = true
    
    var number_of_attempts = 3
    var temp_number_of_attempt = 0
    
    let httpRequest = httpRequestBySwift();
    let webURl = PorjectConfiguration.WeblocalhostURL + "conversation/add"
    private var controlle: ViewController?;
    
    public func turnTaking(_ controller:ViewController){
        // create a trun taking tast
        httpRequest.perfromRequest(urlSring: PorjectConfiguration.WeblocalhostURL + "data/add?task_type=2")
        
        let url = PorjectConfiguration.localhostURL + "turnTaking?content=default";
        let httpRequest = httpRequestBySwift();
        
        print("start request")
        
        httpRequest.requestNaoAndCozmo(urlSring: url);
        
        Thread.sleep(forTimeInterval: 36.0)
        self.startStreaming()
        
    }
    
    func getWinOrLost(){
        print("getWinOrLost")
        let apiKey = PorjectConfiguration.SpeechToTextAPIKey
        let speechToText = SpeechToText(apiKey: apiKey)
        speechToText.serviceURL = PorjectConfiguration.ServiceURL
        
        var accumulator = SpeechRecognitionResultsAccumulator()
        var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
        settings.interimResults = true
        
        var callback = RecognizeCallback()
        callback.onError = { error in
            print(error)
        }
        callback.onResults = { results in
            accumulator.add(results: results)
            self.winresult = accumulator.bestTranscript
            print(self.winresult)
            if self.winresult.contains("amazing") {
                
                speechToText.stopRecognizeMicrophone()
                print("WinOrLost")
                if(self.temp_final == true){
                    self.httpRequest.recordRequest(urlSring: self.webURl, content: self.winresult, provider: "0")
                    self.temp_final = false
                }

                self.queue.async {
                    Thread.sleep(forTimeInterval: 5.0)
                    self.speakByPhone(outofattempt: "Excellent my partner")
                    let url = PorjectConfiguration.WeblocalhostURL + "/data/complateTask";
                    self.httpRequest.perfromRequest(urlSring: url)
                    
                }
            }
            
        }
        speechToText.recognizeMicrophone(settings: settings, callback: callback)
        
    }
    
    
    func startStreaming() {
        print("startStreaming")
        let apiKey = PorjectConfiguration.SpeechToTextAPIKey
        let speechToText = SpeechToText(apiKey: apiKey)
        speechToText.serviceURL = PorjectConfiguration.ServiceURL
        
        var accumulator = SpeechRecognitionResultsAccumulator()
        var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
        settings.interimResults = true
        
        var callback = RecognizeCallback()
        callback.onError = { error in
            print(error)
        }
        callback.onResults = { results in
            
            accumulator.add(results: results)
            self.result = accumulator.bestTranscript
            print(self.result)
            
        }
        
        speechToText.recognizeMicrophone(settings: settings, callback: callback)
        
        for  _ in 0..<number_of_attempts {
            conuterLoop(content: "hello", speechToText: speechToText,callback: callback, settings: settings)
        }
        
        
        
        queue.async {
            if self.temp_number_of_attempt == self.number_of_attempts{
                Thread.sleep(forTimeInterval: self.timeout)
                self.queue.suspend()
                let url = PorjectConfiguration.WeblocalhostURL + "/data/currentLevel?current_level=1";
                self.httpRequest.perfromRequest(urlSring: url)
                self.speakByPhone(outofattempt: "Oops. we've run out of attempts. Please run the program again.")
                speechToText.stopRecognizeMicrophone()
                return
            }
            self.result = ""
            self.temp_number_of_attempt = 0
        }
        
        queue.async {
            Thread.sleep(forTimeInterval: 7.5)
            self.code = "0"
            self.result = ""
            speechToText.recognizeMicrophone(settings: settings, callback: callback)
        }
        
        for  _ in 0..<number_of_attempts {
            conuterLoop(content: "turnright", speechToText: speechToText,callback: callback, settings: settings)
        }
        
        queue.async {
            if self.temp_number_of_attempt == self.number_of_attempts{
                Thread.sleep(forTimeInterval: self.timeout)
                self.queue.suspend()
                self.speakByPhone(outofattempt: "Oops. we've run out of attempts. Please run the program again.")
                let url = PorjectConfiguration.WeblocalhostURL + "/data/currentLevel?current_level=2";
                self.httpRequest.perfromRequest(urlSring: url)
                speechToText.stopRecognizeMicrophone()
                return
            }
            self.result = ""
            self.temp_number_of_attempt = 0
        }
        
        
        queue.async {
            Thread.sleep(forTimeInterval: 2.5)
            self.code = "0"
            self.result = ""
            speechToText.recognizeMicrophone(settings: settings, callback: callback)
        }
        
        
        for  _ in 0..<number_of_attempts {
            conuterLoop(content: "turnleft", speechToText: speechToText,callback: callback, settings: settings)
        }
        
        queue.async {
            if self.temp_number_of_attempt == self.number_of_attempts{
                Thread.sleep(forTimeInterval: self.timeout)
                self.queue.suspend()
                self.speakByPhone(outofattempt: "Oops. we've run out of attempts. Please run the program again.")
                let url = PorjectConfiguration.WeblocalhostURL + "/data/currentLevel?current_level=3";
                self.httpRequest.perfromRequest(urlSring: url)
                speechToText.stopRecognizeMicrophone()
                return
            }
            self.result = ""
            self.temp_number_of_attempt = 0
        }
        
        queue.async {
            Thread.sleep(forTimeInterval: 2.5)
            self.code = "0"
            self.result = ""
            speechToText.recognizeMicrophone(settings: settings, callback: callback)
        }
        for  _ in 0..<number_of_attempts {
            conuterLoop(content: "turnaround", speechToText: speechToText,callback: callback, settings: settings)
        }
        
        queue.async {
            if self.temp_number_of_attempt == self.number_of_attempts{
                Thread.sleep(forTimeInterval: self.timeout)
                self.queue.suspend()
                self.speakByPhone(outofattempt: "Oops. we've run out of attempts. Please run the program again.")
                let url = PorjectConfiguration.WeblocalhostURL + "/data/currentLevel?current_level=4";
                self.httpRequest.perfromRequest(urlSring: url)
                speechToText.stopRecognizeMicrophone()
                return
            }
            self.result = ""
            self.temp_number_of_attempt = 0
        }
        //---------------
        queue.async {
            Thread.sleep(forTimeInterval: 5.0)
            self.code = "0"
            self.result = ""
            speechToText.recognizeMicrophone(settings: settings, callback: callback)
        }
        for  _ in 0..<number_of_attempts {
            conuterLoop(content: "gostraight", speechToText: speechToText,callback: callback, settings: settings)
        }
        
        queue.async {
            if self.temp_number_of_attempt == self.number_of_attempts{
                Thread.sleep(forTimeInterval: self.timeout)
                self.queue.suspend()
                self.speakByPhone(outofattempt: "Oops. we've run out of attempts. Please run the program again.")
                let url = PorjectConfiguration.WeblocalhostURL + "/data/currentLevel?current_level=5";
                self.httpRequest.perfromRequest(urlSring: url)
                speechToText.stopRecognizeMicrophone()
                return
            }
            self.result = ""
            self.temp_number_of_attempt = 0
        }
        
        queue.async {
            Thread.sleep(forTimeInterval: 2.5)
            self.code = "0"
            self.result = ""
            speechToText.recognizeMicrophone(settings: settings, callback: callback)
        }
        for  _ in 0..<number_of_attempts {
            conuterLoop(content: "keepmoving", speechToText: speechToText,callback: callback, settings: settings)
        }
        
        queue.async {
            if self.temp_number_of_attempt == self.number_of_attempts{
                Thread.sleep(forTimeInterval: self.timeout)
                self.queue.suspend()
                self.speakByPhone(outofattempt: "Oops. we've run out of attempts. Please run the program again.")
                let url = PorjectConfiguration.WeblocalhostURL + "/data/currentLevel?current_level=6";
                self.httpRequest.perfromRequest(urlSring: url)
                speechToText.stopRecognizeMicrophone()
                return
            }
            self.result = ""
            self.temp_number_of_attempt = 0
        }
        
        queue.async {
            Thread.sleep(forTimeInterval: 4.0)
            self.code = "0"
            self.result = ""
            speechToText.recognizeMicrophone(settings: settings, callback: callback)
        }
        for  _ in 0..<number_of_attempts {
            conuterLoop(content: "keepgoing", speechToText: speechToText,callback: callback, settings: settings)
        }
        
        queue.async {
            if self.temp_number_of_attempt == self.number_of_attempts{
                Thread.sleep(forTimeInterval: self.timeout)
                self.queue.suspend()
                self.speakByPhone(outofattempt: "Oops. we've run out of attempts. Please run the program again.")
                let url = PorjectConfiguration.WeblocalhostURL + "/data/currentLevel?current_level=7";
                self.httpRequest.perfromRequest(urlSring: url)
                speechToText.stopRecognizeMicrophone()
                return
            }
            self.result = ""
            speechToText.stopRecognizeMicrophone()
            self.temp_number_of_attempt = 0
        }
        
        queue.async {
            Thread.sleep(forTimeInterval: 3.5)
            self.getWinOrLost()
            let url = PorjectConfiguration.WeblocalhostURL + "/data/currentLevel?current_level=8";
            self.httpRequest.perfromRequest(urlSring: url)
            print("last update= " + self.winresult)
            if self.winresult != "" {
                self.httpRequest.recordRequest(urlSring: self.webURl, content: self.result, provider: "0")

            }
            
        }
        
    }
    
    func getAssistantOutput(text: String, content: String, handle:@escaping () -> Void) {
        let apiKey = PorjectConfiguration.AssistantAPIKey
        let version = PorjectConfiguration.Version
        let assistant = Assistant(version: version, apiKey: apiKey)
        assistant.serviceURL = PorjectConfiguration.AssistantServiceURL
        let workspaceID = PorjectConfiguration.AssistantWorkspace
        var context: Context? // save context to continue the conversation later
        httpRequest.recordRequest(urlSring: webURl, content: text, provider: "0")
        let input = MessageInput(text: text)
        assistant.message(
            workspaceID: workspaceID,
            input: input,
            context: context) { response, error in
                
                if let error = error {
                    print(error)
                }
                guard let message = response?.result else {
                    print("Failed to get the message")
                    return
                }
                print(message.output.text)
                context = message.context
                self.result = message.output.text[0]
                if self.result.contains("Good")  {
                    self.code = "1"
                }else if self.result.contains("Great"){
                    self.code = "2"
                }else if self.result.contains("Awesome"){
                    self.code = "3"
                }else {
                    self.code = "4"
                }
                
                
                // result and user input to web system, store it into database.
                
                let url = PorjectConfiguration.WeblocalhostURL + "/data/updateVoiceResponse";
                
                self.httpRequest.perfromRequest(urlSring: url)
                
                let urlString = PorjectConfiguration.localhostURL + "feedback?content="+content+"&code="+self.code
                
                
                self.httpRequest.perfromRequest(urlSring: urlString, callback: {(data, response, error) ->  Void in
                    print("from IBM" + urlString)
                    
                    //print("callbackcode" + self.code)
                    if let safeData = data {
                        _ = String(data: safeData, encoding: .utf8);
                        self.speakByPhone(resultData: safeData)
                    }
                    
                    if self.code == "4" || self.code == "0" {
                        Thread.sleep(forTimeInterval: 10.0)
                        self.result = "";
                        self.code = "0"
                    }
                    
                })
                
        }
        
    }
    
    func conuterLoop(content: String, speechToText: SpeechToText,callback: RecognizeCallback, settings: RecognitionSettings ){
        self.queue.async {
            if self.code == "1" || self.code == "2" || self.code == "3" {
                return
            }
            
            Thread.sleep(forTimeInterval: self.timeout)
            speechToText.stopRecognizeMicrophone()
            if self.result == ""{
                let urlString = PorjectConfiguration.localhostURL + "errerMessage?content=" + content + "Empty";
                self.httpRequest.requestNaoAndCozmo(urlSring: urlString)
                Thread.sleep(forTimeInterval: self.timeout+1.0)
                self.result = "";
                self.code = "0"
                self.temp_number_of_attempt += 1
                speechToText.recognizeMicrophone(settings: settings, callback: callback)
            }else {
                
                self.getAssistantOutput(text: self.result, content: content, handle: {
                    print("callbackcode=" + self.code)
                })
                print("10s")
                Thread.sleep(forTimeInterval: 10.0)
                self.result = "";
                if(self.code == "1" || self.code == "2" || self.code == "3"){
                    return
                }
                self.temp_number_of_attempt += 1
                speechToText.recognizeMicrophone(settings: settings, callback: callback)
                
            }
        }
    }
    
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
            
            httpRequest.recordRequest(urlSring: webURl, content: decodeData.result, provider: "1")
            
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
        httpRequest.recordRequest(urlSring: webURl, content: outofattempt, provider: "1")
        
    }
    
    
    
    
    
}
