//
//  RecordSoundsController.swift
//  Pitch Perfect
//
//  Created by Tony Buckner on 2/15/17.
//  Copyright © 2017 Tony Buckner. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordingButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopRecordingButton.isEnabled = false
        
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        
        configureUI(recording: true)
        
        //record audio code for recording and string the data
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func recordStop(_ sender: AnyObject) {
        
        configureUI(recording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished")
        
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordAudioURL
        }
    }
    
    func configureUI(recording: Bool){
        // Set label
        recordingLabel.text =
            recording ? "Recording in progress" : "Tap to Record"
        
        // Set buttons
        recordingButton.isEnabled = !recording
        stopRecordingButton.isEnabled = recording
    }
}

