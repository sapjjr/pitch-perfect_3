//
//  PlayRcordedSoundViewController.swift
//  PitchPerfect
//
//  Created by andrew on 14/03/2015.
//  Copyright (c) 2015 Firekite. All rights reserved.
//

import UIKit
import AVFoundation

class PlayRcordedSoundViewController: UIViewController {

    
    //global variable declarations
    var receivedAudio: RecordedAudio! //also data to be recieved from sender seque
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    //initialised here
    audioEngine = AVAudioEngine()
    
    //create instance of the audio engine (1) and initialised here
    audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func buttonPlaySlowAudio(sender: UIButton) {
        sharedAudioFunction(0.5, typeOfChange: "rate")
    }
    @IBAction func buittonPlayFast(sender: UIButton) {
        sharedAudioFunction(1.9, typeOfChange: "rate")
    }
    @IBAction func buttonStopPlayer(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
    }
    @IBAction func buttonPlayChipMonk(sender: UIButton) {
        sharedAudioFunction(1000, typeOfChange: "pitch")
    }
    @IBAction func buttonPlayDarthVadar(sender: UIButton) {
        sharedAudioFunction(-1000, typeOfChange: "pitch")
    }
    
    
    func sharedAudioFunction(audioValue: Float, typeOfChange: String){

        // stop and restart the audio to prepare for next play
        audioEngine.stop()
        audioEngine.reset()

        //create instance of a player (2)
        var audioPlayerNode = AVAudioPlayerNode()
        // attach the engine to the player so it is aware of the player (3)
        audioEngine.attachNode(audioPlayerNode)
   
        
        var audioEffect = AVAudioUnitTimePitch()
        if (typeOfChange == "rate") {
            audioEffect.rate = audioValue
        } else {
            audioEffect.pitch = audioValue
        }
 
        audioEngine.attachNode(audioEffect)
        audioEngine.connect(audioPlayerNode, to: audioEffect, format: nil)
        audioEngine.connect(audioEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        // at time 0 means play immediately
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
// end of class
}
