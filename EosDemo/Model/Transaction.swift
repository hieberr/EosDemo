//
//  Transaction.swift
//  EosDemo
//
//  Contains Data Model objects related to a Transaction in the same hierarchy
//  as is represented in the BlockInfo.Transactions JSON.
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import Foundation
/// Contains Transaction action information.
struct Action {
    struct Data {
        let from: String?
        let to: String?
        let quantity: String?
        let memo: String?
    }
    
    struct Authorization {
        let actor: String
        let permission: String
    }
    
    let account: String
    let name: String
    let authorization: [Action.Authorization]
    let data: Action.Data?
    let hexData: String
}

extension Action : Decodable {
    private enum CodingKeys: String, CodingKey {
        case account = "account"
        case name = "name"
        case authorization = "authorization"
        case data = "data"
        case hexData = "hex_data"
    }
    
    init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        account = try container.decode(String.self, forKey: .account)
        name = try container.decode(String.self, forKey: .name)
        authorization = try container.decode([Action.Authorization].self, forKey: .authorization)
        data = try container.decodeIfPresent(Action.Data.self, forKey: .data)
        hexData = try container.decode(String.self, forKey: .hexData)
    }
}

extension Action.Authorization : Decodable {
    private enum CodingKeys: String, CodingKey {
        case actor = "actor"
        case permission = "permission"
    }
    
    init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        actor = try container.decode(String.self, forKey: .actor)
        permission = try container.decode(String.self, forKey: .permission)
    }
}

extension Action.Data : Decodable {
    private enum CodingKeys: String, CodingKey {
        case from = "from"
        case to = "to"
        case quantity = "quantity"
        case memo = "memo"
    }
    
    init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        self.from = try container.decodeIfPresent(String.self, forKey: .from)
        to = try container.decodeIfPresent(String.self, forKey: .to)
        quantity = try container.decodeIfPresent(String.self, forKey: .quantity)
        memo = try container.decodeIfPresent(String.self, forKey: .memo)
    }
}

/// Contains transaction information.
struct Transaction {
    var expiration: String = ""
    var refBlockNum: Int = 0
    var refBlockPrefix: Int = 0
    var maxNetUsageWords: Int = 0
    var maxCpuUsageMs: Int = 0
    var delaySec: Int = 0
    //let contextFreeActions: [String]
    var actions: [Action] = []
    //let transactionExtensions : [String]
}


extension Transaction : Decodable {
    private enum CodingKeys: String, CodingKey {
        case expiration = "expiration"
        case refBlockNum = "ref_block_num"
        case refBlockPrefix = "ref_block_prefix"
        case maxNetUsageWords = "max_net_usage_words"
        case maxCpuUsageMs = "max_cpu_usage_ms"
        case delaySec = "delay_sec"
        //case contextFreeActions = "context_free_actions"
        case actions = "actions"
        //case transactionExtensions = "transaction_extensions"
    }
    
    init(from: Decoder) throws {
        do {
            let container = try from.container(keyedBy: CodingKeys.self)
            expiration = try container.decode(String.self, forKey: .expiration)
            refBlockNum = try container.decode(Int.self, forKey: .refBlockNum)
            refBlockPrefix = try container.decode(Int.self, forKey: .refBlockPrefix)
            maxNetUsageWords = try container.decode(Int.self, forKey: .maxNetUsageWords)
            maxCpuUsageMs = try container.decode(Int.self, forKey: .maxCpuUsageMs)
            delaySec = try container.decode(Int.self, forKey: .delaySec)
            //contextFreeActions = try container.decode([String].self, forKey: .contextFreeActions)
            actions = try container.decode([Action].self, forKey: .actions)
            //transactionExtensions = try container.decode([String].self, forKey: .transactionExtensions)
        } catch (let error) {
            print("Error while decoding Transaction: " + error.localizedDescription)
        }
    }
}

/// Contains transaction information.
struct Trx {
    let id: String
    let signatures: [String]
    let compression: String
    let packedContextFreeData: String
    //let contextFreeData: [String]
    let packedTrx: String
    let transaction: Transaction
}


extension Trx : Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case signatures = "signatures"
        case compression = "compression"
        case packedContextFreeData = "packed_context_free_data"
        //case contextFreeData = "context_free_data"
        case packedTrx = "packed_trx"
        case transaction = "transaction"
    }
    
    init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        signatures = try container.decode([String].self, forKey: .signatures)
        compression = try container.decode(String.self, forKey: .compression)
        packedContextFreeData = try container.decode(String.self, forKey: .packedContextFreeData)
        //contextFreeData = try container.decode([String].self, forKey: .contextFreeData)
        packedTrx = try container.decode(String.self, forKey: .packedTrx)
        transaction = try container.decode(Transaction.self, forKey: .transaction)
    }
}

/// Contains transaction information.
struct TransactionHeader {
    let status: String
    let cpuUsageUs: Int
    let netUsageWords: Int
    let trx: Trx
}

extension TransactionHeader : Decodable {
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case cpuUsageUs = "cpu_usage_us"
        case netUsageWords = "net_usage_words"
        case trx = "trx"
    }
    
    init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
        cpuUsageUs = try container.decode(Int.self, forKey: .cpuUsageUs)
        netUsageWords = try container.decode(Int.self, forKey: .netUsageWords)
        trx = try container.decode(Trx.self, forKey: .trx)
    }
}
