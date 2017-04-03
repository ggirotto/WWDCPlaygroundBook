import UIKit
import Foundation
import SpriteKit

public class Terminal:SKSpriteNode{
    
    public var terminalMap:Map
    public var terminalMonitor : TerminalMonitor
    private var imFinishTerminal: Bool
    public var xPositionMatrix:Int
    public var yPositionMatrix: Int
    private var listOfCameras : Array<Camera>
    
    public init(xPosition:Int, yPosition: Int, finish: Bool, cameras:Array<Camera>, tMap:Map) {
        
        terminalMap = tMap
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        imFinishTerminal = finish
        
        listOfCameras = cameras
        
        let position = CGPoint(x: (((terminalMap.width%terminalMap.matrixSquareSize)/2)+(terminalMap.matrixSquareSize*yPosition)-1+16), y: (((terminalMap.height%terminalMap.matrixSquareSize)/2)+(terminalMap.matrixSquareSize*(terminalMap.ROWS-1-xPosition))+(terminalMap.matrixSquareSize/2)))
        
        terminalMonitor = TerminalMonitor(position: position)
        
        
        let texture = SKTexture(imageNamed: "terminal")
        super.init(texture: texture, color: UIColor.clear, size:texture.size())
        
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
    
    public func welcomMessageAndlistPossibleCommands() {
        
        var arrayOfPossibleCommands = Array<SKLabelNode>.init()
        
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "Welcome Player!"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "Here's a list of methods that you can use:"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "openNearestDoors()"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "turnOffNearestCameras"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "turnAlarmsOn()"))
        
        terminalMonitor.addLabelsToSprite(arrayOfLabels: arrayOfPossibleCommands)
        
    }
    
    public func listPossibleCommands() {
        
        var arrayOfPossibleCommands = Array<SKLabelNode>.init()
        
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "Chose any method to execute"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "openNearestDoors()"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "turnOffNearestCameras"))
        arrayOfPossibleCommands.append(SKLabelNode.init(text: "turnAlarmsOn()"))
        
        terminalMonitor.addLabelsToSprite(arrayOfLabels: arrayOfPossibleCommands)
        
    }
    
    public func finishMessage() {
        
        var arrayWithFinishParagraph = Array<SKLabelNode>.init()
        
        arrayWithFinishParagraph.append(SKLabelNode.init(text: "Congratulations Player!"))
        arrayWithFinishParagraph.append(SKLabelNode.init(text: "You have successfully completed the escape game!"))
        arrayWithFinishParagraph.append(SKLabelNode.init(text: "You might enjoy your freedom now."))
        
        terminalMonitor.addLabelsToSprite(arrayOfLabels: arrayWithFinishParagraph)
        
        
    }
    
    public func searchForDoors() -> Array<Door>{
        
        let xTerminalPosition = xPositionMatrix
        let yTerminalPosition = yPositionMatrix
        
        var visitedPositions = Array<(Int,Int)>.init()
        var listOfNearestDoors = Array<Door>.init()
        
        searchInMap(x:xTerminalPosition, y:yTerminalPosition, visitedPositions: &visitedPositions, doorsList: &listOfNearestDoors)
        
        return listOfNearestDoors
        
    }
    
    public func searchInMap(x:Int, y:Int, visitedPositions: inout Array<(Int,Int)>, doorsList: inout Array<Door> ) {
        
        if contains(a:visitedPositions, v:(x,y)) {
            return
        }else if !terminalMap.thereIsAnObjectAt(x: x, y: y){
            if let door = terminalMap.thereIsADoor(x: x, y: y){
                doorsList.append(door)
            }
        }else{
            visitedPositions.append((x,y))
            searchInMap(x: x+1, y: y, visitedPositions: &visitedPositions, doorsList: &doorsList)
            searchInMap(x: x-1, y: y, visitedPositions: &visitedPositions, doorsList: &doorsList)
            searchInMap(x: x, y: y+1, visitedPositions: &visitedPositions, doorsList: &doorsList)
            searchInMap(x: x, y: y-1, visitedPositions: &visitedPositions, doorsList: &doorsList)
            
        }
        
    }
    
    
    func contains(a:[(Int, Int)], v:(Int,Int)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    
    public func openNearestDoors() {
        
        let listOfDoors = searchForDoors()
        var sequenceOfActions = Array<SKAction>.init()
        
        for door in listOfDoors {
            
            let openDoor = SKAction.run{
                
                self.terminalMap.openDoor(theDoor: door)
                
            }
            
            sequenceOfActions.append(openDoor)
            
        }
            
        let showMessage = SKAction.run {
            let messageToTerminal = SKLabelNode.init(text: "The doors are closing in 10s!")
            self.terminalMonitor.addLabelsToSprite(arrayOfLabels: [messageToTerminal])
            self.makeMonitorFadeIn()
        }
        
        sequenceOfActions.append(showMessage)
        
        let waitTenSeconds = SKAction.wait(forDuration: 10)
        
        sequenceOfActions.append(waitTenSeconds)
        
        for door in listOfDoors {
            
            let closeTheDoor = SKAction.run {
                
                self.terminalMap.closeDoor(theDoor:door)
                
            }
            
            sequenceOfActions.append(closeTheDoor)
            
        }
        
        let sequence = SKAction.sequence(sequenceOfActions)
        
        self.run(sequence)
        
        
    }
    
    public func turnOffNearestCameras() {
        
        let turnCamerasOff = SKAction.run{
            
            for camera in self.listOfCameras{
                
                camera.turnCameraOff()
                
            }
            
        }
        
        
        
        let showMessage = SKAction.run {
            let messageToTerminal = SKLabelNode.init(text: "The cameras are off!")
            self.terminalMonitor.addLabelsToSprite(arrayOfLabels: [messageToTerminal])
        }
        
        let sequence = SKAction.sequence([turnCamerasOff,showMessage])
        
        self.run(sequence)
        
    }
    
    public func turnAlarmsOn(){
        
        let turnOn = SKAction.run{
            
            self.terminalMap.turnAlarmOn()
            
        }
        
        
        
        let showMessage = SKAction.run {
            let messageToTerminal = SKLabelNode.init(text: "The alarms are on for 10s!")
            self.terminalMonitor.addLabelsToSprite(arrayOfLabels: [messageToTerminal])
        }
        
        let sequence = SKAction.sequence([turnOn,showMessage])
        
        self.run(sequence)
        
    
        
    }
    
    public func playerInteraction(mainPlayer:Player){
        
        
        if (terminalMap.thereIsATerminalNearPlayer(mainPlayer: mainPlayer) != nil){
            if terminalMonitor.isHidden {
                
                if imFinishTerminal {
                    
                    let finishMessage = SKAction.run{
                        self.finishMessage()
                    }
                    
                    let wait = SKAction.wait(forDuration: 5)
                    
                    let finishTheGame = SKAction.run {
                        self.terminalMap.finishGame()
                    }
                    
                    let cycle = SKAction.sequence([finishMessage,wait,finishTheGame])
                    
                    self.run(cycle)
                }
                
                makeMonitorFadeIn()
            }else{
                makeMonitorHidden()
            }
        }else{
            
            let messageToPlayer = SKLabelNode.init(text: "Approach the Terminal to use the commands")
            mainPlayer.sendMessagesToPlayer(messagesToSend: [messageToPlayer])
            
        }
        
        
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
