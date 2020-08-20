import Foundation
import UIKit
import AVFoundation
import Speech


struct httpRequestBySwift {
    // https URL
    
    let webURl = PorjectConfiguration.WeblocalhostURL + "t/conversation/add"
    
    //var semaphore = DispatchSemaphore(value: 0)
    
    func fetchDemo(){
        perfromRequest(urlSring: PorjectConfiguration.localhostURL);
        
    }
    
    func perfromRequest(urlSring: String)  {
        if let url = URL(string: urlSring){
            
            let session = URLSession(configuration: .default);
            
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:));
            task.resume();
            
        }
    }
    
    func loginRequest(urlSring: String, username:String, password: String) -> Bool  {
        
        var result = false
        
        let session = URLSession(configuration: .default)
      
        let url = urlSring
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
       
        let postData = ["username":username,"password":password]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
      
        let task = session.dataTask(with: request) {(data, response, error) in
            do {
                let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(r)
                if r["code"] as! Int == 200{
                 print(r["code"] as! Int)
                   result = true
                }
                
            } catch {
                print("can not connect to Server")
                return
            }
        }
        task.resume()
        sleep(1)
        print(result)
        return result
        
    }
    
    func recordRequest(urlSring: String, content:String, provider: String)  {
        
        let session = URLSession(configuration: .default)
      
        let url = urlSring
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
       
        let postData = ["content":content,"provider":provider]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
      
        let task = session.dataTask(with: request) {(data, response, error) in
            do {
                let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(r)
            } catch {
                print("can not connect to Server")
                return
            }
        }
        task.resume()
        
        
    }
    
    func handleByRecord(data: Data?, response: URLResponse?, error: Error?) {
        
    }
    
    func perfromRequest(urlSring: String, callback :@escaping ( _ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void     )  {
           if let url = URL(string: urlSring){
               
               let session = URLSession(configuration: .default);
               
               let task = session.dataTask(with: url, completionHandler: callback);
               task.resume();
               
           }
       }

    func handle(data: Data?, response: URLResponse?, error: Error?) {
        
        
        if (error != nil){
            print(error!);
            return;
        }
        
        if let safeData = data {
                   _ = String(data: safeData, encoding: .utf8);
                   self.parseJSON(resultData: safeData)
                   
        }
 
        
    }
    
    func requestNaoAndCozmo(urlSring: String){
        if let url = URL(string: urlSring){
            
            let session = URLSession(configuration: .default);
            
            let task = session.dataTask(with: url, completionHandler: handleNaoAndCozmo);
            task.resume();  //semaphore.wai return true

            
        }
    }
    
    func handleNaoAndCozmo(data: Data?, response: URLResponse?, error: Error?) {
        
        if (error != nil){
            print(error!);
            return;
        }
    
       
         if let safeData = data {
            _ = String(data: safeData, encoding: .utf8);
            self.parseJSONAndSave(resultData: safeData)
            
         }
 
    }
    
     func parseJSON(resultData: Data)  {
         
    
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
    
    func parseJSONAndSave(resultData: Data)  {
        
   
        let decoder = JSONDecoder()
        
        do{
            let decodeData = try decoder.decode(ResultData.self, from: resultData)
            print(decodeData.result)
            let speechSynthesizer = AVSpeechSynthesizer();
           
            let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: decodeData.result);
                   
            speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0;
                   
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US");
          
                     
                   
            speechSynthesizer.speak(speechUtterance);
            self.recordRequest(urlSring: webURl, content: decodeData.result, provider: "1")

          
               
        }catch {
            print(error)
        }
        
    }
    
    
}
