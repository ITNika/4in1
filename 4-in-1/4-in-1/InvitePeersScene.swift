//
//  InvitePeersScene.swift
//  4-in-1
//
//  Created by Emina Hromic on 2016-04-26.
//  Copyright © 2016 Chalmers. All rights reserved.
//
//

import UIKit
import MultipeerConnectivity

/**
 Detta är en klass som skapar en chatt-konversation. Applikationen använder sig av ramverket Multipeer Connectivity Framework, som innebär att samtliga enheter som är anslutna till samma WiFi eller Bluetooth kan ha en chatt-konversation med varandra. Dock måste användaren bjuda in andra användare på nätverket, och sedan måste denna inbjudan accepteras. Därefter kan en chatt-konversation starta mellan användarna. Samtliga meddelanden visas för samtliga användare.
 */

//Protokollet MCSessionDelegate ser till att delegate notifieras när anslutna enheter ändras eller när data mottas.

//Protokollet MCBrowserViewControllerDelegate hanterar events relaterade till MCBrowserViewController

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate  {
    
    //serviceType kan vara vad som helst, så länge det är kortare än 15 ASCII tecken.
    let serviceType = "Four-In-One-Game"
    
    
    //En controller som används för att scanna och bjuda in andra peers manuellt. MCNearbyServiceBrowserDelegate används när vilken peer som helst ska bjudas in automatiskt.
    var browser : MCBrowserViewController!
    
    //Ser till att sessioner ptivata genom notifiera och fråga användaren att bekräfta inkomna inbjudningar.
    var assistant : MCAdvertiserAssistant!
    
    //the object holding the sessions once it has been negotiated
    var session : MCSession!
    
    //representerar peer ID:t för session
    var peerID: MCPeerID!
    
    
    //Laddar själva viewen
    
    //Koden initierar alla Multicast Peer objekt innan "advertiser" blir tilltalad att börja visa
    // sin tillgänglighet
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hämtar namnet för enheten i fråga
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // Skapar BrowserViewController med ett unikt servicenamn
        self.browser = MCBrowserViewController(serviceType:serviceType,
                                               session:self.session)
        
        self.browser.delegate = self;
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
                                               discoveryInfo:nil, session:self.session)
        
        //Säger åt "assistant" att starta chatten
        self.assistant.start()
    }
    
    
    //SKALL IMPLEMENTERAS
    
    //Metoden skall skicka objekt mellan enheterna.
    //Användarna skall kunna swipa över en gubbe från en enhet till en annan.
    @IBAction func sendObject(sender: AnyObject) {

    }
    
    //SKALL IMPLEMENTERAS - om behovet finns av denna?
    
    //Denna metod metod upptaderar innehållet på samtliga berörda enheter.
    func updateContent(charachterId : Int, fromPeer peerID: MCPeerID) {
        
    }
    
    //Öppnar ett nytt fönster där användaren kan bjuda in flera personer (upp till 7 st) som är anslutna till samma nätverk.
    @IBAction func showBrowser(sender: AnyObject) {
        // Visar Browser view controller
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    
    
    
    //Metoden kallas när användaren trycker på knappen done.
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController)  {
        //prebuilt view controller for handling and negotiating browsing for connections.
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //Kallas när BrowserViewController avslutas - användaren trycker på knappen cancel
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController)  {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Denna metod kallas när sessionen mottar något data. Metoden skall lägga till den nya datan till och visa den på mottagarens textfält.
    func session(session: MCSession, didReceiveData data: NSData,
                 fromPeer peerID: MCPeerID)  {
        
        // Körs på main queue
        dispatch_async(dispatch_get_main_queue()) {
            
        //SKALL IMPLEMENTERAS. KOLLA CHATTAPP HUR DET ÄR TÄNKT TYP
        }
    }
    
    // MCSessionDelegate protokollet kräver att metoderna nedan implementeras.
    
    //Metoden kallas när en peer börjar sända data till oss
    func session(session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                                                   fromPeer peerID: MCPeerID, withProgress progress: NSProgress)  {
    }
    
    //Denna metod kallas när en överföringen av en fil från en avsändare till en annan är slutförd.
    
    func session(session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                                                    fromPeer peerID: MCPeerID,
                                                             atURL localURL: NSURL, withError error: NSError?)  {
    }
    
    //Denna metod kallas när en användare upprättar en stream med oss
    func session(session: MCSession, didReceiveStream stream: NSInputStream,
                 withName streamName: String, fromPeer peerID: MCPeerID)  {
    }
    
    //Denna metod kallas på när en användare ändrar sin status, exempelvis när denne blir offline.
    func session(session: MCSession, peer peerID: MCPeerID,
                 didChangeState state: MCSessionState)  {
        
    }
    
    
    //Default metod som finns när klassen skapas.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
