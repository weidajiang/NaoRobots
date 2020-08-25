//
//  SlimeViewController.swift
//  NaoRobots
//
//  Created by Natan Schattner-Elmaleh on 8/20/20.
//  Copyright © 2020 Haoliang Zhang. All rights reserved.
//

import UIKit

class SlimeViewController: UIViewController, UIDropInteractionDelegate, UIDragInteractionDelegate {

    @IBOutlet weak var waterImageView: UIImageView!
    @IBOutlet weak var bakingsodaImageView: UIImageView!
    @IBOutlet weak var bowlImageView: UIImageView!
    
    
    var water = UIImage(named: "water")
    var bakingsoda = UIImage(named: "bakingsoda")
    
    var waterbowl = UIImage(named: "waterbowl")
    var slimebowl = UIImage(named: "slimebowl")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        bowlImageView.isUserInteractionEnabled = true
        waterImageView.isUserInteractionEnabled = true
        bakingsodaImageView.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        
        
        // waterImageView.isUserInteractionEnabled = true
        // bakingsodaImageView.isUserInteractionEnabled = true
        view.addInteraction(UIDropInteraction(delegate: self))
            
        let dragInteraction1 = UIDragInteraction(delegate: self)
        waterImageView.addInteraction(dragInteraction1)
        dragInteraction1.isEnabled = true
        
        let dragInteraction2 = UIDragInteraction(delegate: self)
        bakingsodaImageView.addInteraction(dragInteraction2)
        dragInteraction2.isEnabled = true
        
        //view.addInteraction(dragInteraction)
        
    }
    
    func image(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
        let data1: NSData = image1.pngData()! as NSData
        let data2: NSData = image2.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        for dragItem in session.items {
            dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { object, error in
                guard error == nil else { return print("Failed to load dragged item")}
                guard let draggedImage = object as? UIImage else { return}
                DispatchQueue.main.async {
                    let centerPoint = session.location(in: self.view)
                    if self.image(image1: self.water!, isEqualTo: draggedImage) {
                        self.bowlImageView.image = self.waterbowl
                        self.bowlImageView.center = centerPoint
                    } else if self.image(image1: self.bakingsoda!, isEqualTo: draggedImage) {
                        self.bowlImageView.image = self.slimebowl
                        self.bowlImageView.center = centerPoint
                    } else {
                        print("No compatible images dragged")
                    }
                }
            })
        }
    }
    
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        /* print("test0")
        
        var isWater = false
        var isBakingsoda = false
        
        print("test1")
        
        if let image = waterImageView.image {
            isWater = true
            print("test2")
        } else if let image = bakingsodaImageView.image {
            isBakingsoda = true
            print("test3")
        } else {
            print("Nothing picked up")
            return []
            
        }
        var image = UIImage()
        if isWater {
            image = waterImageView.image!
        } else if isBakingsoda {
            image = bakingsodaImageView.image!
        }
        
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = image
        return [item]
        */
        
        let touchedPoint = session.location(in: self.view)
        if let touchedImageView = self.view.hitTest(touchedPoint, with: nil) as? UIImageView{
            let touchedImage = touchedImageView.image
            let itemProvider = NSItemProvider(object: touchedImage!)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = touchedImage
            return [dragItem]
        }
        
        return[]
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
