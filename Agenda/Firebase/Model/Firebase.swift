//
//  Firebase.swift
//  Agenda
//
//  Created by Fernanda Andreia Nascimento on 30/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import Alamofire

class Firebase: NSObject {

    
    func enviaTokenParaServidor(token:String){
        
        guard let url = Configuracao().getUrlPadrao() else { return }
//        print(dicionario)
        
        Alamofire.request(url + "api/firebase/dispositivo", method: .post, headers: ["token":token]).responseData { (response) in
            if response.error == nil {
                print("Token enviado com sucesso")
            }
            else{
                print("Error:-----")
                print(response.error!)
            }
        }
    }
}
