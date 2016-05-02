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
    /*
        dns-sd -B _services._dns-sd._udp
    */
    
    private let serviceType = "4-in-1"
    private let peerId = MCPeerID(displayName: UIDevice.currentDevice().name)
    var session : MCSession!
    private var assistant : MCAdvertiserAssistant!
    var bvc : MCBrowserViewController!
    private var serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser?
    private var hasStarted : Bool = false
    
    var gvc : GameViewController?
    var listeners = [ConnectionListener]()
    
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
    
    func stringValue(state: MCSessionState) -> String {
        switch(state) {
            case .NotConnected: return "NotConnected"
            case .Connecting: return "Connecting"
            case .Connected: return "Connected"
        }
    }
    
    //MCNearbyAdvertiserDelegate
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?,    invitationHandler: (Bool,
        MCSession) -> Void){
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        //invitationHandler(true, self.session)
    }
    
    //MCNearbyServiceBrowserDelegate
    func browser(browser: MCNearbyServiceBrowser,foundPeer peerID: MCPeerID,                         withDiscoveryInfo info: [String : String]?){
        NSLog("%@", "foundPeer: \(peerID)")
        //self.serviceBrowser!.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 20)
    }
    
    func browser(browser: MCNearbyServiceBrowser,
                   lostPeer peerID: MCPeerID){
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
    //MCSessionDelegate
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
    
    func session(session: MCSession,
                   peer peerID: MCPeerID,
                        didChangeState state: MCSessionState){
                NSLog("%@", "peer \(peerID) didChangeState: \(stringValue(state))")
        
        for l in listeners {
            l.onConnectionStateChange(state)
        }
        if state == .Connected {
            /*
            var counter = 1
            for peer in session.connectedPeers {
                sendString("ipad \(counter)", peers: [peer])
                counter += 1
            }*/
            
            debugPrint("connected peers: \(session.connectedPeers.count)")
            for peer in session.connectedPeers {
                debugPrint("\(peer.displayName) :  \(session.connectedPeers.indexOf(peer))")
            }
            //gvc?.goToGameScene()
        }
    }
    
    // funcs
    func addConnectionListener(listener : ConnectionListener){
        listeners.append(listener)
    }
    
    func decodeString(data: NSData) -> String {
        return (NSString(data: data, encoding: NSUTF8StringEncoding))! as String
    }
    
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
    
    func sendString(message: String){
        sendString(message, peers: session.connectedPeers)
    }
    
    //MCBrowserViewController
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
    
    //host & join methods
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
    
    func joinSession() {
        bvc.delegate = self
        bvc.maximumNumberOfPeers = 4
        gvc?.presentViewController(bvc, animated: true, completion: nil)
    }
        
}

