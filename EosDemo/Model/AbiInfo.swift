//
//  AbiInfo.swift
//  EosDemo
//
//  Created by floatingpoint on 7/17/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import Foundation


/// Contains Abi Action information.
struct AbiAction {
    let ricardianContract: String
    func render(with: Action, transactionDelay: Int) -> String {
        var rendered = ricardianContract
        guard let d = with.data else {
            return rendered
        }
        if let from = d.from {
            rendered = rendered.replacingOccurrences(of: "{{from}}", with: from)
        }
        if let to = d.to {
            rendered = rendered.replacingOccurrences(of: "{{to}}", with: to)
        }
        if let quantity = d.quantity {
            rendered = rendered.replacingOccurrences(of: "{{quantity}}", with: quantity)
        }
        if let memo = d.memo {
            rendered = rendered.replacingOccurrences(of: "{{memo}}", with: memo)
        }
        
        rendered = rendered.replacingOccurrences(of: "{{transaction.delay}}", with: String(transactionDelay))
        return rendered
    }
}

extension AbiAction : Decodable {
    private enum CodingKeys: String, CodingKey {
        case ricardianContract = "ricardian_contract"
    }
    
    init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        ricardianContract = try container.decode(String.self, forKey: .ricardianContract)
    }
}

// Contains Abi info returned from get_abi RPC. 
struct AbiInfo {
    let actions: [AbiAction]
}

extension AbiInfo : Decodable {
    private enum AbiInfoKeys: String, CodingKey {
        case abi = "abi"
    }
    private enum AbiKeys: String, CodingKey {
        case actions = "actions"
    }
    
    init(from: Decoder) throws {
        let abiInfoContainer = try from.container(keyedBy: AbiInfoKeys.self)
        let abiContainer = try abiInfoContainer.nestedContainer(keyedBy: AbiKeys.self, forKey: .abi)
        
        actions = try abiContainer.decode([AbiAction].self, forKey: .actions)
    }
}
