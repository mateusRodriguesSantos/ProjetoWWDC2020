import Foundation
import SpriteKit

public class Rio:SKSpriteNode,ObserverPeixe {
    public var temIsca: Int?
    
    public func morder() {}
    
    //variaveis
    /*
     Se o rio recebeu uma ordem da vara - ""
     */
    public var estado:String = "neutro"
    public var vara:Vara?
    
    //metodos
    
    /*
        function: essa funcao altera o estado da vara de "espera" p/ "fisgada"
        parameter: Vara
     */
    public func alterarEstadoVara(_ vara: Vara) {
        //1- verificada se esta em "espera"
        if vara.estado == "esperando"{
            //2- muda estado da vara e chama animacao de fisgada
            vara.estado = "fisgada"
            vara.fisgar()
            vara.temIsca = 0
        }
    }
    
    public init(_ scene:SKScene) {
        let texture = SKTexture(imageNamed: "rio")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        self.zPosition = 2.1
        ///
        self.position = CGPoint(x: scene.size.width*(-0.001), y: scene.size.height*(-0.23))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
