import Foundation
import SpriteKit

public class Vara:SKSpriteNode {
    //variaveis
    /*
     Se a vara está lançada ou nao - "neutro","esperando","fisgada"
     */
    var estado:String = "neutro"
    var spritesLancar:[SKTexture] = [SKTexture(imageNamed: "Pescador1"),SKTexture(imageNamed: "Pescador2"),SKTexture(imageNamed: "Pescador3"),SKTexture(imageNamed: "Pescador4"),SKTexture(imageNamed: "Pescador5"),SKTexture(imageNamed: "Pescador6"),SKTexture(imageNamed: "Pescador7"),SKTexture(imageNamed: "Pescador8")]
    
    //metodos
    public func lancar() {
        let action = SKAction.animate(with: spritesLancar, timePerFrame: 0.15)
        self.run(action)
    }
    
    public func fisgar(){
        
    }
    
    public init(_ scene:SKScene) {
        let texture = SKTexture(imageNamed: "VaraNeutra")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.zPosition = 1.0
        ///
        self.position = CGPoint(x: scene.size.width*(-0.35), y: scene.size.height*0.03)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
