//
//  ViewController.swift
//  RecordScreen
//
//  Created by Pasca Alberto, IT on 29/11/2019.
//

import UIKit
import AudioToolbox
import ReplayKit

class ViewController: UIViewController {
    
    let recorder = RPScreenRecorder.shared()
    
    let colors: [UIColor] = [
        UIColor.green,
        UIColor.red,
        UIColor.yellow,
        UIColor.cyan,
        UIColor.orange,
        UIColor.blue
    ]
    
    @IBOutlet weak var lblRandom: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { t in
            self.lblRandom.text = "\(Int.random(in: 0 ..< 100))"
            self.view.backgroundColor = self.colors[Int.random(in: 0 ..< self.colors.count)]
        }
        
        setUpLongPressGestureRecognizer()
    }
    
    func setUpLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction(sender:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delaysTouchesBegan = true
        
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    @objc func longPressAction(sender: UILongPressGestureRecognizer) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.recording(state: sender.state == .began)
    }
    
    func recording(state: Bool) {
        if state {
            guard recorder.isAvailable else { return }
            recorder.startRecording{ (error) in
                guard error == nil else { return }
            }
        } else {
            recorder.stopRecording { (preview, error) in
                guard let preview = preview else { return }

                preview.modalPresentationStyle = .automatic
                preview.previewControllerDelegate = self

                self.present(preview, animated: true, completion: nil)
            }
        }
    }
    
}

extension ViewController : RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
    }
    
}
