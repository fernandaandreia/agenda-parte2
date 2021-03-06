//
//  Repositorio.swift
//  Agenda
//
//  Created by Fernanda Andreia Nascimento on 28/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class Repositorio: NSObject {
    
    func recuperaAlunos(completion:@escaping (_ listaDeAlunos: Array<Aluno>) -> Void){
        var alunos = AlunoDAO().recuperaAlunos().filter({$0.desativado == false})
        if alunos.count == 0 {
            AlunoAPI().recuperaAlunos{
                alunos = AlunoDAO().recuperaAlunos()
                completion(alunos)
            }
        }
        else {
            completion(alunos)
        }
    }
    func recuperaUltimosAlunos(_ versao: String, completion: @escaping() -> Void) {
        AlunoAPI.recuperaUltimosAlunos(versao)
        completion()
    }
    
    func salvaAluno(aluno: Dictionary<String, Any>){
        var dicionario = aluno
        AlunoDAO().salvaAluno(dicionarioDeAluno: aluno)
        AlunoAPI().salvaAlunosNoServidor(parametros: [aluno]) { (salvo) in
            if salvo {
                self.atualizaAlunoSincronizado(aluno)
            }
        }
    }
    
    func deletaAluno(aluno:Aluno){
        
        guard let id = aluno.id else { return }
        aluno.desativado = true
        AlunoDAO().atualizaContexto()
        AlunoAPI().deletaAluno(id: String(describing: id).lowercased()) { (apagado) in
            if apagado {
                AlunoDAO().deletaAluno(aluno: aluno)
            }
        }
        
    }
    
    func sincronizaAluno(){
      enviaAlunosNaoSincronizados()
        sincronizaAlunosDeletados()
    }
    
    func enviaAlunosNaoSincronizados(){
        let alunos = AlunoDAO().recuperaAlunos().filter({$0.sincronizado == false})
        let listaDeParametros = criaJsonAluno(alunos)
        print("alunos: ")
        print(listaDeParametros)
        AlunoAPI().salvaAlunosNoServidor(parametros: listaDeParametros) { (salvo) in
            for aluno in listaDeParametros {
                self.atualizaAlunoSincronizado(aluno)
            }
            
        }
    }
    
    func sincronizaAlunosDeletados(){
        let alunos = AlunoDAO().recuperaAlunos().filter({ $0.desativado == true })
        for aluno in alunos {
            deletaAluno(aluno: aluno)
        }
        
    }
    
    func criaJsonAluno(_ alunos: Array<Aluno>){
        var listaDeParametros: Array<Dictionary<String, String>> = []
        for aluno in alunos {
            
            guard let id = aluno.id else { return []}
            let parametros:Dictionary<String, String> = [
                "id" : String(describing: id).lowercased(),
                "nome" : aluno.nome ?? "",
                "endereco" : aluno.endereco ?? "",
                "telefone" : aluno.telefone ?? "",
                "site" : aluno.site ?? "",
                "nota" : "\(aluno.nota)"
                
            ]
            listaDeParametros.append(parametros)
        }
        return listaDeParametros
    }
    
    func atualizaAlunoSincronizado(_ aluno:Dictionary<String, Any>){
        var dicionario = aluno
        dicionario["sincronizado"] = true
        AlunoDAO().salvaAluno(dicionarioDeAluno: dicionario)
    }
}
