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
        Alamofire.request("http://localhost:8080/api/firebase/dispositivo", method: .post, headers: ["token":token]).responseData { (response) in
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
