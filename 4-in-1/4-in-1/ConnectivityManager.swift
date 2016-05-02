//
//  ConnectivityManager.swift
//  4-in-1
//
//  Created by Alexander on 26/04/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class ConnectivityManager: NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    //Multi Peer Connectivity Framework
    private let serviceType = "4-in-1" //maybe change to "DATX02-12 4-in-1"?
    private let peerId = MCPeerID(displayName: UIDevice.currentDevice().name)
    var session : MCSession!
    private var assistant : MCAdvertiserAssistant!
    private var serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser?
    // Kontroller till injudings-vyn (som finns inbyggd i iOS)
    var bvc : MCBrowserViewController!
    // bool om assistant har startat eller inte
    private var hasStarted : Bool = false
    // GameViewController, används för navigation mellan vyer och för att visa inbjudnings-vyn.
    var gvc : GameViewController?
    // Connection listeners, när data kommer från nätverket så får dom det
    var listeners = [ConnectionListener]()
    
    
    //init, sätter upp allt för Multi Peer Connectivity Framework
    override init(){
        session = MCSession(peer: self.peerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: serviceType)
        assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
        bvc = MCBrowserViewController(serviceType: serviceType, session: session)
        super.init()
        session.delegate = self
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser!.stopBrowsingForPeers()
    }
    
    //konverterar session state till en string
    func stringValue(state: MCSessionState) -> String {
        switch(state) {
            case .NotConnected: return "NotConnected"
            case .Connecting: return "Connecting"
            case .Connected: return "Connected"
        }
    }
    
    //MCNearbyAdvertiserDelegate-protokoll
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?,    invitationHandler: (Bool,
        MCSession) -> Void){
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        //invitationHandler(true, self.session)
    }
    
    //MCNearbyServiceBrowserDelegate-protokoll
    func browser(browser: MCNearbyServiceBrowser,foundPeer peerID: MCPeerID,                         withDiscoveryInfo info: [String : String]?){
        NSLog("%@", "foundPeer: \(peerID)")
        //self.serviceBrowser!.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 20)
    }
    
    func browser(browser: MCNearbyServiceBrowser,
                   lostPeer peerID: MCPeerID){
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
    //MCSessionDelegate-protokoll
    func session(session: MCSession,
                   didReceiveData data: NSData,
                                  fromPeer peerID: MCPeerID){
        let str = decodeString(data)
        NSLog("%@", "didReceiveData: \(str)")
        for l in listeners {
            l.handleMessage(str)
        }
    }
    
    func session(session: MCSession,
                   didStartReceivingResourceWithName resourceName: String,
                                                     fromPeer peerID: MCPeerID,
                                                              withProgress progress: NSProgress){
        // do nothing, not used
    }
    
    func session(session: MCSession,
                   didFinishReceivingResourceWithName resourceName: String,
                                                      fromPeer peerID: MCPeerID,
                                                               atURL localURL: NSURL,
                                                                     withError error: NSError?){
       // do nothing, not used
    }
    
    func session(session: MCSession,
                   didReceiveStream stream: NSInputStream,
                                    withName streamName: String,
                                             fromPeer peerID: MCPeerID){
         // do nothing, not used
    }
    
    //anropas när connectionen byter state, meddelar alla lyssnare
    func session(session: MCSession,
                   peer peerID: MCPeerID,
                        didChangeState state: MCSessionState){
        for l in listeners {
            l.onConnectionStateChange(state)
        }
        debugPrint("New State: \(stringValue(state))")
    }
    
    //lägg till en lyssnare
    func addConnectionListener(listener : ConnectionListener){
        listeners.append(listener)
    }
    
    //decoda en string som skickat över nätverket
    func decodeString(data: NSData) -> String {
        return (NSString(data: data, encoding: NSUTF8StringEncoding))! as String
    }
    
    //skicka en string över nätverket till specifika peers
    func sendString(message: String, peers: [MCPeerID]){
        let data = (message as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let dataMode = MCSessionSendDataMode.Reliable
        do {
            try
                self.session.sendData(data!, toPeers: peers, withMode: dataMode)
        } catch let error as NSError {
            NSLog("%@", "\(error)")
        }
    }
        //skicka en string över nätverket till alla peers
    func sendString(message: String){
        sendString(message, peers: session.connectedPeers)
    }
    
    //MCBrowserViewController-protokolll
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController){
        debugPrint("bvc did finish...")
        gvc?.dismissViewControllerAnimated(true, completion: nil)
        //debugPrint("connected peers: \(session.connectedPeers.count)")
        if session.connectedPeers.count > 0 {
            sendString("start game") //todo include peers index
            gvc?.goToGameScene()
        }
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController){
         debugPrint("bvc was cancelled...")

        gvc?.dismissViewControllerAnimated(true, completion: nil)
        gvc?.goToMenuScene()
    }
    
    //host & join metoder
    func startHosting() {
        if(!hasStarted){
            debugPrint("started hosting")
            assistant.start()
            hasStarted = true
        }
    }
    
    func stopHosting(){
        debugPrint("stopped hosting")
        assistant.stop()
        hasStarted = false
    }
    
    // visar inbjudnings-vyn
    let maximumNumberOfPeersInFourInOneGame = 4 //kanske ska höjas?
    
    func joinSession() {
        bvc.delegate = self
        bvc.maximumNumberOfPeers = maximumNumberOfPeersInFourInOneGame
        gvc?.presentViewController(bvc, animated: true, completion: nil)
    }
        
}

