import UIKit
import Foundation
import SpriteKit

public class Camera:SKSpriteNode{
    
    public var xPositionMatrix:Int
    public var yPositionMatrix:Int
    public var cameraMap:Map
    public var isOn:Bool
    public var movements:enumMovement
    private var cameraOrientation:enumOrientation
    
    public init(xPosition:Int, yPosition:Int, orientation:enumOrientation, cMap:Map) {
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        cameraMap = cMap
        
        isOn = true
        
        cameraOrientation = orientation
        
        movements = enumMovement.a
        
        // Change the camera texture based on its location: up or down
        
        var imageName : String
        
        switch orientation {
        case enumOrientation.down:
            imageName = "downleft1"
            break
        case enumOrientation.up:
            imageName = "topright1"
            break
        default:
            imageName = ""
        }
        
        let texture = SKTexture(imageNamed: imageName)
        let size = CGSize(width: 35, height:20)
        super.init(texture: texture, color: UIColor.clear, size:size)
        
        let positionAdjustment = setCameraPosition(cameraMap:cMap, cameraOrientation: orientation, xPosition: xPosition, yPosition:yPosition)
        
        self.position = CGPoint(x: (((cameraMap.width%cameraMap.matrixSquareSize)/2)+(cameraMap.matrixSquareSize*yPosition)-1+positionAdjustment.0), y: (((cameraMap.height%cameraMap.matrixSquareSize)/2)+(cameraMap.matrixSquareSize*(cameraMap.ROWS-1-xPosition))+positionAdjustment.1))
        
        self.position = position
        
        // Start the camera sprite moving
        cameraMovement()
        
    }
    
    // This method set the camera position base on it's location. It calculates how much the camera needs to move to grab into the
    // closer wall
    private func setCameraPosition(cameraMap:Map, cameraOrientation:enumOrientation, xPosition:Int,yPosition:Int) -> (Int,Int){
        
        switch cameraOrientation {
        case enumOrientation.up:
            if let leftObject = cameraMap.thereIsAWall(x: xPosition, y:yPosition+1 ) {
                if leftObject.wallOrientation == enumOrientation.left{
                    return (18,18)
                }else if leftObject.wallOrientation == enumOrientation.up{
                    return (18,18)
                }else if leftObject.wallOrientation == enumOrientation.right{
                    return (33,18)
                }
            }
            break
        case enumOrientation.down:
            if let leftObject = cameraMap.thereIsAWall(x: xPosition, y:yPosition-1 ) {
                if leftObject.wallOrientation == enumOrientation.left{
                    return (3,18)
                }else if leftObject.wallOrientation == enumOrientation.up{
                    return (18,18)
                }else if leftObject.wallOrientation == enumOrientation.right{
                    return (18,18)
                }
            }
            break
        default:
            return (18,18)
            break
        }
        return (18,18)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func turnCameraOff(){
        isOn = false
        self.isPaused = true
    }
    
    public func turnCameraOn(){
        isOn = true
        self.isPaused = false
    }
    
    // Keep changing the camera texture to simulate movement
    private func cameraMovement(){
        
        let positionsToCheck = checkPossiblePlayerLocations()
        
        if isOn {

            let cameraMovement = SKAction.run{
                
                switch self.cameraOrientation {
                    
                case enumOrientation.down:
                    switch self.movements {
                        
                    case enumMovement.a:
                        self.texture = SKTexture(imageNamed: "downleft2")
                        self.movements = enumMovement.b
                        break
                    case enumMovement.b:
                        self.texture = SKTexture(imageNamed: "downleft1")
                        self.movements = enumMovement.c
                        break
                    case enumMovement.c:
                        self.texture = SKTexture(imageNamed: "downleft3")
                        self.movements = enumMovement.d
                        break
                    case enumMovement.d:
                        self.texture = SKTexture(imageNamed: "downleft1")
                        self.movements = enumMovement.a
                        break
                    }
                    
                    break
                    
                case enumOrientation.up:
                    switch self.movements {
                        
                    case enumMovement.a:
                        self.texture = SKTexture(imageNamed: "topright2")
                        self.movements = enumMovement.b
                        break
                    case enumMovement.b:
                        self.texture = SKTexture(imageNamed: "topright1")
                        self.movements = enumMovement.c
                        break
                    case enumMovement.c:
                        self.texture = SKTexture(imageNamed: "topright3")
                        self.movements = enumMovement.d
                        break
                    case enumMovement.d:
                        self.texture = SKTexture(imageNamed: "topright1")
                        self.movements = enumMovement.a
                        break
                    }
                    
                    break
                    
                default:
                    break
                }
                
                
            }
            
            let searchPlayer = SKAction.run{
                
                self.isPlayerInMyVisionCamp(arrayOfPositionsToCheck: positionsToCheck)
                
            }
            
            let wait = SKAction.wait(forDuration: 0.5)
            
            let cycle = SKAction.sequence([cameraMovement,searchPlayer,wait])
            let repeating = SKAction.repeatForever(cycle)
            
            self.run(repeating)
            
        }
        
    }
    
    // Send to map an array of tuples. If the player it's in one of this tuples the camera end the game
    public func isPlayerInMyVisionCamp(arrayOfPositionsToCheck:Array<(Int,Int)>){
        
        if cameraMap.thereIsAPlayerInThePositions(arrayOfPositions: arrayOfPositionsToCheck) != nil {
            self.cameraMap.gameOver()
        }
        
    }
    
    // Methods below search for the player
    private func checkPossiblePlayerLocations() -> Array<(Int,Int)>{
        
        let xCameraPosition = xPositionMatrix
        let yCameraPosition = yPositionMatrix
        
        var arrayOfPositionsToCheck = Array<(Int,Int)>.init()
        var visitedPositions = Array<(Int,Int)>.init()
        
        searchInMap(x:xCameraPosition, y:yCameraPosition, arrayOfPositions:&arrayOfPositionsToCheck, visitedPositions: &visitedPositions)
        
        return arrayOfPositionsToCheck
    }
    
    private func contains(a:[(Int, Int)], v:(Int,Int)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    
    private func searchInMap(x:Int, y:Int, arrayOfPositions: inout Array<(Int,Int)>, visitedPositions: inout Array<(Int,Int)>){
        
        if !cameraMap.thereIsAnObjectAt(x: x, y: y){
            return
        }else if contains(a:arrayOfPositions, v:(x,y)) {
            return
        }else{
            arrayOfPositions.append((x,y))
            visitedPositions.append((x,y))
            searchInMap(x: x+1, y: y, arrayOfPositions: &arrayOfPositions, visitedPositions: &visitedPositions)
            searchInMap(x: x-1, y: y, arrayOfPositions: &arrayOfPositions, visitedPositions: &visitedPositions)
            searchInMap(x: x, y: y+1, arrayOfPositions: &arrayOfPositions, visitedPositions: &visitedPositions)
            searchInMap(x: x, y: y-1, arrayOfPositions: &arrayOfPositions, visitedPositions: &visitedPositions)
        }
        
    }
    
}
