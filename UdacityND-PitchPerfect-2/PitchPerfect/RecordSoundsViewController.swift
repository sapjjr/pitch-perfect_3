//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by andrew on 13/03/2015.
//  Copyright (c) 2015 Firekite. All rights reserved.
//  NEARLY ALL OF THIS WORK HAS BEEN TAKEN FROM THE THE UDACITY NANODEGREE COURSE

// The Use of the audio Engine was take from the the following website
// which came out of a search for Audio Pitch tools
//  swiftios8dev.wordpress.com/about/

// I have each button named so that they can be identified lator


import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var labelRecordinginProgress: UILabel!
    @IBOutlet weak var buttonStopRecordingimage: UIButton!
    @IBOutlet weak var buttonStartRecordingOutlet: UIButton!
    
    @IBOutlet weak var labelTapToRecordMessage: UILabel!
    //Declared Globally
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        //hide the stop button
        buttonStopRecordingimage.hidden = true
        labelTapToRecordMessage.hidden = false
        buttonStartRecordingOutlet.enabled = true
    }

    @IBAction func buttonRecordAudio(sender: UIButton) {
        // show recording in progress
        // add a users voice
        println("recording")
        labelRecordinginProgress.hidden = false
        buttonStopRecordingimage.hidden = false
        buttonStartRecordingOutlet.enabled = false
        labelTapToRecordMessage.hidden = true
        
        
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }

        //once delegate has been set up can use this function
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {

        
        if(flag) {
        //save recorded audio - see global variable above and also the model
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        
        
        //move to next scene via a seque
        self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        }else{
            println("Recording not completed succesfully")
            buttonStopRecordingimage.hidden = true
            buttonStartRecordingOutlet.enabled = true
        }
        
        
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "stopRecordingSegue" ){
            let playSoundsVC: PlayRcordedSoundViewController = segue.destinationViewController as
            PlayRcordedSoundViewController
            // as function converts to the correct type
            
            
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
             
        }
    }
    
    
    @IBAction func buttonStopRecording(sender: UIButton) {
        //stop the recording
        //Inside func stopAudio(sender: UIButton)
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        
        
        
        //hide the recording button
        labelRecordinginProgress.hidden = true
        //hide the stop button
        buttonStopRecordingimage.hidden = true
        //re-enable recording button but this may be better in the viewWillApear area
        buttonStartRecordingOutlet.enabled = true
        //save the recording
        
        
    }
    
    
   }

