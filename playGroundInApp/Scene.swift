import UIKit
import Foundation
import SpriteKit

public class Scene:SKScene{
    
    
    public var height : Int
    public var width : Int
    public var mainPlayer : Player!
    public var myMap : Map!
    public var nativeSize = CGSize.zero
    
    public override init(size:CGSize) {
        
        height = Int(size.height)
        width = Int(size.width)
        
        super.init(size: size)
        
        let backgroundTexture = SKTexture(imageNamed: "background")
        
        let background = SKSpriteNode(texture: backgroundTexture, color: SKColor.clear, size: self.size)
        
        background.zPosition = -1;
        
        background.anchorPoint = self.anchorPoint
        
        self.addChild(background)
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        
        myMap = Map(sceneWidth: width, sceneHeight: height)
//
        // Main Player
        mainPlayer = Player(nameOfPlayer: "Girotto", xPosition: 3, yPosition: 20, pMap: myMap)
//
        myMap.addPlayerToMap(mainPlayer: mainPlayer, x: 3, y: 20)
        
        myMap.fillTheMapWithMutableObjects()
//
        createCamera()
        setCameraConstraint()
////
        self.addChild(myMap)
//
        addSwipes()
        
        super.didMove(to: view)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        let location = touch.location(in: self)
        
        myMap.touchDetected(touchLocation: location)
        
    }

    public func listAllCameras(){
        
        myMap.lastTerminalInteracted.listAllCameras()
        
    }
    
    public func listAllDoors(){
        
        myMap.lastTerminalInteracted.listAllDoors()
        
    }
    
    public func addSwipes(){
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
    }
    
    public func createCamera() {
        
        nativeSize = size
        
        let camera = SKCameraNode()
        self.camera = camera
        addChild(camera)
        
        updateCameraScale()
    }
    
    public func centerCameraOnPoint(point: CGPoint) {
        if let camera = camera {
            camera.position = point
        }
    }
    
    public func updateCameraScale() {
        if let camera = camera {
            camera.setScale(0.4)
            //camera.setScale(2)
        }
    }
    
    public func setCameraConstraint(){
        guard let camera = camera else { return }
        
        let zeroRange = SKRange(constantValue: 0.0)
        let playerLocationConstraint = SKConstraint.distance(zeroRange, to: mainPlayer)
        
        camera.constraints = [playerLocationConstraint]
    }
    
    public func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                mainPlayer.moveRight()
                if let mapTerminal = myMap.lastTerminalInteracted {
                    mapTerminal.removeTerminalMonitor()
                }
                break
            case UISwipeGestureRecognizerDirection.down:
                mainPlayer.moveDown()
                if let mapTerminal = myMap.lastTerminalInteracted {
                    mapTerminal.removeTerminalMonitor()
                }
                break
            case UISwipeGestureRecognizerDirection.left:
                mainPlayer.moveLeft()
                if let mapTerminal = myMap.lastTerminalInteracted {
                    mapTerminal.removeTerminalMonitor()
                }
                break
            case UISwipeGestureRecognizerDirection.up:
                mainPlayer.moveUp()
                if let mapTerminal = myMap.lastTerminalInteracted {
                    mapTerminal.removeTerminalMonitor()
                }
                break
            default:
                break
            }
        }
    }
}
