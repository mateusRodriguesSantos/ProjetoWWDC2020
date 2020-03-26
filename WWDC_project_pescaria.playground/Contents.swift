//
import Foundation
import PlaygroundSupport
import GameplayKit
import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate,ObserverPeixe {
    
    var contadorTexto = Int()
    var texto:SKLabelNode?
    
    var temIsca: Int?
    var ceu:SKSpriteNode?
    var grama:SKSpriteNode?
    var agua:SKSpriteNode?
    var rio: Rio?
    var vara: Vara?
    
    override func didMove(to view: SKView) {
        //Fundo
        ceu = SKSpriteNode(imageNamed: "ceu")
        ceu?.zPosition = 1.8
        ceu?.position = CGPoint(x: 0, y: self.size.height*(0.2))
        self.addChild(ceu!)
  
        grama = SKSpriteNode(imageNamed: "grama")
        grama?.zPosition = 2
        grama?.position = CGPoint(x: 0, y: self.size.height*(-0.25))
        self.addChild(grama!)
        
        //Particulas
        if let nuvenIdo = SKEmitterNode(fileNamed: "nuvens.sks"){
            self.addChild(nuvenIdo)
        }
        
        if let nuvenVoltando = SKEmitterNode(fileNamed: "nuvens.sks"){
            nuvenVoltando.particleSpeed = CGFloat(-15)
            self.addChild(nuvenVoltando)
        }
        
        //Adicionando texto inicial
        contadorTexto = 1
        
        texto = SKLabelNode(fontNamed: "SF Pro Rounded")
        texto?.fontColor = .black
        texto?.fontSize = CGFloat(50)
        texto?.text = dicionarioTextos[1]
        texto?.zPosition = 3
        texto?.position = CGPoint(x: 0, y: self.size.height*(0.3))
        texto?.horizontalAlignmentMode = .center
        self.addChild(texto!)

        //Adicionando rio
        self.rio = Rio(self)
        self.addChild(rio!)
    }

    func morder() {
        if vara?.estado == "esperando"{
            vara?.temIsca = 1
            rio?.alterarEstadoVara(self.vara!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Soma mais um ao contador do texto e muda o texto se preciso
        if contadorTexto < 4 || contadorTexto >= 13{
            contadorTexto = contadorTexto + 1
            interacaoTexto(contadorTexto)
        }

        //Verifica se pode lancar a vara
        if vara?.estado == "neutro" && contadorTexto == 4{
            vara?.temIsca = 0
            vara?.lancar()
            Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false, block: { _ in
                self.morder()
            })
        }
    }
    

    ///MARK: Função da interacao do tenxto com a cena
    /*
        - parameters: id do dicionario de texto, nó do texto na cena e scena principal
        - returns: nada
       */
    public func interacaoTexto(_ id:Int){
        switch id {
        case 2:
            texto?.text = dicionarioTextos[2]
            break
        case 3:
            texto?.text = dicionarioTextos[3]
            break
        case 4:
            texto?.text = dicionarioTextos[4]
            //Loop
            
            //Objetos interativos
            self.vara = Vara(self)
            self.addChild(vara!)
            self.rio?.vara = self.vara
            
            
            break
        case 5:
            texto?.text = dicionarioTextos[13]
            break
        case 6:
            texto?.text = dicionarioTextos[14]
            break
        case 7:
            texto?.text = dicionarioTextos[15]
            break
        case 8:
            texto?.text = dicionarioTextos[16]
            break
        default:
            print("Erro na interacao do texto")
        }
    }


}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 800, height: 600))
sceneView.showsPhysics = true

let scene = GameScene(size: CGSize(width: 1366, height: 1024))
scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
// Set the scale mode to scale to fit the window
scene.scaleMode = .aspectFill
//Alterando cor do fundo da cena
scene.backgroundColor = .white
// Present the scene
sceneView.presentScene(scene)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

