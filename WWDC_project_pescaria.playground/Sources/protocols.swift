import Foundation

public protocol ObserverPeixe {
    //Essa propriedade avisa o peixe quando tiver isca para morder
    var temIsca:Int?{get set}
    func morder()
}
