import Foundation
import PlaygroundSupport
import GameplayKit
import SpriteKit
import UIKit

class GameScene: SKScene,SKPhysicsContactDelegate,ObserverPeixe,UITableViewDataSource,UITableViewDelegate {
    
    var table:UITableView?
    var imagemTable:SKSpriteNode?
    
    var timer:Timer?
    var timeLeft = /*120*/10
    var timeLabel:SKLabelNode?
    
    var contadorTexto = Int()
    var texto:SKLabelNode?
    var primeiraPesca:Int? // Ajuda verificar se é a primeira pesca sendo feita
    
    public var itemSorteado = Int()// o pescado sorteado
    public var pescados = [String]()//os itens pescados
    
    var temIsca: Int?
    var background:SKSpriteNode?
    var rio: Rio?
    var vara: Vara?
    var seta = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        //Fundo
        background = SKSpriteNode(imageNamed: "background")
        background?.zPosition = 1.8
        background?.position = CGPoint.zero
        self.addChild(background!)
        
        //Adicionando texto inicial
        contadorTexto = 1
        
        texto = SKLabelNode(fontNamed: "SF Pro Rounded")
        texto?.fontColor = .black
        texto?.fontSize = CGFloat(30)
        texto?.text = dicionarioTextos[1]
        texto?.numberOfLines = 2
        texto?.zPosition = 3.1
        texto?.position = CGPoint(x: 0, y: self.size.height*(0.3))
        self.addChild(texto!)
        
        let caixaTexto = SKSpriteNode(imageNamed: "caixaDeTexto")
        caixaTexto.position = CGPoint(x: 0, y: self.size.height*(0.32))
        caixaTexto.zPosition = 3
        self.addChild(caixaTexto)
        
        let setaTap = SKSpriteNode(imageNamed: "seta")
        setaTap.position = CGPoint(x: self.size.width*(0.4), y: self.size.height*(0.27))
        setaTap.zPosition = 3
        self.addChild(setaTap)
        
        self.seta = setaTap
        
        let animationSeta2 = SKAction.fadeAlpha(to: CGFloat(1), duration: 0.5)
        let animationSeta1 = SKAction.fadeAlpha(to: CGFloat(0), duration: 0.5)
        
        let animacoesSeta = SKAction.sequence([animationSeta2,animationSeta1])
        
        let animacao = SKAction.repeatForever(animacoesSeta)
        
        setaTap.run(animacao)
       

        //Adicionando rio
        primeiraPesca = 2//comeca com dois para nao fazer a pesca na primeeira vez que passar pelo touchesBegan
        self.rio = Rio(self)
        self.addChild(rio!)
    }
    
    func timerDisplay()
    {
        self.timer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true, block: { _ in
            self.timeLeft = self.timeLeft - 1
            if self.timeLeft <= 120 && self.timeLeft > 60{
                let tempoExibir = 60 - (120 - self.timeLeft)
                self.timeLabel!.text = "Dia: 01:\(tempoExibir)"
            }else if self.timeLeft <= 60{
                let tempoExibir = 60 - (60 - self.timeLeft)
                self.timeLabel!.text = "Dia: 00:\(tempoExibir)"
            }

            if self.timeLeft <= 0  {
                self.timer!.invalidate()
                self.timer = nil
                self.removeAllActions()
                self.contadorTexto = self.contadorTexto + 1
                self.interacaoTexto(self.contadorTexto)
            }
        })
    }
    
    func sorteioPescado(){
        //Sortear o item da pesca aqui
        if let num = dicionarioTextosPescados.randomElement()?.key{
            self.itemSorteado = num
        }
        self.pescados.append(dicionarioTextosPescados[self.itemSorteado]!)
        texto?.text = "\(dicionarioTextosPescados[itemSorteado] ?? "erro")"
        texto?.isHidden = true
        //
    }

    func morder() {
        self.seta.isHidden = true
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false, block: { _ in
            if self.vara?.estado == "esperando"{
                self.texto?.text = dicionarioTextos[6]
                self.vara?.temIsca = 1
                self.rio?.alterarEstadoVara(self.vara!)
                self.sorteioPescado()
                
                self.seta.isHidden = false
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
        
        //Quando o time do dia acaba essa condicao pode ser acessada
        if contadorTexto >= 5 {
            contadorTexto = contadorTexto + 1
            interacaoTexto(contadorTexto)
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
            timeLabel?.fontSize = CGFloat(30)
            timeLabel?.text =  "Dia: 02:00"
            timeLabel?.numberOfLines = 2
            timeLabel?.zPosition = 3
            timeLabel?.position = CGPoint(x: self.size.width*(0.23), y:self.size.height*(-0.30))
            timeLabel?.horizontalAlignmentMode = .center
            self.addChild(timeLabel!)
            let caixaTextoDia = SKSpriteNode(imageNamed: "caixaTextoDia")
            caixaTextoDia.position = CGPoint(x: self.size.width*(0.23), y:self.size.height*(-0.28))
            caixaTextoDia.zPosition = 3
            self.addChild(caixaTextoDia)
            
            texto?.text = dicionarioTextos[4]
            self.vara = Vara(self)
            self.addChild(vara!)
            self.rio?.vara = self.vara
            primeiraPesca = 1
            break
        case 5:
            texto?.text = dicionarioTextos[11]
            break
        case 6:
            //Criando tableView
            let imagemBackgroundTable = SKSpriteNode(imageNamed: "tabela")
            imagemBackgroundTable.position = CGPoint.zero
            imagemBackgroundTable.zPosition = 10
            self.imagemTable = imagemBackgroundTable
            self.addChild(imagemBackgroundTable)

            let tableView = UITableView()
            /*512 355*/
            tableView.frame = CGRect(x: (self.view?.frame.width)!*(0.33), y: (self.view?.frame.height)!*(0.40), width: 200, height: 100)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = .clear
            tableView.separatorColor = .clear
            table = tableView
            self.view!.addSubview(tableView)

            break
        case 7:
            self.imagemTable?.removeFromParent()
            self.table?.removeFromSuperview()
           texto?.text = dicionarioTextos[12]
           break
        case 8:
            texto?.text = dicionarioTextos[13]
            break
        case 9:
            texto?.text = dicionarioTextos[14]
            break
        case 10:
            texto?.text = dicionarioTextos[15]
            break
        case 11:
            texto?.text = dicionarioTextos[16]
        break
        default:
            print("Erro na interacao do texto")
        }
    }
}

extension GameScene{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pescados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        cell.backgroundColor = .clear
        cell.textLabel?.textAlignment = .center
        cell.textLabel!.text = pescados[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
}

public class ViewTable:UIView{
    
}


// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
sceneView.showsPhysics = true
sceneView.showsFPS = true

let scene = GameScene(size: CGSize(width: 1024, height: 768))
scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
// Set the scale mode to scale to fit the window
scene.scaleMode = .aspectFill
//Alterando cor do fundo da cena
scene.backgroundColor = .white
// Present the scene
sceneView.presentScene(scene)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

