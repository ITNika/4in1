//
//  ViewController.swift
//  Multipeer Connectivity
//
//  Created by Emina Hromic on 2016-02-24.
//  Copyright © 2016 Emina Hromic. All rights reserved.
//

import UIKit
import MultipeerConnectivity

/**
 Detta är en klass som skapar en chatt-konversation. Applikationen använder sig av ramverket Multipeer Connectivity Framework, som innebär att samtliga enheter som är anslutna till samma WiFi eller Bluetooth kan ha en chatt-konversation med varandra. Dock måste användaren bjuda in andra användare på nätverket, och sedan måste denna inbjudan accepteras. Därefter kan en chatt-konversation starta mellan användarna. Samtliga meddelanden visas för samtliga användare.

*/

//Protokollet MCSessionDelegate ser till att delegate notifieras när anslutna enheter ändras eller när data mottas.

//Protokollet MCBrowserViewControllerDelegate hanterar events relaterade till MCBrowserViewController

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate  {
    
    let serviceType = "LCOC-Chat"
    
    
    //En controller som används för att scanna och bjuda in andra peers manuellt. MCNearbyServiceBrowserDelegate används när vilken peer som helst ska bjudas in automatiskt.
    var browser : MCBrowserViewController!
    
    //Ser till att sessioner ptivata genom notifiera och fråga användaren att bekräfta inkomna inbjudningar.
    var assistant : MCAdvertiserAssistant!
    
    //the object holding the sessions once it has been negotiated
    var session : MCSession!
    
    //representerar peer ID:t för session
    var peerID: MCPeerID!
    
    //Variabel för själva chatt-fönstret
    @IBOutlet weak var chatView: UILabel!
    
    //Variable (Outlet) för meddelande-fältet (textfield)
    @IBOutlet weak var messageField: UITextField!
    
    
    //Laddar själva viewen
    
    //the code initializes all the Multicast Peer objects before telling the advertiser to start advertising its availability
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
    
    
    //Metoden skickar data - en string från testfältet
    //Visar meddelandet på samma enhet som det skickades ifrån, samt skickar det till samtliga anslutna enheter
        @IBAction func sendChat(sender: AnyObject) {
        
        
        let msg = self.messageField.text!.dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)
        
        
        var error : NSError?
        
        //Do-try-catch måste användas eftersom metoden i try-satsen kan kasta en exception. Detta bör dock inte ske.
        do{
            try self.session.sendData(msg!, toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Unreliable)
            
        }catch var error1 as NSError {
            error = error1
            NSLog("%@", "\(error)")
        }
        
        
        //Updaterar chatt-fönstret
        self.updateChat(self.messageField.text!, fromPeer: self.peerID)
        
        self.messageField.text = ""
    }
    
    //Denna metod lägger till själva meddelandet på chatt-fönstret
    func updateChat(text : String, fromPeer peerID: MCPeerID) {
        
        // Om peerID tillhör den lokala enheten visas det att meddelandet har skickats från "Me", i annat fall visas avsändarens namn.
        
        var name : String
        
        switch peerID {
        case self.peerID:
            name = "Me"
        default:
            name = peerID.displayName
        }
        
        // Lägger till sändarens namn till meddelandet och visar det på chatt-fönstret
        let message = "\(name): \(text)\n"
        self.chatView.text = self.chatView.text! + message
        
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
    
    //Denna metod kallas när sessionen mottar något data. Den lägger till den nya datan till textfältet och visar den mottagna texten i textfältet.
    func session(session: MCSession, didReceiveData data: NSData,
        fromPeer peerID: MCPeerID)  {
            
            // Körs på main queue
            dispatch_async(dispatch_get_main_queue()) {
                
                
                //Var NSString från början men då funker det inte
                let msg = String(data: data, encoding: NSUTF8StringEncoding)
                
                self.updateChat(msg!, fromPeer: peerID)
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
    // Dispose of any resources that can be recreated.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
