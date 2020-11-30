//
//  ViewController.swift
//  SketchPad
//
//  Created by Shahbaz Alam on 19/11/20.
//  Copyright © 2020 Shahbaz Alam. All rights reserved.
//

import UIKit
import PencilKit
import PhotosUI
import AVFoundation


class ViewController: UIViewController {

    @IBOutlet weak var canvasView: PKCanvasView!
    
    var audio: AVAudioPlayer!
        
    override func viewDidLoad() {
        super.viewDidLoad()
         
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpCanvasView()
        
    }
  
    private func setUpCanvasView() {
        
        if let window = view.window, let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder()
        }
    }
   

    @IBAction func snapBtn(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Saved Successfully..!!", message: "Picture are saved into your photos library", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            
            self.canvasView.drawing = PKDrawing()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: "capture-sound", ofType: "mp3") ?? "Error")
        print("sound",sound)
        do {
            audio = try AVAudioPlayer(contentsOf: sound)
            audio.play()
        } catch {
            print("Can't play sound")
        }
        
        
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image!)
            }) { (success, error) in
                
                
            }
        }
        
        
    }
    
    @IBAction func clearBtn(_ sender: UIBarButtonItem) {
        
        canvasView.drawing = PKDrawing()

    }
}

