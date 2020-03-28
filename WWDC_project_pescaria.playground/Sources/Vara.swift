import Foundation
import SpriteKit

public class Vara:SKSpriteNode,ObserverPeixe {
    public var temIsca: Int?
    public func morder() {}

    

    //variaveis
    /*
     Se a vara está lançada ou nao - "neutro","esperando","fisgada"
     */
    public var estado:String = "neutro"
    var spritesLancar:[SKTexture] = [SKTexture(imageNamed: "Pescador1"),SKTexture(imageNamed: "Pescador2"),SKTexture(imageNamed: "Pescador3"),SKTexture(imageNamed: "Pescador4"),SKTexture(imageNamed: "Pescador5"),SKTexture(imageNamed: "Pescador6"),SKTexture(imageNamed: "Pescador7"),SKTexture(imageNamed: "Pescador8")]
    
    var spritesFisgar:[SKTexture] = [SKTexture(imageNamed: "Fisgada1"),SKTexture(imageNamed: "Fisgada2"),SKTexture(imageNamed: "Fisgada3"),SKTexture(imageNamed: "Fisgada4"),SKTexture(imageNamed: "Fisgada5"),SKTexture(imageNamed: "Fisgada6"),SKTexture(imageNamed: "Fisgada7"),SKTexture(imageNamed: "Fisgada8")]
    var spriteNormal = SKTexture(imageNamed: "VaraNeutra")
    
    //metodos
    public func lancar() {
        if temIsca == 0{
            let action = SKAction.animate(with: spritesLancar, timePerFrame: 0.15)
            self.run(action,completion:{
                self.estado = "esperando"
            })
        }
    }
    
    func fisgar(){
        if temIsca == 1{
            let action = SKAction.animate(with: spritesFisgar, timePerFrame: 3)
            let action2 = SKAction.animate(with: [SKTexture(imageNamed: "VaraNeutra")], timePerFrame: 0.12)
            
            self.run(action,completion:{
                self.estado = "neutro"
                self.run(action2)
            })
        }
    }
    
    public init(_ scene:SKScene) {
        let texture = SKTexture(imageNamed: "VaraNeutra")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.zPosition = 2.0
        ///
        self.position = CGPoint(x: scene.size.width*(-0.27), y: scene.size.height*(-0.10))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
