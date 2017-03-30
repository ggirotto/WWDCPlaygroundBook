import UIKit
import Foundation
import SpriteKit

public class Camera:SKSpriteNode{
    
    public var cameraName : String
    public var xPositionMatrix:Int
    public var yPositionMatrix:Int
    public var cameraMap:Map
    public var isOn:Bool
    public var movements:enumMovement
    private var cameraOrientation:enumOrientation
    
    public init(nameOfCamera:String, xPosition:Int, yPosition:Int, orientation:enumOrientation, cMap:Map) {
        
        cameraName = nameOfCamera
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        cameraMap = cMap
        
        isOn = true
        
        cameraOrientation = orientation
        
        movements = enumMovement.a
        
        let position = CGPoint(x: (((cameraMap.width%cameraMap.matrixSquareSize)/2)+(cameraMap.matrixSquareSize*yPosition)-1+18), y: (((cameraMap.height%cameraMap.matrixSquareSize)/2)+(cameraMap.matrixSquareSize*(cameraMap.ROWS-1-xPosition))+18))
        
        var texture : SKTexture
        
        switch orientation {
        case enumOrientation.down:
            texture = SKTexture(imageNamed: "downleft1")
            break
        case enumOrientation.up:
            texture = SKTexture(imageNamed: "topright1")
            break
        default:
            texture = SKTexture.init()
        }
        
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: cameraMap.matrixSquareSize, height: cameraMap.matrixSquareSize))
        self.position = position
        
        cameraMovement()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func turnCameraOff(){
        isOn = false
        self.isPaused = true
    }
    
    public func cameraMovement(){
        
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
            
            let wait = SKAction.wait(forDuration: 0.5)
            
            let cycle = SKAction.sequence([cameraMovement,wait])
            let repeating = SKAction.repeatForever(cycle)
            
            self.run(repeating) // nao esquecer de botar para procurar o player
            
            
            
            
            
            
        }
        
    }
    
    public func isPlayerInMyVisionCamp(){
        
        // TODO  - Vou começar com pouco range, se possível aumentar no futuro
        
        let xCameraPosition = xPositionMatrix
        let yCameraPosition = yPositionMatrix
        
        var arrayOfPositionsToCheck = Array<(Int,Int)>.init()
        var visitedPositions = Array<(Int,Int)>.init()
        
        searchInMap(x:xCameraPosition, y:yCameraPosition, arrayOfPositions:&arrayOfPositionsToCheck, visitedPositions: &visitedPositions)
        
        if cameraMap.thereIsAPlayerInThePositions(arrayOfPositions: arrayOfPositionsToCheck) != nil {
            cameraMap.gameOver()
        }
        
    }
    
    func contains(a:[(Int, Int)], v:(Int,Int)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    
    public func searchInMap(x:Int, y:Int, arrayOfPositions: inout Array<(Int,Int)>, visitedPositions: inout Array<(Int,Int)>){
        
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
    
    public func cameraObservation(){
        
    }
    
}
