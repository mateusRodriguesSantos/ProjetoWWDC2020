import Foundation
import SpriteKit

public class Rio:SKSpriteNode {
    //variaveis
    /*
     Se o rio recebeu uma ordem da vara - ""
     */
    var estado:String = "neutro"
    var vara:Vara?
    
    //metodos
    
    /*
        function: essa funcao altera o estado da vara de "espera" p/ "fisgada"
        parameter: Vara
     */
    func alterarEstadoVara(_ vara: Vara) {
        //1- verificada se esta em "espera"
        if vara.estado == "espera"{
            //2- muda estado da vara e chama animacao de fisgada
            vara.estado = "fisgada"
            vara.fisgar()
        }
       
    }
    
    public init(_ scene:SKScene) {
        let texture = SKTexture(imageNamed: "rio")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        self.zPosition = 2.1
        ///
        self.position = CGPoint(x: scene.size.width*0.1, y: scene.size.height*(-0.23))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
