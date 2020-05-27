//
//  ViewController.swift
//  FirstLogin
//
//  Created by Mina Ramses on 4/19/20.
//  Copyright © 2020 Mina Ramses. All rights reserved.
//

import UIKit
import AVKit

extension UIViewController{
    func HideKeyboard(){
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
        
         }
          @objc func DismissKeyboard(){
                 view.endEditing(true)
    }
}

class ViewController: UIViewController, UITextFieldDelegate {

    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?
    
    @IBOutlet weak var SignUpButtom: UIButton!
    
    @IBOutlet weak var SignButtom: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                setUpElements()
       // self.HideKeyboard()
        
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
           
           // Set up video in the background
           setUpVideo()
       }
    
    func setUpElements(){
        Utilities.styleFilledButton(SignUpButtom)
        Utilities.styleHollowButton(SignButtom)
        
    }

    func setUpVideo() {
        
        // Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        // Create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        // Create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        // Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // Adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // Add it to the view and play it
        videoPlayer?.playImmediately(atRate: 0.3)
    }
}

