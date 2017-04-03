import UIKit
import Foundation
import SpriteKit
import PlaygroundSupport

public class GameViewController: UIViewController{
    
    public var myScene = Scene(size: CGSize(width: 1332, height: 936))
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //: Playground - noun: a place where people can play
        
        let view = self.view as! SKView
        
        myScene.scaleMode = .aspectFill
        
        view.presentScene(myScene)
        
    }
    
    public override func loadView(){
        
        self.view = SKView(frame: CGRect(x: 0, y:0, width : 320, height:480))
        
        
        
    }
    
}

extension GameViewController : PlaygroundLiveViewMessageHandler {
    
    public func liveViewMessageConnectionOpened() {
        // We don't need to do anything in particular when the connection opens.
    }
    
    public func liveViewMessageConnectionClosed() {
        // We don't need to do anything in particular when the connection closes.
    }
    
    public func receive(_ message: PlaygroundValue) {
        
        switch message {
        case let .string(method):
            if method == "openDoors" {
                myScene.openNearestDoors()
            }else if method == "turnOffNearestCameras"{
                myScene.turnOffNearestCameras()
            }else if method == "turnAlarmsOn"{
                myScene.turnAlarmsOn()
            }
        default: break
        }
    }
}
