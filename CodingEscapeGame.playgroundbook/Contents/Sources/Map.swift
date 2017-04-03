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
    
    public var matrixOfMutableObjects: Array<Array<SKSpriteNode>>
    
    public init(sceneWidth: Int, sceneHeight:Int){
        
        matrixOfMutableObjects = Array<Array<SKSpriteNode>>()
        
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
        
        
        
        let firstDoor = Door(xPosition: 3, yPosition: 28, orientation:enumOrientation.right, onlyKey:true, dMap: self)
        matrixOfMutableObjects[3][28] = firstDoor
        listOfDoors.append(firstDoor)
        
        let secondDoor = Door(xPosition: 22, yPosition: 28, orientation:enumOrientation.right, onlyKey:false, dMap: self)
        matrixOfMutableObjects[22][28] = secondDoor
        listOfDoors.append(secondDoor)
        
        let thirdDoor = Door(xPosition: 15, yPosition: 26, orientation:enumOrientation.up, onlyKey:false, dMap: self)
        matrixOfMutableObjects[15][26] = thirdDoor
        listOfDoors.append(thirdDoor)
        
        let fourthDoor = Door(xPosition: 10, yPosition: 18, orientation:enumOrientation.left, onlyKey:false, dMap: self)
        matrixOfMutableObjects[10][18] = fourthDoor
        listOfDoors.append(fourthDoor)
        
        let fifthDoor = Door(xPosition: 16, yPosition: 13, orientation:enumOrientation.left, onlyKey:true, dMap: self)
        matrixOfMutableObjects[16][13] = fifthDoor
        listOfDoors.append(fifthDoor)
        
        let sixthDoor = Door(xPosition: 10, yPosition: 3, orientation:enumOrientation.up, onlyKey:true, dMap: self)
        matrixOfMutableObjects[10][3] = sixthDoor
        listOfDoors.append(sixthDoor)
        
        let seventhDoor = Door(xPosition: 18, yPosition: 11, orientation:enumOrientation.up, onlyKey:false, dMap: self)
        matrixOfMutableObjects[18][11] = seventhDoor
        listOfDoors.append(seventhDoor)
        
        // Just a few cameras to ensure the the security
        
        let firstCamera = Camera(xPosition: 9, yPosition: 27, orientation:enumOrientation.up, cMap: self)
        matrixOfMutableObjects[9][27] = firstCamera
        listOfCameras.append(firstCamera)
        
        let secondCamera = Camera(xPosition: 14, yPosition: 19, orientation:enumOrientation.down, cMap: self)
        matrixOfMutableObjects[14][19] = secondCamera
        listOfCameras.append(secondCamera)
        
        let thirdCamera = Camera(xPosition: 19, yPosition: 12, orientation:enumOrientation.up, cMap: self)
        matrixOfMutableObjects[19][12] = thirdCamera
        listOfCameras.append(thirdCamera)
        
        let fourthCamera = Camera(xPosition: 9, yPosition: 1, orientation:enumOrientation.down, cMap: self)
        matrixOfMutableObjects[9][1] = fourthCamera
        listOfCameras.append(fourthCamera)
        
        let fifthCamera = Camera(xPosition: 1, yPosition: 12, orientation:enumOrientation.up, cMap: self)
        matrixOfMutableObjects[1][12] = fifthCamera
        listOfCameras.append(fifthCamera)
        
        // Now we build the Terminals through the map
        
        var camerasList = Array<Camera>.init()
        
        let firstTerminal = Terminal(xPosition:22, yPosition:35, finish:false, cameras:camerasList, tMap: self)
        matrixOfMutableObjects[22][35] = firstTerminal
        firstTerminal.welcomMessageAndlistPossibleCommands()
        
        camerasList.append(thirdCamera)
        let secondTerminal = Terminal(xPosition:11, yPosition:12, finish:false, cameras:camerasList, tMap: self)
        matrixOfMutableObjects[11][12] = secondTerminal
        
        camerasList.removeAll()
        
        let thirdTerminal = Terminal(xPosition:9, yPosition:21, finish:false, cameras:camerasList, tMap: self)
        matrixOfMutableObjects[9][21] = thirdTerminal
        
        camerasList.append(firstCamera)
        camerasList.append(secondCamera)
        let fourthTerminal = Terminal(xPosition:17, yPosition:19, finish:false, cameras:camerasList, tMap: self)
        matrixOfMutableObjects[17][19] = fourthTerminal
        
        camerasList.removeAll()
        
        camerasList.append(fourthCamera)
        camerasList.append(fifthCamera)
        let fifthTerminal = Terminal(xPosition:11, yPosition:5, finish:false, cameras:camerasList, tMap: self)
        matrixOfMutableObjects[11][5] = fifthTerminal
        
        camerasList.removeAll()
        
        let finishTerminal = Terminal(xPosition:5, yPosition:6, finish:true, cameras:camerasList, tMap: self)
        matrixOfMutableObjects[5][6] = finishTerminal
        
        // Let's put the keys
        
        matrixOfMutableObjects[4][26] = Key(xPosition: 4, yPosition: 26, pMap: self)
        matrixOfMutableObjects[15][14] = Key(xPosition: 15, yPosition: 14, pMap: self)
        matrixOfMutableObjects[11][4] = Key(xPosition: 11, yPosition: 4, pMap: self)
        
        // Adding some alarms
        
        let firstMapAlarm = Alarm(xPosition: 1, yPosition: 15, orientation:enumOrientation.down, aMap: self)
        matrixOfMutableObjects[1][15] = firstMapAlarm
        mapAlarms.append(firstMapAlarm)
        
        let secondMapAlarm = Alarm(xPosition: 24, yPosition: 12, orientation:enumOrientation.up, aMap: self)
        matrixOfMutableObjects[24][12] = secondMapAlarm
        mapAlarms.append(secondMapAlarm)
        
        // Do not forget the Guards!
        
        let firstCop = Guard(xPosition: 2, yPosition: 15, verticalMovement: true, alarm:firstMapAlarm, gMap: self)
        matrixOfMutableObjects[2][15] = firstCop
        mapCops.append(firstCop)
        
        let secondCop = Guard(xPosition: 20, yPosition: 2, verticalMovement:false, alarm:secondMapAlarm, gMap: self)
        matrixOfMutableObjects[20][2] = secondCop
        mapCops.append(secondCop)
        
        // Torches are good for suspense
        matrixOfMutableObjects[1][19] = Torch(xPosition: 1, yPosition: 19, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[1][27] = Torch(xPosition: 1, yPosition: 27, orientation: enumOrientation.upright, tMap: self)
        matrixOfMutableObjects[7][19] = Torch(xPosition: 7, yPosition: 19, orientation: enumOrientation.downleft, tMap: self)
        matrixOfMutableObjects[7][27] = Torch(xPosition: 7, yPosition: 27, orientation: enumOrientation.downright, tMap: self)
        
        matrixOfMutableObjects[1][29] = Torch(xPosition: 1, yPosition: 29, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[1][35] = Torch(xPosition: 1, yPosition: 35, orientation: enumOrientation.upright, tMap: self)
        matrixOfMutableObjects[8][29] = Torch(xPosition: 8, yPosition: 29, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[8][35] = Torch(xPosition: 8, yPosition: 35, orientation: enumOrientation.upright, tMap: self)
//
        matrixOfMutableObjects[15][29] = Torch(xPosition: 15, yPosition: 29, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[15][35] = Torch(xPosition: 15, yPosition: 35, orientation: enumOrientation.upright, tMap: self)
        matrixOfMutableObjects[24][29] = Torch(xPosition: 24, yPosition: 29, orientation: enumOrientation.downleft, tMap: self)
        matrixOfMutableObjects[24][35] = Torch(xPosition: 24, yPosition: 35, orientation: enumOrientation.downright, tMap: self)

        matrixOfMutableObjects[16][19] = Torch(xPosition: 16, yPosition: 19, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[16][27] = Torch(xPosition: 16, yPosition: 27, orientation: enumOrientation.upright, tMap: self)
        matrixOfMutableObjects[24][19] = Torch(xPosition: 24, yPosition: 19, orientation: enumOrientation.downleft, tMap: self)
        matrixOfMutableObjects[24][27] = Torch(xPosition: 24, yPosition: 27, orientation: enumOrientation.downright, tMap: self)
        
        matrixOfMutableObjects[9][19] = Torch(xPosition: 9, yPosition: 19, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[9][26] = Torch(xPosition: 9, yPosition: 26, orientation: enumOrientation.upright, tMap: self)
        matrixOfMutableObjects[13][19] = Torch(xPosition: 13, yPosition: 19, orientation: enumOrientation.downleft, tMap: self)
        matrixOfMutableObjects[14][27] = Torch(xPosition: 14, yPosition: 27, orientation: enumOrientation.downright, tMap: self)
        
        matrixOfMutableObjects[1][14] = Torch(xPosition: 1, yPosition: 14, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[7][14] = Torch(xPosition: 7, yPosition: 14, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[13][14] = Torch(xPosition: 13, yPosition: 14, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[19][14] = Torch(xPosition: 19, yPosition: 14, orientation: enumOrientation.downleft, tMap: self)
        matrixOfMutableObjects[24][14] = Torch(xPosition: 24, yPosition: 14, orientation: enumOrientation.downleft, tMap: self)
        
        matrixOfMutableObjects[1][17] = Torch(xPosition: 1, yPosition: 17, orientation: enumOrientation.upright, tMap: self)
        matrixOfMutableObjects[7][17] = Torch(xPosition: 7, yPosition: 17, orientation: enumOrientation.upright, tMap: self)
        matrixOfMutableObjects[13][17] = Torch(xPosition: 13, yPosition: 17, orientation: enumOrientation.upright, tMap: self)
        matrixOfMutableObjects[19][17] = Torch(xPosition: 19, yPosition: 17, orientation: enumOrientation.downright, tMap: self)
        matrixOfMutableObjects[24][17] = Torch(xPosition: 24, yPosition: 17, orientation: enumOrientation.downright, tMap: self)
        
        matrixOfMutableObjects[11][7] = Torch(xPosition: 11, yPosition: 7, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[17][7] = Torch(xPosition: 17, yPosition: 7, orientation: enumOrientation.downleft, tMap: self)
        matrixOfMutableObjects[17][12] = Torch(xPosition: 17, yPosition: 12, orientation: enumOrientation.downright, tMap: self)
        
        matrixOfMutableObjects[11][1] = Torch(xPosition: 11, yPosition: 1, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[17][1] = Torch(xPosition: 17, yPosition: 1, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[23][1] = Torch(xPosition: 23, yPosition: 1, orientation: enumOrientation.downleft, tMap: self)
        
        matrixOfMutableObjects[24][6] = Torch(xPosition: 24, yPosition: 6, orientation: enumOrientation.downright, tMap: self)
        matrixOfMutableObjects[17][5] = Torch(xPosition: 17, yPosition: 5, orientation: enumOrientation.downright, tMap: self)
        
        matrixOfMutableObjects[1][6] = Torch(xPosition: 1, yPosition: 6, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[5][1] = Torch(xPosition: 5, yPosition: 1, orientation: enumOrientation.upleft, tMap: self)
        matrixOfMutableObjects[9][6] = Torch(xPosition: 9, yPosition: 6, orientation: enumOrientation.downright, tMap: self)
        matrixOfMutableObjects[9][12] = Torch(xPosition: 9, yPosition: 12, orientation: enumOrientation.downright, tMap: self)
        matrixOfMutableObjects[5][12] = Torch(xPosition: 5, yPosition: 12, orientation: enumOrientation.upright, tMap: self)
        matrixOfMutableObjects[1][1] = Torch(xPosition: 1, yPosition: 1, orientation: enumOrientation.upleft, tMap: self)
        
        
        // Voala!!
        
        loadMapSprites()
        
    }
    
    // After populating the matrix, we popule the Map with the sprites
    private func loadMapSprites(){
        
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
    
    public func thereIsADoor(x:Int, y:Int) -> Door?{ // Exclusive method for open nearest door
        
        if x < 0 || x > ROWS || y < 0 || y > COLS {
            return nil
        }else if matrixOfMutableObjects[x][y] is Door {
            return (matrixOfMutableObjects[x][y] as! Door)
        }
        return nil
        
    }
    
    public func thereIsAWall(x:Int, y:Int) -> Wall?{ // Exclusive method ajust torches and cameras
        
        if x < 0 || x > ROWS || y < 0 || y > COLS {
            return nil
        }else if matrixOfMutableObjects[x][y] is Wall {
            return (matrixOfMutableObjects[x][y] as! Wall)
        }
        return nil
        
    }
    
    public func thereIsAnObjectAt(x:Int, y:Int) -> Bool{ // Exclusive method for security items that are searching for the player
        
        if x < 0 || x > ROWS || y < 0 || y > COLS {
            return false
        }else if matrixOfMutableObjects[x][y] is Wall || matrixOfMutableObjects[x][y] is Door {
            return false
        }
        return true
        
    }
    
    public func thereIsAPlayerInThePositions(arrayOfPositions: Array<(Int,Int)>) -> Player?{
        
        for position in arrayOfPositions {
            if position.0 < ROWS && position.1 < COLS{
                if matrixOfMutableObjects[position.0][position.1] is Player{
                    return (matrixOfMutableObjects[position.0][position.1] as! Player)
                }
            }
        }
        
        return nil
        
    }
    
    public func gameOver(){
        
        self.isPaused = true
        
        if let myParent = self.parent as? Scene {
            myParent.gameOver()
        }
        
        
    }
    
    public func finishGame(){
        
        self.isPaused = true
        
        if let myParent = self.parent as? Scene {
            myParent.finishGame()
        }
        
    }
    
    public func openDoorNearPlayer(theDoor:Door){
        
        if theDoor.isOpen == false {
            matrixOfMutableObjects[theDoor.xPositionMatrix][theDoor.yPositionMatrix] = Ground.getInstance
            theDoor.openDoor()
        }
        
    }
    
    public func openDoor(theDoor:Door){
        
        if theDoor.isOpen == false && theDoor.onlyOpenWithKey == false{
            matrixOfMutableObjects[theDoor.xPositionMatrix][theDoor.yPositionMatrix] = Ground.getInstance
            theDoor.openDoor()
        }
        
    }
    
    public func closeDoor(theDoor:Door){
        
        if theDoor.isOpen == true{
            matrixOfMutableObjects[theDoor.xPositionMatrix][theDoor.yPositionMatrix] = theDoor
            theDoor.closeDoor()
        }
        
    }
    
    public func turnOffCamera(cameraToTurnOff:Camera){
        
        for camera in listOfCameras{
            if camera == cameraToTurnOff {
                camera.turnCameraOff()
            }
        }
        
    }
    
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
