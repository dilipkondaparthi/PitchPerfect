//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Dilip on 15/02/17.
//  Copyright © 2017 Dilip. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!
    @IBOutlet weak var RecordLabel: UILabel!
    @IBOutlet weak var StopRecord: UIButton!
    @IBOutlet weak var TapRecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopRecord.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)  
    }
    
    @IBAction func Record(_ sender: Any) {
        RecordLabel.text = "Recording in progress!"
        StopRecord.isEnabled = true
        TapRecordButton.isEnabled = false
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        TapRecordButton.isEnabled = true
        StopRecord.isEnabled = false
        RecordLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
         if(flag)
         {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else
         {
            print("recording was not successfull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"
        {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }

}

