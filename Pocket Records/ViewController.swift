//
//  ViewController.swift
//  Pocket Records
//
//  Created by Kya Suzuki on 7/15/17.
//  Copyright © 2017 Kya Suzuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func loginButton(_ sender: UIButton) {
         UIApplication.shared.open(loginUrl!, options: [:], completionHandler:nil)
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        // got rid of initial if statement
    }
    
    
    func setup(){
        SPTAuth.defaultInstance().clientID = "95ec648a74444d2e8fa9387d10bf242f"
        SPTAuth.defaultInstance().redirectURL = URL(string: "pocketrecords://returnafterlogin")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
            }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
        //let myObj = "hi" as Any
        NotificationCenter.default.addObserver(self,selector:#selector(ViewController.updateAfterFirstLogin), name: NSNotification.Name("update"), object: nil)
        // removed #selector to rid of error that said "cannot invoke value with an argument list of type selector"
    }
    
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self as! SPTAudioStreamingPlaybackDelegate
            self.player!.delegate = self as! SPTAudioStreamingDelegate
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func updateAfterFirstLogin () {
        if let sessionObj:AnyObject = appDelegate.test.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
    }
    
        
        func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
            // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
            print("logged in")
            self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
                if (error != nil) {
                    print("playing!")
                }
            })
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


