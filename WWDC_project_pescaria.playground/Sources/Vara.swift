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
    var spritesLancar:[SKTexture] = [SKTexture(imageNamed: "varaPescando2"),SKTexture(imageNamed: "varaPescando3")]
    
    var spritesFisgar:[SKTexture] = [SKTexture(imageNamed: "varaFisgada1"),SKTexture(imageNamed: "varaFisgada2"),SKTexture(imageNamed: "varaFisgada3"),SKTexture(imageNamed: "varaFisgada4"),SKTexture(imageNamed: "varaFisgada5")]
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
            let action2 = SKAction.animate(with: [SKTexture(imageNamed: "varaNeutra")], timePerFrame: 0.12)
            
            self.run(action,completion:{
                self.estado = "neutro"
                self.run(action2)
            })
        }
    }
    
    public init(_ scene:SKScene) {
        let texture = SKTexture(imageNamed: "varaNeutra")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.zPosition = 4
        ///
        self.position = CGPoint(x: scene.size.width*(-0.05), y: scene.size.height*(-0.25))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
