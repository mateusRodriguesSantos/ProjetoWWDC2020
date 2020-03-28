//
import Foundation
import PlaygroundSupport
import GameplayKit
import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate,ObserverPeixe {
    
    var timer:Timer?
    var timeLeft = 180
    var timeLabel:SKLabelNode?
    
    var contadorTexto = Int()
    var texto:SKLabelNode?
    var primeiraPesca:Int? // Ajuda verificar se é a primeira pesca sendo feita
    
    public var itemSorteado = Int()// o pescado sorteado
    public var pescados = [String]()//os itens pescados
    
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
        primeiraPesca = 2//comeca com dois para nao fazer a pesca na primeeira vez que passar pelo touchesBegan
        self.rio = Rio(self)
        self.addChild(rio!)
    }
    
    func timerDisplay()
    {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.timeLeft = self.timeLeft - 1
            if self.timeLeft <= 180{
                let tempoExibir = 60 - (180 - self.timeLeft)
                self.timeLabel!.text = "2:\(tempoExibir)"
            }else if self.timeLeft <= 120{
                let tempoExibir = 60 - (120 - self.timeLeft)
                self.timeLabel!.text = "1:\(tempoExibir)"
            }else if self.timeLeft <= 60{
                let tempoExibir = 60 - (60 - self.timeLeft)
                self.timeLabel!.text = "0:\(tempoExibir)"
            }

            if self.timeLeft <= -1  {
                self.timer!.invalidate()
                self.timer = nil
            }
        })
    }
    
    func sorteioPescado(){
        //Sortear o item da pesca aqui
        if let num = dicionarioTextosPescados.randomElement()?.key{
            self.itemSorteado = num
        }
        print(self.itemSorteado)
        self.pescados.append(dicionarioTextosPescados[self.itemSorteado]!)
        texto?.text = "\(dicionarioTextosPescados[itemSorteado] ?? "erro")"
        texto?.isHidden = true
        //
    }

    func morder() {

        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false, block: { _ in
            if self.vara?.estado == "esperando"{
                self.texto?.text = dicionarioTextos[6]
                self.vara?.temIsca = 1
                self.rio?.alterarEstadoVara(self.vara!)
                self.sorteioPescado()
            }
        })
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.vara?.hasActions() == false{
            self.texto?.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Soma mais um ao contador do texto e muda o texto se preciso, até ser 4
        if contadorTexto < 4 || primeiraPesca == 2 || primeiraPesca == 1{
            if primeiraPesca == 2{//Se estiver na primeira pesca, entao acrescenta a vara e acrescenta mais um ao contador do texto
                contadorTexto = contadorTexto + 1
                interacaoTexto(contadorTexto)
            }else if primeiraPesca == 1{//se for a segunda pesca ele transforma o primeira pesca em 0
                primeiraPesca = 0
            }
        }
        
        //Verifica se pode lancar a vara
        if vara?.estado == "neutro" && contadorTexto == 4 && primeiraPesca == 0{
            vara?.temIsca = 0
            vara?.lancar()
            self.morder()
            self.texto?.text = dicionarioTextos[5]
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
            timerDisplay()
            timeLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
            timeLabel?.fontColor = .black
            timeLabel?.fontSize = CGFloat(50)
            timeLabel?.text =  """
            Dia
            3:00
            """
            timeLabel?.zPosition = 3
            timeLabel?.position = CGPoint(x: self.size.width*(0.35), y:self.size.height*(0.4))
            timeLabel?.horizontalAlignmentMode = .center
            self.addChild(timeLabel!)
            
            texto?.text = dicionarioTextos[4]
            self.vara = Vara(self)
            self.addChild(vara!)
            self.rio?.vara = self.vara
            primeiraPesca = 1
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

