import UIKit
import Foundation
import SpriteKit

public class Player:SKSpriteNode{
    
    private var inventory: Set<SKSpriteNode>
    public var xPositionMatrix:Int
    public var yPositionMatrix:Int
    public var playerMap:Map
    private var playerMessages:TerminalMonitor?
    private var movements : enumMovement
    private var sendingMessage: Bool
    
    public init(xPosition:Int, yPosition:Int, pMap:Map) {
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        inventory = Set.init()
        playerMap = pMap
        
        movements = enumMovement.a
        
        sendingMessage = false;
        
        let position = CGPoint(x: (((playerMap.width%playerMap.matrixSquareSize)/2)+(playerMap.matrixSquareSize*yPosition)-1+18), y: (((playerMap.height%playerMap.matrixSquareSize)/2)+(playerMap.matrixSquareSize*(playerMap.ROWS-1-xPosition))+18))
        
        let texture = SKTexture(imageNamed: "front1")
        super.init(texture: texture, color: UIColor.clear, size:texture.size())
        
        self.position = position
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addObjectToInventory(object:SKSpriteNode){
        inventory.insert(object)
    }
    
    private func removePlayerMonitor(){
        
        if let playerMessages = self.playerMessages{
            playerMap.removeChildren(in: [playerMessages])
        }
        
        
    }
    
    public func moveRight(){
        
        removePlayerMonitor()

        if playerMap.isPossibleToMoveFor(x: xPositionMatrix, y: yPositionMatrix+1) {

            let position = CGPoint(x: (((playerMap.width%self.playerMap.matrixSquareSize)/2)+(self.playerMap.matrixSquareSize*(yPositionMatrix+1))-1+18), y: (((playerMap.height%self.playerMap.matrixSquareSize)/2)+(self.playerMap.matrixSquareSize*(playerMap.ROWS-1-xPositionMatrix))+18))
            
            let action = SKAction.move(to: position, duration: 0.08)
            
            if self.action(forKey: "moveup") == nil && self.action(forKey: "movedown") == nil && self.action(forKey: "moveright") == nil && self.action(forKey: "moveleft") == nil {
                self.run(action, withKey: "moveright")
                
                switch movements {
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "right2")
                    movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "right3")
                    movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "right1")
                    movements = enumMovement.a
                    break
                default:
                    break
                }
            }
            
            
            playerMap.moveSprite(mainSprite: self, xActualPosition: xPositionMatrix, yActualPosition: yPositionMatrix, xDestinePosition: xPositionMatrix, yDestinePosition: yPositionMatrix+1)
            
            yPositionMatrix += 1
        }
        
    }
    
    public func moveLeft(){
        
        removePlayerMonitor()
        
        if playerMap.isPossibleToMoveFor(x: xPositionMatrix, y: yPositionMatrix-1) {
            
            let position = CGPoint(x: (((playerMap.width%self.playerMap.matrixSquareSize)/2)+(self.playerMap.matrixSquareSize*(yPositionMatrix-1))-1+18), y: (((playerMap.height%self.playerMap.matrixSquareSize)/2)+(self.playerMap.matrixSquareSize*(playerMap.ROWS-1-xPositionMatrix))+18))
            
            let action = SKAction.move(to: position, duration: 0.08)
            
            if self.action(forKey: "moveup") == nil && self.action(forKey: "movedown") == nil && self.action(forKey: "moveright") == nil && self.action(forKey: "moveleft") == nil {
                self.run(action, withKey: "moveleft")
                
                switch movements {
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "left2")
                    movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "left3")
                    movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "left1")
                    movements = enumMovement.a
                    break
                default:
                    break
                }
            }
            
            playerMap.moveSprite(mainSprite: self, xActualPosition: xPositionMatrix, yActualPosition: yPositionMatrix, xDestinePosition: xPositionMatrix, yDestinePosition: yPositionMatrix-1)
            
            yPositionMatrix -= 1
        }
        
    }
    
    public func moveUp(){
        
        removePlayerMonitor()
        
        if playerMap.isPossibleToMoveFor(x: xPositionMatrix-1, y: yPositionMatrix) {
            
            let position = CGPoint(x: (((playerMap.width%self.playerMap.matrixSquareSize)/2)+(self.playerMap.matrixSquareSize*yPositionMatrix)-1+18), y: (((playerMap.height%self.playerMap.matrixSquareSize)/2)+(self.playerMap.matrixSquareSize*(playerMap.ROWS-1-(xPositionMatrix-1)))+18))
            
            let action = SKAction.move(to: position, duration: 0.08)
            
            if self.action(forKey: "moveup") == nil && self.action(forKey: "movedown") == nil && self.action(forKey: "moveright") == nil && self.action(forKey: "moveleft") == nil {
                self.run(action, withKey: "moveup")
                
                switch movements {
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "back2")
                    movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "back3")
                    movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "back1")
                    movements = enumMovement.a
                    break
                default:
                    break
                }
            }
            
            playerMap.moveSprite(mainSprite: self, xActualPosition: xPositionMatrix, yActualPosition: yPositionMatrix, xDestinePosition: xPositionMatrix-1, yDestinePosition: yPositionMatrix)
            
            xPositionMatrix -= 1
        }
        
    }
    
    public func moveDown(){
        
        removePlayerMonitor()
        
        if playerMap.isPossibleToMoveFor(x: xPositionMatrix+1, y: yPositionMatrix) {
            
            let position = CGPoint(x: (((playerMap.width%self.playerMap.matrixSquareSize)/2)+(self.playerMap.matrixSquareSize*yPositionMatrix)-1+18), y: (((playerMap.height%self.playerMap.matrixSquareSize)/2)+(self.playerMap.matrixSquareSize*(playerMap.ROWS-1-(xPositionMatrix+1)))+18))
            
            let action = SKAction.move(to: position, duration: 0.08)
            
            if self.action(forKey: "moveup") == nil && self.action(forKey: "movedown") == nil && self.action(forKey: "moveright") == nil && self.action(forKey: "moveleft") == nil {
                self.run(action, withKey: "movedown")
                
                switch movements {
                    case enumMovement.a:
                        self.texture = SKTexture(imageNamed: "front2")
                        movements = enumMovement.b
                        break
                    case enumMovement.b:
                        self.texture = SKTexture(imageNamed: "front3")
                        movements = enumMovement.c
                        break
                    case enumMovement.c:
                        self.texture = SKTexture(imageNamed: "front1")
                        movements = enumMovement.a
                        break
                default:
                    break
                }
                
            }
            
            playerMap.moveSprite(mainSprite: self, xActualPosition: xPositionMatrix, yActualPosition: yPositionMatrix, xDestinePosition: xPositionMatrix+1, yDestinePosition: yPositionMatrix)
            
            xPositionMatrix += 1
        }
        
    }
    
    public func pickUpTheKey(){
        
        if let key = playerMap.thereIsAKeyNearPlayer(mainPlayer: self) {

            addObjectToInventory(object: key)

            playerMap.removeKeyFromMap(playerKey: key)

            key.removeKeyFromMap()
            
        }else {
            
            let messageToPlayer = SKLabelNode.init(text: "Get closer to pick up the key!")
            
            sendMessagesToPlayer(messagesToSend: [messageToPlayer])
            
        }
        
    }
    
    public func sendMessagesToPlayer(messagesToSend:Array<SKLabelNode>){
        
        if !sendingMessage{
            
            playerMessages = TerminalMonitor(position:self.position)
            
            playerMessages!.addLabelsToSprite(arrayOfLabels: messagesToSend)
            
            playerMessages!.makeMonitorVisible()
            
            let addMessage = SKAction.run {
                self.playerMap.addChild(self.playerMessages!)
                self.sendingMessage = true
            }
            
            let wait = SKAction.wait(forDuration: 2)
            
            let removeMessage = SKAction.run {
                self.playerMap.removeChildren(in: [self.playerMessages!])
                self.sendingMessage = false;
            }
            
            let cycle = SKAction.sequence([addMessage, wait, removeMessage])
            
            playerMap.run(cycle)
        }
        
        
    }
    
    public func openDoor(){
        
        if let door = playerMap.thereIsADoorNearPlayer(mainPlayer: self) {
            
            var hasKey = false
            for item in self.inventory {
                if item is Key {
                    inventory.remove(item)
                    playerMap.openDoorNearPlayer(theDoor:door)
                    hasKey = true
                }
            }
            if !hasKey{
                let messageToPlayer = SKLabelNode.init(text: "You need a key to open the door!")
                
                sendMessagesToPlayer(messagesToSend: [messageToPlayer])
            }
        }else{
            let messageToPlayer = SKLabelNode.init(text: "Get closer to open the door!")
            
            sendMessagesToPlayer(messagesToSend: [messageToPlayer])
        }
        
        
        
    }
}
