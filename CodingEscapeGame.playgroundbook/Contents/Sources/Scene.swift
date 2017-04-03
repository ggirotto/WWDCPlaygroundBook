import UIKit
import Foundation
import SpriteKit
import AVFoundation


public class Scene:SKScene{
    
    
    public var height : Int
    public var width : Int
    public var mainPlayer : Player!
    public var myMap : Map!
    public var isGameOver: Bool
    public var nativeSize = CGSize.zero
    public var audioPlayer = AVAudioPlayer()
    
    public override init(size:CGSize) {
        
        height = Int(size.height)
        width = Int(size.width)
        
        isGameOver = false
        
        super.init(size: size)
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        let texture = SKTexture(imageNamed: "background")
        let background = SKSpriteNode(texture: texture, color: UIColor.clear, size:texture.size())
        
        background.zPosition = -1;
        self.backgroundColor = .black
        
        background.anchorPoint = self.anchorPoint
        
        self.addChild(background)
        
        myMap = Map(sceneWidth: width, sceneHeight: height)
        // 3 20
        // Main Player x:3 y:20
        mainPlayer = Player(xPosition: 3, yPosition: 20, pMap: myMap)
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
        
        playSound()
    }
    
    public func playSound() {
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "background", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = 0.4
            audioPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func restartGame(){
        
        self.removeAllChildren()
        
        didMove(to: self.view!)
        
        
    }
    
    public func gameOver(){
        
        self.isGameOver = true
        
        let gameOverLabel = SKLabelNode.init(text: "Game Over")
        gameOverLabel.fontSize = 90
        gameOverLabel.fontName = "Menlo"
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.zPosition = 1
        
        camera?.addChild(gameOverLabel)
        

        let restartIcon = SKSpriteNode(imageNamed:"restart")
        restartIcon.size = CGSize(width:CGFloat(130), height:CGFloat(130))
        restartIcon.position = CGPoint(x: 0, y: -restartIcon.size.height)
        restartIcon.name = "restartButton"
        restartIcon.zPosition = 1
        
        
        camera?.addChild(restartIcon)
        
    }
    
    public func finishGame(){
        
        self.isGameOver = true
        
        let gameOverLabel = SKLabelNode.init(text: "You Won!")
        gameOverLabel.fontSize = 90
        gameOverLabel.fontName = "Menlo"
        gameOverLabel.fontColor = SKColor.green
        gameOverLabel.zPosition = 1
        
        camera?.addChild(gameOverLabel)
        

        let restartIcon = SKSpriteNode(imageNamed:"restart")
        restartIcon.size = CGSize(width:CGFloat(130), height:CGFloat(130))
        restartIcon.position = CGPoint(x: 0, y: -restartIcon.size.height)
        restartIcon.name = "restartButton"
        restartIcon.zPosition = 1
        
        
        camera?.addChild(restartIcon)
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        
        let location = touch.location(in: self)
        
        if isGameOver {
            
            let touchNode = self.nodes(at: location)
            
            let restartNode = self.camera!.childNode(withName: "restartButton")
            
            
            if(touchNode.first?.name == restartNode?.name){
                isGameOver = false
                restartGame()
            }
            
        }else{
            myMap.touchDetected(touchLocation: location)
        }
        
    }

    public func openNearestDoors(){
        
        if let terminal = myMap.thereIsATerminalNearPlayer(mainPlayer:mainPlayer){
            terminal.openNearestDoors()
        }else{
            let messageToPlayer = SKLabelNode.init(text: "Approach the Terminal to use the commands!")
            
            mainPlayer.sendMessagesToPlayer(messagesToSend: [messageToPlayer])
        }
        
        
        
    }
    
    public func turnOffNearestCameras(){
        
        if let terminal = myMap.thereIsATerminalNearPlayer(mainPlayer:mainPlayer){
            terminal.turnOffNearestCameras()
        }else{
            let messageToPlayer = SKLabelNode.init(text: "Approach the Terminal to use the commands")
            
            mainPlayer.sendMessagesToPlayer(messagesToSend: [messageToPlayer])
        }
        
    }
    
    public func turnAlarmsOn(){
        
        if let terminal = myMap.thereIsATerminalNearPlayer(mainPlayer:mainPlayer){
            terminal.turnAlarmsOn()
        }else{
            let messageToPlayer = SKLabelNode.init(text: "Approach the Terminal to use the commands")
            
            mainPlayer.sendMessagesToPlayer(messagesToSend: [messageToPlayer])
        }
        
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
            camera.setScale(0.5)
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
