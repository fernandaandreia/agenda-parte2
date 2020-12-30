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
        
        Alamofire.request(url + "api/firebase/dispositivo", method: .post, headers: ["token":token]).responseData
    }
    
    func serializaMensagem(mensagem: MessaginRemoteMessage){
        guard let respostaDoFirebase = mensagem.appData["alunoSync"] else {return}
        guard let data = respostaDoFirebase.data(using: .utf8) else { return }
        
        do {
            guard let mensagem = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> else { return }
            guard let listaDeAlunos = mensagem["alunos"] as? Array<Dictionary<String, Any>> else { return }
                
            sincronizaAlunos(alunos: listaDeAlunos)
            NotificationCenter.default.post(name: NSNotification.Name("atualizaAlunos"), object: nil)
            
        } catch {
            print (error.localizedDescription)
        }
    }
    
    func sincronizaAlunos(alunos: Array<[String:Any]>){
    for aluno in alunos {
        AlunoDAO().salvaAluno(dicionarioDeAluno: aluno)
    }
    }
}
