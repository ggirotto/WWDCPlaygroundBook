import UIKit
import Foundation
import SpriteKit

public class Guard:SKSpriteNode{
    
    
    public var guardName : String
    public var xPositionMatrix:Int
    public var yPositionMatrix:Int
    public var guardMap:Map
    public var amIGoingDown:Bool
    public var amIGoingRight:Bool
    public var alarmIsOn:Bool
    public var mapAlarm : Alarm
    public var movements : enumMovement
    public var vertical : Bool
    
    public init(nameOfGuard:String, xPosition:Int, yPosition:Int, verticalMovement: Bool, alarm:Alarm, gMap:Map) {
        
        guardName = nameOfGuard
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        guardMap = gMap
        
        amIGoingDown = true
        amIGoingRight = true
        alarmIsOn = false
        
        vertical = verticalMovement
        
        movements = enumMovement.a
        
        mapAlarm = alarm
        
        let position = CGPoint(x: (((guardMap.width%guardMap.matrixSquareSize)/2)+(guardMap.matrixSquareSize*yPosition)-1+18), y: (((guardMap.height%guardMap.matrixSquareSize)/2)+(guardMap.matrixSquareSize*(guardMap.ROWS-1-xPosition))+18))
        
        var texture : SKTexture
        
        if verticalMovement {
            texture = SKTexture(imageNamed: "copfront1")
        }else{
            texture = SKTexture(imageNamed: "copright1")
        }
        
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: guardMap.matrixSquareSize, height: guardMap.matrixSquareSize))
        self.position = position
        
        if vertical {
            moveGuardVertical()
        }else{
            moveGuardHorizontal()
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func isPlayerNearMe(){ //Está funcionando, mas da para ajustar para a animação ficar melhor
            
        let searchDownMe = (xPositionMatrix+1,yPositionMatrix)
        let searchUpMe = (xPositionMatrix-1,yPositionMatrix)
        let searchLeftSide = (xPositionMatrix,yPositionMatrix-1)
        let searchRightSide = (xPositionMatrix,yPositionMatrix+1)
    
        
        var arrayOfPositionsToCheck = Array<(Int,Int)>.init()
        
        arrayOfPositionsToCheck.append(searchDownMe)
        arrayOfPositionsToCheck.append(searchUpMe)
        arrayOfPositionsToCheck.append(searchLeftSide)
        arrayOfPositionsToCheck.append(searchRightSide)
            
        if guardMap.thereIsAPlayerInThePositions(arrayOfPositions: arrayOfPositionsToCheck) != nil{
            guardMap.gameOver()
        }
        
    }
    
    public func moveGuardVertical(){
        
        let runCode = SKAction.run {
            
            self.isPlayerNearMe()
            
            if self.guardMap.isPossibleToMoveFor(x: self.xPositionMatrix+1, y: self.yPositionMatrix) && self.amIGoingDown == true {
                
                let position = CGPoint(x: (((self.guardMap.width%self.guardMap.matrixSquareSize)/2)+(self.guardMap.matrixSquareSize*self.yPositionMatrix)-1+18), y: (((self.guardMap.height%self.guardMap.matrixSquareSize)/2)+(self.guardMap.matrixSquareSize*(self.guardMap.ROWS-1-(self.xPositionMatrix+1)))+18))
                
                self.guardMap.moveSprite(mainSprite: self, xActualPosition: self.xPositionMatrix, yActualPosition: self.yPositionMatrix, xDestinePosition: self.xPositionMatrix+1, yDestinePosition: self.yPositionMatrix)
                
                let action = SKAction.move(to: position, duration: 0.3)
                
                self.run(action)
                
                switch self.movements {
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "copfront2")
                    self.movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "copfront3")
                    self.movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "copfront1")
                    self.movements = enumMovement.a
                    break
                default:
                    break
                }
                
                self.xPositionMatrix += 1
                
            } else if self.guardMap.isPossibleToMoveFor(x: self.xPositionMatrix-1, y: self.yPositionMatrix){
                
                self.amIGoingDown = false
                
                if !(self.guardMap.isPossibleToMoveFor(x: self.xPositionMatrix-2, y: self.yPositionMatrix)){
                    self.amIGoingDown = true
                }
                
                let position = CGPoint(x: (((self.guardMap.width%self.guardMap.matrixSquareSize)/2)+(self.guardMap.matrixSquareSize*self.yPositionMatrix)-1+18), y: (((self.guardMap.height%self.guardMap.matrixSquareSize)/2)+(self.guardMap.matrixSquareSize*(self.guardMap.ROWS-1-(self.xPositionMatrix-1)))+18))
                
                self.guardMap.moveSprite(mainSprite: self, xActualPosition: self.xPositionMatrix, yActualPosition: self.yPositionMatrix, xDestinePosition: self.xPositionMatrix-1, yDestinePosition: self.yPositionMatrix)
                
                let action = SKAction.move(to: position, duration: 0.3)
                
                self.run(action)
                
                switch self.movements {
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "copback2")
                    self.movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "copback3")
                    self.movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "copback1")
                    self.movements = enumMovement.a
                    break
                default:
                    break
                }
                
                self.xPositionMatrix -= 1
                
            }else{
                
                print("The Guard is Stuck!!")
                
            }
            
            
        }
        
        let wait = SKAction.wait(forDuration: 0.3)
        
        let cycle = SKAction.sequence([runCode, wait])
        let repeating = SKAction.repeatForever(cycle)
        
        self.run(repeating, withKey:"guardMovement")
        
    }
    
    public func stopGuardMovement(){
        self.removeAction(forKey: "guardMovement")
    }
    
    public func moveGuardHorizontal(){
        
        let runCode = SKAction.run {
            
            self.isPlayerNearMe()
            
            if self.guardMap.isPossibleToMoveFor(x: self.xPositionMatrix, y: self.yPositionMatrix+1) && self.amIGoingRight == true {
                
                let position = CGPoint(x: (((self.guardMap.width%self.guardMap.matrixSquareSize)/2)+(self.guardMap.matrixSquareSize*self.yPositionMatrix+1)-1+18), y: (((self.guardMap.height%self.guardMap.matrixSquareSize)/2)+(self.guardMap.matrixSquareSize*(self.guardMap.ROWS-1-(self.xPositionMatrix)))+18))
                
                self.guardMap.moveSprite(mainSprite: self, xActualPosition: self.xPositionMatrix, yActualPosition: self.yPositionMatrix, xDestinePosition: self.xPositionMatrix, yDestinePosition: self.yPositionMatrix+1)
                
                let action = SKAction.move(to: position, duration: 0.3)
                
                self.run(action)
                
                switch self.movements {
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "copright2")
                    self.movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "copright3")
                    self.movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "copright1")
                    self.movements = enumMovement.a
                    break
                default:
                    break
                }
                
                self.yPositionMatrix += 1
                
            } else if self.guardMap.isPossibleToMoveFor(x: self.xPositionMatrix, y: self.yPositionMatrix-1){
                
                self.amIGoingRight = false
                
                if !(self.guardMap.isPossibleToMoveFor(x: self.xPositionMatrix, y: self.yPositionMatrix-2)){
                    self.amIGoingRight = true
                }
                
                let position = CGPoint(x: (((self.guardMap.width%self.guardMap.matrixSquareSize)/2)+(self.guardMap.matrixSquareSize*self.yPositionMatrix-1)-1+18), y: (((self.guardMap.height%self.guardMap.matrixSquareSize)/2)+(self.guardMap.matrixSquareSize*(self.guardMap.ROWS-1-(self.xPositionMatrix)))+18))
                
                self.guardMap.moveSprite(mainSprite: self, xActualPosition: self.xPositionMatrix, yActualPosition: self.yPositionMatrix, xDestinePosition: self.xPositionMatrix, yDestinePosition: self.yPositionMatrix-1)
                
                let action = SKAction.move(to: position, duration: 0.3)
                
                self.run(action)
                
                switch self.movements {
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "copleft2")
                    self.movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "copleft3")
                    self.movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "copleft1")
                    self.movements = enumMovement.a
                    break
                default:
                    break
                }
                
                self.yPositionMatrix -= 1
                
            }else{
                
                print("The Guard is Stuck!!")
                
            }
            
            
        }
        
        let wait = SKAction.wait(forDuration: 0.3)
        
        let cycle = SKAction.sequence([runCode, wait])
        let repeating = SKAction.repeatForever(cycle)
        
        self.run(repeating, withKey:"guardMovement")
        
    }
    
    public func setAlarmOn(){
        
        stopGuardMovement()
        
        self.alarmIsOn = true
        isAlarmOn()
        
        let turnAlarmOff = SKAction.run {
            self.alarmIsOn = false
        }
        
        let wait = SKAction.wait(forDuration: 5)
        
        let cycle = SKAction.sequence([wait,turnAlarmOff])
        
        self.run(cycle)
        
        
        
    }
    
    public func isAlarmOn(){
        
        if alarmIsOn {
            
            self.removeAction(forKey: "guardMovement")
            
            let alarmPosition = mapAlarm.position
            
            let xBeforeAlarm = self.position.x
            let yBeforeAlarm = self.position.y
            
            let moveToAlarm = SKAction.move(to: CGPoint(x: alarmPosition.x, y: alarmPosition.y), duration: 3)
            
            let waitInAlarm = SKAction.wait(forDuration: 4)
            
            let moveBackToSearch = SKAction.move(to: CGPoint(x: xBeforeAlarm, y:yBeforeAlarm) , duration: 3)
            
            let littlewait = SKAction.wait(forDuration: 0.1)
            
            let goBackSearch = SKAction.run {
                
                if self.vertical {
                    self.moveGuardVertical()
                }else{
                    self.moveGuardHorizontal()
                }
                
            }
            
            let cycle = SKAction.sequence([moveToAlarm,waitInAlarm,moveBackToSearch,littlewait,goBackSearch])
            
            self.run(cycle, withKey:"guardMovement")
        }
        
        
        
    }
    
}
