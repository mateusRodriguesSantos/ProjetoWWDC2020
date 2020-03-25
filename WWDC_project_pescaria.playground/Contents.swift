//
import PlaygroundSupport
import GameplayKit
import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
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


        //Objetos interativos
        vara = Vara(self)
        self.addChild(vara!)
        rio = Rio(self)
        self.addChild(rio!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        vara?.lancar()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
