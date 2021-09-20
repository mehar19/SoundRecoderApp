//
//  ViewController.swift
//  SoundRecoderApp
//
//  Created by Mehar on 16/09/2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //MARK: - Declarations
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonA: UIButton!    
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    var recodingSession: AVAudioSession!
    var audioRecoder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    let sounds = ["a","b","c","d"]
    
    func getDicrectory()-> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory
    }
    
    //MARK: - Lifecycle hook
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...4{
            let path = getDicrectory().appendingPathComponent("\(i).m4a").path
            if FileManager.default.fileExists(atPath: path){
                var button = self.view.viewWithTag(i) as? UIButton
                button?.setTitle("Play", for: .normal)
            }
        }
        
        let longPressRecognizerA = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        buttonA.addGestureRecognizer(longPressRecognizerA)
        let longPressRecognizerB = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        buttonB.addGestureRecognizer(longPressRecognizerB)
        let longPressRecognizerC = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        buttonC.addGestureRecognizer(longPressRecognizerC)
        let longPressRecognizerD = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        buttonD.addGestureRecognizer(longPressRecognizerD)
        
        recodingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { (accepted) in
            if accepted {
                print("permission granted")
            }
        }
        
        
    }
    //MARK: - UI Functions
    
    @objc func longPressed(sender: UILongPressGestureRecognizer){
        
        let tag = sender.view!.tag
        let button = sender.view as? UIButton
        
        if sender.state == .began{
            print("button held down")
            button!.setTitle("Recording....)", for: .normal)
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
                try
                    recodingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                let filename = getDicrectory().appendingPathComponent("\(tag).m4a")
                audioRecoder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecoder.record()
            }catch{
                print("fail to record")
            }
            
        }else if sender.state == .ended{
            button?.setTitle("Play", for: .normal)
            audioRecoder.stop()
            audioRecoder = nil
        }
    }
    
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let tag = sender.tag
        let path = getDicrectory().appendingPathComponent("\(tag).m4a").path
        
        if FileManager.default.fileExists(atPath: path){
            //play the recoreded file
            let filePath = getDicrectory().appendingPathComponent("\(tag).m4a")
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: filePath)
                audioPlayer.play()
            }
            catch{
                print("Failed to play file")
            }
        }else{
            //play th default files
            
            let url = Bundle.main.url(forResource: sounds[sender.tag - 1], withExtension:"mp3")
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: url!)
                audioPlayer.play()
                
            }catch{
                print("Failed to play")
                
            }
        }
    
    }
    
}

