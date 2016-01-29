//
//  ViewController.swift
//  Swift-Waver
//
//  Created by nangezao on 14/12/21.
//  Copyright (c) 2014年 dreamer.nange. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var recorder:AVAudioRecorder?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        
        view.backgroundColor = UIColor.grayColor()
        
        let waver = Wave(frame: CGRectMake(0, 0, 320, 200))
        
        weak var weakWaver = waver
        
        waver.setWaverLevelCallback( { () -> () in
            self.recorder?.updateMeters()
            let normalizedValue = pow (10, self.recorder!.averagePowerForChannel(0) / 40)
            weakWaver!.level    = CGFloat(normalizedValue)
        })
        waver.center = view.center
        view.addSubview(waver)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func setupRecorder(){
        let url = NSURL(fileURLWithPath:"/dev/null")

        let settings = [AVSampleRateKey:(NSNumber(float: 44100.0)),
            AVFormatIDKey:NSNumber(integer:Int(kAudioFormatAppleLossless)),
            AVNumberOfChannelsKey:NSNumber(integer: 2),
            AVEncoderAudioQualityKey:NSNumber(integer:AVAudioQuality.Min.rawValue)]
        
        var error:NSError?
        do {
            recorder = try AVAudioRecorder(URL: url, settings: settings)
        } catch let error1 as NSError {
            error = error1
            recorder = nil
        }
        
        if let err = error{
            print("error\(err)", terminator: "" )
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error1 as NSError {
            error = error1
        }

        if let err = error{
            print("error\(err)", terminator: "")
        }
        
        recorder?.prepareToRecord()
        recorder?.meteringEnabled = true
        recorder?.record()
    }
    
}

