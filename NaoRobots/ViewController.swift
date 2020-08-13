//
//  ViewController.swift
//  NaoRobots
//
//  Created by Haoliang Zhang on 8/30/19.
//  Updated by Weida Jiang on 4/17/20
//  Copyright © 2019 Haoliang Zhang. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import Assistant

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var darkBlueBG: UIImageView!
    @IBOutlet weak var powerBtn: UIButton!
    @IBOutlet weak var cloudHolder: UIView!
    @IBOutlet weak var rocket: UIImageView!
    @IBOutlet weak var hustleLbl: UILabel!
    @IBOutlet weak var onLbl: UILabel!
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var recordButton: UIButton!
    
    var httpRequest = httpRequestBySwift();
    var turnTaking = TurnTaking();
    
    
    var player: AVAudioPlayer!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton?.isEnabled = false
        //self.initAssistant()
        let path = Bundle.main.path(forResource: "math-on", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "TTS_backgroupimage.png")!)
        
    }
    
    func initAssistant(){
        
        let apiKey = "yTTb9qjBX5YGW9M3ekwadCtb1uWki-Od605ov1qN5SRO"
        let version = "2018-02-01" // use today's date for the most recent version
        let assistant = Assistant(version: version, apiKey: apiKey)
        assistant.serviceURL="https://api.us-east.assistant.watson.cloud.ibm.com"
        let workspaceID = "de0cb2c3-1667-4260-816f-26c585d15471"
        var context: Context? // save context to continue the conversation later
        
        let input = MessageInput(text: "Keep going")
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
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Configure the SFSpeechRecognizer object already
        // stored in a local member variable.
        speechRecognizer.delegate = self
        
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton?.isEnabled = true
                    
                case .denied:
                    self.recordButton?.isEnabled = false
                    self.recordButton?.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordButton?.isEnabled = false
                    self.recordButton?.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordButton?.isEnabled = false
                    self.recordButton?.setTitle("Speech recognition not yet authorized", for: .disabled)
                    
                default:
                    self.recordButton?.isEnabled = false
                }
            }
        }
    }
    
    @IBAction func openSafari(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://www.google.com")! as URL,options: [:],completionHandler: nil)
    }
    
    @IBAction func powerBtnPressed(_ sender: Any) {
        cloudHolder.isHidden = false
        darkBlueBG.isHidden = true
        powerBtn.isHidden = true
        
        player.play()
        
        UIView.animate(withDuration: 2.3, animations: {
            self.rocket.frame = CGRect(x: 0, y: 140, width: 375, height: 402)
        }) { (finished) in
            self.hustleLbl.isHidden = false
            self.onLbl.isHidden = false
        }
    }
    
    
    //    @IBAction func callingTheRobot(_ sender: Any) {
    //        UIApplication.shared.open(URL(string:))
    //    }
    
    //
    
    
    
    
    @IBAction func goStraight(_ sender: UIButton) {
        
        
        
        let speechSynthesizer = AVSpeechSynthesizer();
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "go straight");
        
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0;
        
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US");
        
        speechSynthesizer.speak(speechUtterance);
    }
    
    
    
    @IBAction func turnRight(_ sender: UIButton) {
        
        
        let speechSynthesizer = AVSpeechSynthesizer();
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "turn right");
        
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0;
        
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US");
        
        speechSynthesizer.speak(speechUtterance);
    }
    
    
    
    @IBAction func turnLeft(_ sender: UIButton) {
        
        
        
        let speechSynthesizer = AVSpeechSynthesizer();
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "turn left");
        
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0;
        
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US");
        
        speechSynthesizer.speak(speechUtterance);
    }
    
    
    
    
    
    @IBAction func keepMoving(_ sender: UIButton) {
        
        print("botton click");
        
        let speechSynthesizer = AVSpeechSynthesizer();
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "Keep moving");
        
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0;
        
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US");
        
        speechSynthesizer.speak(speechUtterance);
    }
    
    
    
    
    @IBAction func keepGoing(_ sender: UIButton) {
        
        print("botton click");
        
        let speechSynthesizer = AVSpeechSynthesizer();
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "Keep going");
        
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0;
        
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US");
        
        speechSynthesizer.speak(speechUtterance);
        
        
        
    }
    
    
    
    
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
        } else {
            do {
                try startRecording()
                recordButton.setTitle("Stop Recording", for: [])
            } catch {
                recordButton.setTitle("Recording Not Available", for: [])
            }
        }
        
    }
    
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                print("Text \(result.bestTranscription.formattedString)")
                
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                print("hahaah")
                self.recordButton?.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
            }
        }
        
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        // Let the user know to start talking.
        textView.text = "(Go ahead, I'm listening)"
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition Not Available", for: .disabled)
        }
    }
    
    
    @IBAction func greetingRequest(_ sender: UIButton) {
        
        httpRequest.fetchDemo();
    }
    
    
    private func startRecordResult() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        var isProcess = true
        var isSecond = true
        var isThird = true
        var isFourth = true
        var  isfifth = true
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            var url=PorjectConfiguration.localhostURL;
            
            
            
            if let result = result {
                // Update the text view with the results.
                
                isFinal = result.isFinal
                
                print("Text \(result.bestTranscription.formattedString)")
                if result.bestTranscription.formattedString.contains("see my") && isProcess{
                    print("aaaaa")
                    isProcess = false
                    print("asdsad" + result.bestTranscription.formattedString);
                    let urlString = url + "findmycube?content=seemycube";
                    self.httpRequest.requestNaoAndCozmo(urlSring: urlString)
                    
                }else if result.bestTranscription.formattedString.contains("tell me") && isSecond{
                    print("SECOND")
                    isSecond = false
                    //                    self.audioEngine.stop()
                    //                    inputNode.removeTap(onBus: 0)
                    //
                    //                    self.recognitionRequest = nil
                    //                    self.recognitionTask = nil
                    print("asdsad" + result.bestTranscription.formattedString);
                    let urlString = url + "findmycube?content=instructions";
                    self.httpRequest.requestNaoAndCozmo(urlSring: urlString)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8) {
                        let urlString1 = url + "findmycube?content=turnaround";
                        self.httpRequest.requestNaoAndCozmo(urlSring: urlString1)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 13) {
                        let urlString2 = url + "findmycube?content=gostraight";
                        self.httpRequest.requestNaoAndCozmo(urlSring: urlString2)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 18) {
                        let urlString2 = url + "findmycube?content=keepgoing";
                        self.httpRequest.requestNaoAndCozmo(urlSring: urlString2)
                    }
                    
                    //isProcess = true
                }else if result.bestTranscription.formattedString.contains("red") && isFourth{
                    print("SECOND")
                    isFourth = false
                    
                    print("asdsad" + result.bestTranscription.formattedString);
                    let urlString =  url + "findmycube?content=redcube";
                    self.httpRequest.requestNaoAndCozmo(urlSring: urlString)
                    //isProcess = true
                }else if result.bestTranscription.formattedString.contains("sure") && isfifth{
                    print("SECOND")
                    isfifth = false
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    print("asdsad" + result.bestTranscription.formattedString);
                    let urlString =  url + "findmycube?content=sure";
                    self.httpRequest.requestNaoAndCozmo(urlSring: urlString)
                    //isProcess = true
                }
                
                
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                print("hahaah")
                
            }
        }
        
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        
    }
    
    
    @IBAction func requestNaoCozmo(_ sender: UIButton){
        
        let urlString = "https://8378e6b3df85.ngrok.io/greeting?content=";
        
        print(urlString)
        httpRequest.requestNaoAndCozmo(urlSring: urlString)
        
        
        
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            //recordButton.isEnabled = false
            //recordButton.setTitle("Stopping", for: .disabled)
        } else {
            do {
                try startRecordResult()
                //recordButton.setTitle("Stop Recording", for: [])
            } catch {
                //recordButton.setTitle("Recording Not Available", for: [])
            }
        }
        
    }
    
    @IBAction func startFindCube(_ sender: Any) {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            //recordButton.isEnabled = false
            //recordButton.setTitle("Stopping", for: .disabled)
        } else {
            do {
                try startRecordResult()
                //recordButton.setTitle("Stop Recording", for: [])
            } catch {
                //recordButton.setTitle("Recording Not Available", for: [])
            }
        }
        
        
        
        
    }
    @IBAction func turnTaking(_ sender: UIButton) {
        turnTaking.turnTaking(self);
        
    }
    
    
    
    @IBAction func sneeze(_ sender: Any) {
        
        var url=PorjectConfiguration.localhostURL;
        httpRequest.perfromRequest(urlSring: url + "sneeze")
        
        
    }
    
    
    @IBAction func eyeItchy(_ sender: Any) {
        var url=PorjectConfiguration.localhostURL;
        httpRequest.perfromRequest(urlSring: url + "eyeItchy")
    }
    
    
    
    @IBAction func elbowBump(_ sender: Any) {
        var url=PorjectConfiguration.localhostURL;
        httpRequest.perfromRequest(urlSring: url + "elbowBump")
        
    }
}
