/*:
 A PESCARIA DA VIDA
  
 Essa é uma cena interativa com SpriteKit que usa a pescaria para trazer uma mensagem reflexiva sobre o estresse dos dias atuais. Fazer isso usa um storytelling simples e claro. Nessa história o usuário vai interagir com a vara de pesca e de um lago, irá pescar experiências boas ou ruins da vida. No final ele terá a experiência de entender o porque de pescar as experiências e qual era o objetivo disso. A mensagem central é: “Ter paciência sempre, para enfrentar os momentos bons ou ruins”.
   
  Como interagir?
  
  Apenas toque na tela com taps, um de cada vez

 */

import Foundation
import PlaygroundSupport
import GameplayKit
import SpriteKit
import UIKit

class GameScene: SKScene,ObserverPeixe,UITableViewDataSource,UITableViewDelegate {
    
    ///Classe da tableView
    var table:UITableView?
    ///Imagem que fica atrás da tableView
    var imagemTable:SKSpriteNode?
    
    ///Classe do time
    var timer:Timer?
    ///Tempo do time
    var timeLeft = 60
    ///Label do time
    var timeLabel:SKLabelNode?
    
    ///Controla quais os textos que podem ser exibidos, ela é manipulada no interacaoTexto(_id: Int)
    var contadorTexto = Int()
    ///Label das mensagens do usuário
    var texto:SKLabelNode?
    ///Ajuda verificar se é a primeira pesca sendo feita
    var primeiraPesca:Int?
    
    ///O pescado sorteado
    public var itemSorteado = Int()
    ///Os itens pescados
    public var pescados = [String]()
    
    ///Diz a classe vara que é permitido lançar a varinha
    var temIsca: Int?
    
    ///Fundo da paisagem
    var background:SKSpriteNode?
    ///Classe rio
    var rio: Rio?
    ///Classe vara
    var vara: Vara?
    ///Setinha indicando que é necessário tocar na tela para passar
    var seta = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        //MARK: Fundo
            background = SKSpriteNode(imageNamed: "background")
            background?.zPosition = 1.8
            background?.position = CGPoint.zero
            self.addChild(background!)
            
        //MARK: Adicionando texto inicial
            contadorTexto = 1
        
        //MARK: Adicao da label das mensagens ao usuário
            texto = SKLabelNode(fontNamed: "SF Pro Rounded")
            texto?.fontColor = .black
            texto?.fontSize = CGFloat(30)
            texto?.text = dicionarioTextos[1]
            texto?.numberOfLines = 2
            texto?.zPosition = 3.1
            texto?.position = CGPoint(x: 0, y: self.size.height*(0.28))
            self.addChild(texto!)
        //
        
        //MARK: Adicao da imagem que ficará atrás da label das mensagens ao usuário
            let caixaTexto = SKSpriteNode(imageNamed: "caixaDeTexto")
            caixaTexto.position = CGPoint(x: 0, y: self.size.height*(0.32))
            caixaTexto.zPosition = 3
            self.addChild(caixaTexto)
        //
        
        //MARK: Adicao da seta que ficará no canto direito da caixa de texto
            let setaTap = SKSpriteNode(imageNamed: "seta")
            setaTap.position = CGPoint(x: self.size.width*(0.4), y: self.size.height*(0.27))
            setaTap.zPosition = 3
            self.addChild(setaTap)
            self.seta = setaTap
                ///Animacoes da seta - Piscar
                let animationSeta2 = SKAction.fadeAlpha(to: CGFloat(1), duration: 0.5)
                let animationSeta1 = SKAction.fadeAlpha(to: CGFloat(0), duration: 0.5)
                let animacoesSeta = SKAction.sequence([animationSeta2,animationSeta1])
                let animacao = SKAction.repeatForever(animacoesSeta)
                setaTap.run(animacao)
       //

        //MARK: Adicionando rio
            primeiraPesca = 2//comeca com dois para nao fazer a pesca na primeeira vez que passar pelo touchesBegan
            self.rio = Rio(self)
            self.addChild(rio!)
        //
    }
    
    ///Configuraçao do timer
    func timerDisplay()
    {
        self.timer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true, block: { _ in
            
            self.timeLeft = self.timeLeft - 1
            
            if self.timeLeft <= 60{
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
    
    ///Sorteio do item retirado na pesca
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
    
    ///Reliza um ciclo de pesca de um objeto
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
    
    ///Verifica se existe alguma animacao da vara para poder apresentar o texto, caso falso
    override func update(_ currentTime: TimeInterval) {
        if self.vara?.hasActions() == false{
            self.texto?.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //MARK: Soma mais um ao contador do texto e muda o texto se preciso, até ser 4
        if contadorTexto < 4 || primeiraPesca == 2 || primeiraPesca == 1{
            if primeiraPesca == 2{//Se estiver na primeira pesca, entao acrescenta a vara e acrescenta mais um ao contador do texto
                contadorTexto = contadorTexto + 1
                interacaoTexto(contadorTexto)
            }else if primeiraPesca == 1{//se for a segunda pesca ele transforma o primeira pesca em 0
                primeiraPesca = 0
            }
        }
        
        //MARK: Quando o time do dia acaba essa condicao pode ser acessada
        if contadorTexto >= 5 {
            contadorTexto = contadorTexto + 1
            interacaoTexto(contadorTexto)
        }
        
        //MARK: Verifica se pode lancar a vara
        if vara?.estado == "neutro" && contadorTexto == 4 && primeiraPesca == 0{
            vara?.temIsca = 0
            vara?.lancar()
            self.morder()
            self.texto?.text = dicionarioTextos[5]
        }
    }
    

    ///Função da interacao do tenxto com a cena
    ///Parameters: id do dicionario de texto, nó do texto na cena e scena principal
    ///Returns:  nada
    public func interacaoTexto(_ id:Int){
        switch id {
        case 2:
            //Define qual o texto atual na tela
            texto?.text = dicionarioTextos[2]
            break
        case 3:
            texto?.text = dicionarioTextos[3]
            break
        case 4:
            //MARK: Criando o time
            timerDisplay()
            
            //MARK: Criando o timer
                timeLabel = SKLabelNode(fontNamed: "SF Compact Rounded")
                timeLabel?.fontColor = .black
                timeLabel?.fontSize = CGFloat(30)
                timeLabel?.text =  "Dia: 01:00"
                timeLabel?.numberOfLines = 2
                timeLabel?.zPosition = 3
                timeLabel?.position = CGPoint(x: self.size.width*(0.23), y:self.size.height*(-0.30))
                timeLabel?.horizontalAlignmentMode = .center
                self.addChild(timeLabel!)
                let caixaTextoDia = SKSpriteNode(imageNamed: "caixaTextoDia")
                caixaTextoDia.position = CGPoint(x: self.size.width*(0.23), y:self.size.height*(-0.28))
                caixaTextoDia.zPosition = 3
                self.addChild(caixaTextoDia)
            //
            
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
            //MARK: Criando tableView
            let imagemBackgroundTable = SKSpriteNode(imageNamed: "tabela")
            imagemBackgroundTable.position = CGPoint.zero
            imagemBackgroundTable.zPosition = 10
            self.imagemTable = imagemBackgroundTable
            self.addChild(imagemBackgroundTable)
            
            let tableView = UITableView()
            tableView.frame = CGRect(x: (self.view?.frame.width)!*(0.33), y: (self.view?.frame.height)!*(0.40), width: 200, height: 100)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = .clear
            tableView.separatorColor = .clear
            tableView.isUserInteractionEnabled = false
            table = tableView
            self.view!.addSubview(tableView)
            //
            
            break
        case 7:
            //MARK: Retira a table da tela
                self.imagemTable?.removeFromParent()
                self.table?.removeFromSuperview()
            //
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
    //MARK: Configuracao da celulas
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


let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
//sceneView.showsPhysics = true
//sceneView.showsFPS = true

let scene = GameScene(size: CGSize(width: 1024, height: 768))
scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
// Set the scale mode to scale to fit the window
scene.scaleMode = .aspectFit
//Alterando cor do fundo da cena
scene.backgroundColor = .clear
// Present the scene
sceneView.presentScene(scene)


PlaygroundPage.current.needsIndefiniteExecution = false
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
PlaygroundSupport.PlaygroundPage.finishExecution(PlaygroundSupport.PlaygroundPage.current)

