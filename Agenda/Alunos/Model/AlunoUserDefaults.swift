//
//  AlunoUserDefaults.swift
//  Agenda
//
//  Created by Fernanda Andreia Nascimento on 30/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class AlunoUserDefaults: NSObject {
    
    let preferencias = UserDefaults.standard
    
    func salvaVersao(_ json:Dictionary<String, Any>) {
        guard let versao = json["momentoDaUltimaModificacao"] as? String else { return }
        preferencias.set(versao, forKey: "ultima-versao")
    }

}
