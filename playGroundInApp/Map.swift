import UIKit
import Foundation
import SpriteKit

public class Map:SKNode{
 
    public let ROWS : Int = 26
    public let COLS : Int = 37
    public let matrixSquareSize = 36
    public let height : Int
    public let width : Int
    public var mainPlayer: Player!
    public var listOfCameras: Array<Camera> = Array.init()
    public var listOfDoors: Array<Door> = Array.init()
    public var mapAlarms:Array<Alarm> = Array.init()
    public var mapCops:Array<Guard> = Array.init()
    public var lastTerminalInteracted:Terminal!
    
    public var matrixOfMutableObjects: Array<Array<SKNode>>
    
    public init(sceneWidth: Int, sceneHeight:Int){
        
        matrixOfMutableObjects = Array<Array<SKNode>>()
        
        for _ in 0..<ROWS {
            matrixOfMutableObjects.append(Array(repeating:Ground.getInstance, count:COLS))
        }
        
        height = sceneHeight
        width = sceneWidth
        
        super.init()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func touchDetected(touchLocation: CGPoint){
        
        let xPos = ROWS-1-Int(touchLocation.y/36)
        let yPos = Int(touchLocation.x/36)
        
        if xPos < 0 || xPos >= ROWS || yPos < 0 || yPos >= COLS {
            return
        }
        
        if (matrixOfMutableObjects[xPos][yPos] is Key) {
            mainPlayer.pickUpTheKey()
        }else if (matrixOfMutableObjects[xPos][yPos] is Door) {
            mainPlayer.openDoor()
        }else if (matrixOfMutableObjects[xPos][yPos] is Terminal) {
            let terminal = matrixOfMutableObjects[xPos][yPos] as! Terminal
            terminal.playerInteraction(mainPlayer:mainPlayer)
            lastTerminalInteracted = terminal
        }else if{
            // Restart button?
        }
    }
    
    public func turnAlarmOn(){
        
        for alarm in mapAlarms{
            alarm.playAlarmOn()
        }
        
        for mapCop in mapCops{
            mapCop.setAlarmOn()
        }
        
        
    }
    
    public func addPlayerToMap(mainPlayer:Player, x:Int, y:Int){
        
        let playerLight = SKLightNode()
        playerLight.falloff = 2
        
        mainPlayer.addChild(playerLight)
        matrixOfMutableObjects[x][y] = mainPlayer
        self.mainPlayer = mainPlayer
        
    }
    
    public func moveSprite(mainSprite:SKSpriteNode, xActualPosition:Int, yActualPosition:Int, xDestinePosition:Int, yDestinePosition:Int){
        
        matrixOfMutableObjects[xActualPosition][yActualPosition] = Ground.getInstance
        matrixOfMutableObjects[xDestinePosition][yDestinePosition] = mainSprite
        
    }
    
    public func isPossibleToMoveFor(x:Int, y:Int) -> Bool {
        
        if(x < 0 || x > ROWS || y < 0 || y > COLS){
            return false;
        } else if (!(matrixOfMutableObjects[x][y] is Ground)){
            return false;
        }
        
        return true;
        
    }
    
    public func fillTheMapWithMutableObjects() {
        
        // Start building the walls in matrix
        
        for i in 0..<ROWS{
            matrixOfMutableObjects[i][0] = Wall(xPosition: i, yPosition: 0, orientation:enumOrientation.left, wMap: self)
            matrixOfMutableObjects[i][13] = Wall(xPosition: i, yPosition: 13, orientation:enumOrientation.left, wMap: self)
            matrixOfMutableObjects[i][18] = Wall(xPosition: i, yPosition: 18, orientation:enumOrientation.left, wMap: self)
            matrixOfMutableObjects[i][28] = Wall(xPosition: i, yPosition: 28, orientation:enumOrientation.right, wMap: self)
            matrixOfMutableObjects[i][COLS-1] = Wall(xPosition: i, yPosition: COLS-1, orientation:enumOrientation.right, wMap: self)
            
            if 11...18 ~= i{
                matrixOfMutableObjects[i][6] = Wall(xPosition: i, yPosition: 6, orientation:enumOrientation.right, wMap: self)
            }
        }
        
        for i in 0..<COLS{
            matrixOfMutableObjects[0][i] = Wall(xPosition: 0, yPosition: i, orientation:enumOrientation.up, wMap: self)
            if i<=12 {
                matrixOfMutableObjects[10][i] = Wall(xPosition: 10, yPosition: i, orientation:enumOrientation.up, wMap: self)
            }
            if 18...28 ~= i {
                matrixOfMutableObjects[8][i] = Wall(xPosition: 8, yPosition: i, orientation:enumOrientation.up, wMap: self)
                matrixOfMutableObjects[15][i] = Wall(xPosition: 15, yPosition: i, orientation:enumOrientation.up, wMap: self)
            }
            if 7...12 ~= i{
                matrixOfMutableObjects[18][i] = Wall(xPosition: 18, yPosition: i, orientation:enumOrientation.up, wMap: self)
            }
            matrixOfMutableObjects[18][13] = Wall(xPosition: 18, yPosition: 13, orientation:enumOrientation.left, wMap: self)
            
            matrixOfMutableObjects[ROWS-1][i] = Wall(xPosition: ROWS-1, yPosition: i, orientation:enumOrientation.up, wMap: self)
            
        }
        
        // Then we build the doors
        
        
        
        let firstDoor = Door(nameOfDoor: "firstDoor", xPosition: 3, yPosition: 28, orientation:enumOrientation.right, dMap: self)
        matrixOfMutableObjects[3][28] = firstDoor
        listOfDoors.append(firstDoor)
        
        let secondDoor = Door(nameOfDoor: "secondDoor", xPosition: 22, yPosition: 28, orientation:enumOrientation.right, dMap: self)
        matrixOfMutableObjects[22][28] = secondDoor
        listOfDoors.append(secondDoor)
        
        let thirdDoor = Door(nameOfDoor: "thirdDoor", xPosition: 15, yPosition: 26, orientation:enumOrientation.up, dMap: self)
        matrixOfMutableObjects[15][26] = thirdDoor
        listOfDoors.append(thirdDoor)
        
        let fourthDoor = Door(nameOfDoor: "fourthDoor", xPosition: 10, yPosition: 18, orientation:enumOrientation.left, dMap: self)
        matrixOfMutableObjects[10][18] = fourthDoor
        listOfDoors.append(fourthDoor)
        
        let fifthDoor = Door(nameOfDoor: "fifthDoor", xPosition: 16, yPosition: 13, orientation:enumOrientation.left, dMap: self)
        matrixOfMutableObjects[16][13] = fifthDoor
        listOfDoors.append(fifthDoor)
        
        let sixthDoor = Door(nameOfDoor: "sixthDoor", xPosition: 10, yPosition: 3, orientation:enumOrientation.up, dMap: self)
        matrixOfMutableObjects[10][3] = sixthDoor
        listOfDoors.append(sixthDoor)
        
        let seventhDoor = Door(nameOfDoor: "seventhDoor", xPosition: 18, yPosition: 11, orientation:enumOrientation.up, dMap: self)
        matrixOfMutableObjects[18][11] = seventhDoor
        listOfDoors.append(seventhDoor)
        
        // Now we build the Terminal and spare through the map!
        let firstTerminal = Terminal(nameOfTerminal: "firstTerminal", xPosition:11, yPosition:12, orientation:enumOrientation.down, tMap: self)
        matrixOfMutableObjects[11][12] = firstTerminal
        
        let secondTerminal = Terminal(nameOfTerminal: "secondTerminal", xPosition:22, yPosition:35, orientation:enumOrientation.left, tMap: self)
        matrixOfMutableObjects[22][35] = secondTerminal
        
        let thirdTerminal = Terminal(nameOfTerminal: "thirdTerminal", xPosition:9, yPosition:21, orientation:enumOrientation.down, tMap: self)
        matrixOfMutableObjects[9][21] = thirdTerminal
        
        let fourthTerminal = Terminal(nameOfTerminal: "fourthTerminal", xPosition:17, yPosition:19, orientation:enumOrientation.right, tMap: self)
        matrixOfMutableObjects[17][19] = fourthTerminal
        
        let fifthTerminal = Terminal(nameOfTerminal: "fifthTerminal", xPosition:1, yPosition:2, orientation:enumOrientation.down, tMap: self)
        matrixOfMutableObjects[1][2] = fifthTerminal
        
        // Let's put a key
        
        matrixOfMutableObjects[4][26] = Key(nameOfKey: "Key", xPosition: 4, yPosition: 26, pMap: self)
        
        // Adding some alarms
        
        let firstMapAlarm = Alarm(xPosition: 1, yPosition: 15, orientation:enumOrientation.down, aMap: self)
        matrixOfMutableObjects[1][15] = firstMapAlarm
        mapAlarms.append(firstMapAlarm)
        
        let secondMapAlarm = Alarm(xPosition: 24, yPosition: 12, orientation:enumOrientation.up, aMap: self)
        matrixOfMutableObjects[24][12] = secondMapAlarm
        mapAlarms.append(secondMapAlarm)
        
        // Do not forget the Guards!
        
        let firstCop = Guard(nameOfGuard: "Guard Jonny", xPosition: 24, yPosition: 15, verticalMovement: true, alarm:firstMapAlarm, gMap: self)
        matrixOfMutableObjects[24][15] = firstCop
        mapCops.append(firstCop)
        
        let secondCop = Guard(nameOfGuard: "Guard Peter", xPosition: 19, yPosition: 1, verticalMovement:false, alarm:secondMapAlarm, gMap: self)
        matrixOfMutableObjects[19][1] = secondCop
        mapCops.append(secondCop)
        
        // Torches are good for suspense
        let firstTorch = Torch(xPosition: 1, yPosition: 19, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[1][19] = firstTorch
        
        let secondTorch = Torch(xPosition: 1, yPosition: 27, orientation: enumOrientation.upright, tMap: self)
        matrixOfMutableObjects[1][27] = secondTorch
        
        let thirdTorch = Torch(xPosition: 7, yPosition: 19, orientation: enumOrientation.downleft, tMap: self)
        matrixOfMutableObjects[7][19] = thirdTorch
        
        let fourthTorch = Torch(xPosition: 7, yPosition: 27, orientation: enumOrientation.downright, tMap: self)
        matrixOfMutableObjects[7][27] = fourthTorch
        
        
        // Just a few cameras to ensure the security and...
        
        let firstCamera = Camera(nameOfCamera: "firstCamera", xPosition: 9, yPosition: 27, orientation:enumOrientation.up, cMap: self)
        matrixOfMutableObjects[9][27] = firstCamera
        listOfCameras.append(firstCamera)
        
        let secondCamera = Camera(nameOfCamera: "secondCamera", xPosition: 14, yPosition: 19, orientation:enumOrientation.down, cMap: self)
        matrixOfMutableObjects[14][19] = secondCamera
        listOfCameras.append(secondCamera)
        
        let thirdCamera = Camera(nameOfCamera: "firstCamera", xPosition: 24, yPosition: 1, orientation:enumOrientation.down, cMap: self)
        matrixOfMutableObjects[24][1] = thirdCamera
        listOfCameras.append(thirdCamera)
        
        let fourthCamera = Camera(nameOfCamera: "fourthCamera", xPosition: 9, yPosition: 1, orientation:enumOrientation.down, cMap: self)
        matrixOfMutableObjects[9][1] = fourthCamera
        listOfCameras.append(fourthCamera)
        
        let fifthCamera = Camera(nameOfCamera: "fifthCamera", xPosition: 1, yPosition: 12, orientation:enumOrientation.up, cMap: self)
        matrixOfMutableObjects[1][12] = fifthCamera
        listOfCameras.append(fifthCamera)
        
        
        
        // Voala!!
        
        loadMapSprites()
        
    }
    
    public func loadMapSprites(){
        
        for i in 0..<ROWS {
            for j in 0..<COLS {
                if matrixOfMutableObjects[i][j] == Ground.getInstance {
                    let ground = SKSpriteNode(imageNamed: "ground")
                    ground.position = CGPoint(x: (((width%matrixSquareSize)/2)+(matrixSquareSize*j)-1+18), y: (((height%matrixSquareSize)/2)+(matrixSquareSize*(ROWS-1-i))+18))
                    self.addChild(ground)
                }else if matrixOfMutableObjects[i][j] is Terminal {
                    let terminal = matrixOfMutableObjects[i][j] as! Terminal
                    self.addChild(terminal)
                    self.addChild(terminal.terminalMonitor)
                }else{
                    self.addChild(matrixOfMutableObjects[i][j])
                }
            }
        }
        
        
    }
    
    public func removeKeyFromMap(playerKey : Key){
        
        matrixOfMutableObjects[playerKey.xPositionMatrix][playerKey.yPositionMatrix] = Ground.getInstance
        
    }
    
    public func thereIsAnObjectAt(x:Int, y:Int) -> Bool{ // Exclusive method for camera!!
        
        if x < 0 || x > ROWS || y < 0 || y > COLS {
            return false
        }else if matrixOfMutableObjects[x][y] is Wall || matrixOfMutableObjects[x][y] is Door {
            return false
        }
        return true
        
    }
    
    public func thereIsAPlayerInThePositions(arrayOfPositions: Array<(Int,Int)>) -> Player?{
        
        for position in arrayOfPositions {
            if matrixOfMutableObjects[position.0][position.1] is Player{
                return (matrixOfMutableObjects[position.0][position.1] as! Player)
            }
        }
        
        return nil
        
    }
    
    public func gameOver(){ 
        
        self.isPaused = true
        
        let gameOverLabel = SKLabelNode.init(text: "Game Over")
        gameOverLabel.fontSize = 50
        gameOverLabel.fontName = "Menlo"
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: width/2, y: height/2)
        
        // Restart Icon
        let restartIcon = SKSpriteNode(texture: SKTexture(imageNamed: "restart") , color: UIColor.clear, size: CGSize(width: 48, height: 48))
        restartIcon.position = CGPoint(x: self.width - 60, y: self.height - 60)
        restartIcon.name = "restartButton"
        
        self.addChild(gameOverLabel)
        self.addChild(restartIcon)
        
        
    }
    
    public func openDoorNearPlayer(theDoor:Door){
        
        if theDoor.isOpen == false {
            matrixOfMutableObjects[theDoor.xPositionMatrix][theDoor.yPositionMatrix] = Ground.getInstance
            theDoor.openDoor()
        }
        
    }
    
    public func openDoor(theDoor:Door){
        
        theDoor.openDoor()
        
    }
    
    public func turnOffCamera(cameraToTurnOff:Camera){
        
        for camera in listOfCameras{
            if camera == cameraToTurnOff {
                camera.turnCameraOff()
            }
        }
        
    }
    
    // Juntar todos abaixo em um (?)
    
    public func thereIsAKeyNearPlayer(mainPlayer: Player) -> Key? {
        
        if matrixOfMutableObjects[mainPlayer.xPositionMatrix+1][mainPlayer.yPositionMatrix] is Key {
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix+1][mainPlayer.yPositionMatrix] as? Key
        } else if matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix+1] is Key{
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix+1] as? Key
        }else if matrixOfMutableObjects[mainPlayer.xPositionMatrix-1][mainPlayer.yPositionMatrix] is Key{
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix-1][mainPlayer.yPositionMatrix] as? Key
        }else if matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix-1] is Key{
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix-1] as? Key
        }
        return nil
        
    }
    
    public func thereIsADoorNearPlayer(mainPlayer: Player) -> Door?{
        
        if matrixOfMutableObjects[mainPlayer.xPositionMatrix+1][mainPlayer.yPositionMatrix] is Door {
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix+1][mainPlayer.yPositionMatrix] as? Door
        } else if matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix+1] is Door{
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix+1] as? Door
        }else if matrixOfMutableObjects[mainPlayer.xPositionMatrix-1][mainPlayer.yPositionMatrix] is Door{
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix-1][mainPlayer.yPositionMatrix] as? Door
        }else if matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix-1] is Door{
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix-1] as? Door
        }
        
        return nil
        
    }
    
    public func thereIsATerminalNearPlayer(mainPlayer: Player) -> Terminal?{
        
        if matrixOfMutableObjects[mainPlayer.xPositionMatrix+1][mainPlayer.yPositionMatrix] is Terminal {
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix+1][mainPlayer.yPositionMatrix] as? Terminal
        } else if matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix+1] is Terminal{
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix+1] as? Terminal
        }else if matrixOfMutableObjects[mainPlayer.xPositionMatrix-1][mainPlayer.yPositionMatrix] is Terminal{
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix-1][mainPlayer.yPositionMatrix] as? Terminal
        }else if matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix-1] is Terminal{
            return matrixOfMutableObjects[mainPlayer.xPositionMatrix][mainPlayer.yPositionMatrix-1] as? Terminal
        }
        
        return nil
        
    }
    
}
