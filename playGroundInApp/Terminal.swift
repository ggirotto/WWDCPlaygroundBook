import UIKit
import Foundation
import SpriteKit

public class Terminal:SKSpriteNode{
    
    public var terminalName : String
    public var terminalMap:Map
    public var terminalMonitor : TerminalMonitor
    public var xPositionMatrix:Int
    public var yPositionMatrix: Int
    
    public init(nameOfTerminal:String, xPosition:Int, yPosition: Int, orientation: enumOrientation, tMap:Map) {
        
        terminalName = nameOfTerminal
        
        terminalMap = tMap
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        let position = CGPoint(x: (((terminalMap.width%terminalMap.matrixSquareSize)/2)+(terminalMap.matrixSquareSize*yPosition)-1+16), y: (((terminalMap.height%terminalMap.matrixSquareSize)/2)+(terminalMap.matrixSquareSize*(terminalMap.ROWS-1-xPosition))+(terminalMap.matrixSquareSize/2)))
        
        terminalMonitor = TerminalMonitor(position: position) // Tem que arrumar terminal monitor tmb
        
        var texture : SKTexture
        
        switch orientation {
        case enumOrientation.up:
            texture = SKTexture(imageNamed: "terminal")
            break
        case enumOrientation.down:
            texture = SKTexture(imageNamed: "terminaldown")
            break
        case enumOrientation.left:
            texture = SKTexture(imageNamed: "terminalleft")
            break
        case enumOrientation.right:
            texture = SKTexture(imageNamed: "terminalright")
            break
        default:
            texture = SKTexture.init()
            break
        }
        
        
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: terminalMap.matrixSquareSize, height: terminalMap.matrixSquareSize))
        self.position = position
        
        listPossibleCommands()
        
    }
    
    public func removeTerminalMonitor(){
        terminalMonitor.makeMonitorHidden()
    }
    
    public func makeMonitorFadeIn(){
        
        terminalMonitor.fadeInMonitor()
        
    }
    
    public func makeMonitorVisible(){
        
        terminalMonitor.makeMonitorVisible()
        
    }
    
    public func makeMonitorHidden(){
        
        terminalMonitor.makeMonitorHidden()
        
    }
    
    public func listPossibleCommands() {
        
        var arrayOfPossibleCommands = Array<SKLabelNode>.init()
        
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "Welcome Player!"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "Here's a list of commands that you can use:"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "listAllDoors()"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "openDoor(door: doorName)"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "listAllCameras()"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "turnOffCamera(camera: cameraName)"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "turnAlarmsOn()"))
        
        terminalMonitor.addLabelsToSprite(arrayOfLabels: arrayOfPossibleCommands)
        
    }
    
    public func listAllDoors() {
        
        var arrayOfPossibleCommands = Array<SKLabelNode>.init()
        
        for door in terminalMap.listOfDoors{
            
            let doorIsOpen = door.isOpen
            if doorIsOpen {
                let text = "Door" + door.doorName + " - " + "Open"
                let label = SKLabelNode.init(text: text)
                arrayOfPossibleCommands.append(label)
            }else{
                let text = "Door" + door.doorName + " - " + "Closed"
                let label = SKLabelNode.init(text: text)
                arrayOfPossibleCommands.append(label)
            }
            

        }
        
        terminalMonitor.addLabelsToSprite(arrayOfLabels: arrayOfPossibleCommands)
        
        
    }
    
    public func openDoor(doorWithName:String) {
        
        for door in terminalMap.listOfDoors{
            if door.doorName == doorWithName{
                terminalMap.openDoor(theDoor: door)
            }else{
                let exceptionMessage = SKLabelNode.init(text: "There is no door with this name!")
                terminalMonitor.addLabelsToSprite(arrayOfLabels: [exceptionMessage])
            }
        
        }
    }
    
    public func playerInteraction(mainPlayer:Player){
        
        if (terminalMap.thereIsATerminalNearPlayer(mainPlayer: mainPlayer) != nil){
            if terminalMonitor.isHidden {
                makeMonitorFadeIn()
            }else{
                makeMonitorHidden()
            }
        }else{
            
            let messageToPlayer = SKLabelNode.init(text: "Approach to intercat with the Terminal")
            mainPlayer.sendMessagesToPlayer(messagesToSend: messageToPlayer)
            
        }
        
        
        
    }
    
    public func listAllCameras() {
        
        var arrayOfPossibleCommands = Array<SKLabelNode>.init()
        
        for camera in terminalMap.listOfCameras{
            
            let cameraIsOn = camera.isOn
            if cameraIsOn {
                let text = "Camera" + camera.cameraName + " - " + "On"
                let label = SKLabelNode.init(text: text)
                arrayOfPossibleCommands.append(label)
            }else{
                let text = "Camera" + camera.cameraName + " - " + "Off"
                let label = SKLabelNode.init(text: text)
                arrayOfPossibleCommands.append(label)
            }
            
            
        }
        
        terminalMonitor.addLabelsToSprite(arrayOfLabels: arrayOfPossibleCommands)
        
    }
    
    public func turnOffCamera(cameraWithName: String) {
        
        for camera in terminalMap.listOfCameras{
            if camera.cameraName == cameraWithName{
                terminalMap.turnOffCamera(cameraToTurnOff: camera)
            }else{
                let exceptionMessage = SKLabelNode.init(text: "There is no camera with this name!")
                terminalMonitor.addLabelsToSprite(arrayOfLabels: [exceptionMessage])
            }
        }
        
    }
    
    public func turnAlarmOn(){
    
        terminalMap.turnAlarmOn()
    
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
