//
//  ConnectivityManager.swift
//  4-in-1
//
//  Created by Alexander on 26/04/16.
//  Copyright © 2016 Chalmers. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class ConnectivityManager: NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, InGameEventListener, NavigationEventListener {
    //Multi Peer Connectivity Framework
    private let serviceType = "CIRKVA" //maybe change to "DATX02-12 4-in-1"?
    private let peerId = MCPeerID(displayName: UIDevice.currentDevice().name)
    var session : MCSession!
    private var assistant : MCAdvertiserAssistant!
    private var serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser?
    // Kontroller till injudings-vyn (som finns inbyggd i iOS)
    //var bvc : MCBrowserViewController!
    // bool om assistant har startat eller inte
    private var hasStarted : Bool = false
    // GameViewController, används för navigation mellan vyer och för att visa inbjudnings-vyn.
    var gvc : GameViewController?
    // Connection listeners, när data kommer från nätverket så får dom det
    var listeners = [ConnectionListener]()
    var navigationEventListeners = [NavigationEventListener]()
    var networkGameEventListeners = [NetworkGameEventListener]()

    
    
    //init, sätter upp allt för Multi Peer Connectivity Framework
    override init(){
        session = MCSession(peer: self.peerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: serviceType)
        assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)

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
        
        if let event = GameEvent.fromString(str) {
            switch event {
            case .gameOver:
                fireNavigationEvent(GameEvent.Navigation.endGame)
                break
            default:
                for l in networkGameEventListeners {
                    l.onGameEventOverNetwork(event)
                }
            }
        } else if let navEvent = GameEvent.Navigation.fromString(str){
            for l in navigationEventListeners {
                l.onNavigationEvent(navEvent)
            }
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
            l.onConnectionStateChange(state, count: session.connectedPeers.count)
        }
        debugPrint("New State: \(stringValue(state))")
    }
    
    //lägg till lyssnare
    func addConnectionListener(listener : ConnectionListener){
        listeners.append(listener)
    }
    
    func addNavigationListener(listener : NavigationEventListener){
        navigationEventListeners.append(listener)
    }
    
    func addNetworkGameEventListener(listener : NetworkGameEventListener){
        networkGameEventListeners.append(listener)
    }
        
    //decoda en string som skickat över nätverket
    func decodeString(data: NSData) -> String {
        return (NSString(data: data, encoding: NSUTF8StringEncoding))! as String
    }
    
    //skicka en string över nätverket till specifika peers
    func sendString(message: String, peers: [MCPeerID]){
        debugPrint("sending message: \(message)")
        let data = (message as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let dataMode = MCSessionSendDataMode.Reliable
        do {
            try
                self.session.sendData(data!, toPeers: peers, withMode: dataMode)
        } catch let error as NSError {
            NSLog("%@", "\(error)")
        }
        /*
        for listener in listeners {
            listener.handleMessage(message)
        }*/
    }
    //skicka en string över nätverket till alla peers
    func sendString(message: String){
        sendString(message, peers: session.connectedPeers)
    }
    // Navigation Event funcs
    func addNavigationEventListener(listener : NavigationEventListener){
        navigationEventListeners.append(listener)
    }
    
    //MCBrowserViewController-protokolll
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController){
        debugPrint("bvc did finish...")
        gvc?.dismissViewControllerAnimated(true, completion: nil)
        let numberOfplayers = session.connectedPeers.count + 1
        /*
        if numberOfPlayers > 1 {
            let numberOfplayers = session.connectedPeers.count + 1
            for index in 0...self.session.connectedPeers.count-1 {
                let id: [MCPeerID] = [self.session.connectedPeers[index]]
                let event = GameEvent.Navigation.startGame(level: numberOfplayers, ipadIndex: index+1)
                broadcastNavigationEvent(event, peers: id)
                //sendString("\(index+1)", peers: id)
            }
            fireNavigationEvent(GameEvent.Navigation.startGame(level: numberOfplayers, ipadIndex: 0))
        } */
        fireNavigationEvent(GameEvent.Navigation.selectLevel(numberOfPlayers: numberOfplayers))

    }
    
    func startGame(level: Int, numberOfPlayers: Int){
         if numberOfPlayers > 1 {
         for index in 0...self.session.connectedPeers.count-1 {
            let id: [MCPeerID] = [self.session.connectedPeers[index]]
            let event = GameEvent.Navigation.startGame(level: level, numberOfPlayers: numberOfPlayers, ipadIndex: index+1)
            broadcastNavigationEvent(event, peers: id)
            //sendString("\(index+1)", peers: id)
         }
         fireNavigationEvent(GameEvent.Navigation.startGame(level: level, numberOfPlayers: numberOfPlayers, ipadIndex: 0))
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
    let minimumNumberOfPeersInCirkva = 2
    let maximumNumberOfPeersInCirkva = 4
    
    func joinSession() {
        let bvc = MCBrowserViewController(serviceType: serviceType, session: session)
        bvc.delegate = self
        bvc.minimumNumberOfPeers = minimumNumberOfPeersInCirkva
        bvc.maximumNumberOfPeers = maximumNumberOfPeersInCirkva
        gvc?.presentViewController(bvc, animated: true, completion: nil)
    }
    
    //InGameEventListener
    func onInGameEvent(event: GameEvent) {
        broadcastGameEvent(event)
    }
    
    //Navigation Event funcs
    func onNavigationEvent(event: GameEvent.Navigation) {
        for listener in navigationEventListeners {
            listener.onNavigationEvent(event)
        }
    }
    
    func fireNavigationEvent(event: GameEvent.Navigation){
        for listener in navigationEventListeners {
            listener.onNavigationEvent(event)
        }
    }
    func broadcastGameEvent(event: GameEvent){
        sendString(GameEvent.toString(event))
    }
    
    func broadcastNavigationEvent(event: GameEvent.Navigation, peers: [MCPeerID]){
        sendString(GameEvent.Navigation.toString(event), peers: peers)
    }
}

