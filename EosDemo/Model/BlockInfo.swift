//
//  BlockInfo.swift
//  EosDemo
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import Foundation

/// Contains all the information in a block.
struct BlockInfo {
    let timestamp: String
    let producer: String
    let confirmed: Bool
    let previous: String
    let transactionMerckleRoot: String
    let actionMerckleRoot: String
    let scheduleVersion: Int
    let newProducers: [String]? // Not sure what this data would be. Assuming [String] for now.
    //let headerExtensions: [String] // Not sure what this data would be.
    let producerSignature: String
    let transactions: [TransactionHeader] // Not sure what this data would be.
    //let blockExtensions: [String] // Not sure what this data would be.
    let id: String
    let blockNum: Int
    let refBlockPrefix: Int
}

extension BlockInfo : Decodable {
    private enum CodingKeys: String, CodingKey {
        case timestamp = "timestamp"
        case producer = "producer"
        case confirmed = "confirmed"
        case previous = "previous"
        case transactionMerckleRoot = "transaction_mroot"
        case actionMerckleRoot = "action_mroot"
        case scheduleVersion = "schedule_version"
        
        case newProducers = "new_producers"
        //case headerExtensions = "header_extensions"
        case producerSignature = "producer_signature"
        case transactions = "transactions"
        //case blockExtensions = "block_extensions"
        case id = "id"
        case blockNum = "block_num"
        case refBlockPrefix = "ref_block_prefix"
    }
    
    init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        
        timestamp = try container.decode(String.self, forKey: .timestamp)
        producer = try container.decode(String.self, forKey: .producer)
        confirmed = try container.decode(Int.self, forKey: .confirmed) == 1
        previous = try container.decode(String.self, forKey: .previous)
        transactionMerckleRoot = try container.decode(String.self, forKey: .transactionMerckleRoot)
        actionMerckleRoot = try container.decode(String.self, forKey: .actionMerckleRoot)
        scheduleVersion = try container.decode(Int.self, forKey: .scheduleVersion)
        
        let newProducersWasNull = try container.decodeNil(forKey: .newProducers)
        if !newProducersWasNull {
            // I'm not sure what this data would contain. For now, just setting to nil.
            //newProducers = try container.decode([String].self, forKey: .newProducers)
            newProducers = nil
        } else {
            newProducers = nil
        }
        
        //headerExtensions = try container.decode([String].self, forKey: .headerExtensions)
        producerSignature = try container.decode(String.self, forKey: .producerSignature)
        do {
            transactions = try container.decode([TransactionHeader].self, forKey: .transactions)
        } catch (let error) {
            print("Error while decoding TransactionHeader: " + error.localizedDescription)
            transactions = []
        }
        //blockExtensions = try container.decode([String].self, forKey: .blockExtensions)
        id = try container.decode(String.self, forKey: .id)
        blockNum = try container.decode(Int.self, forKey: .blockNum)
        refBlockPrefix = try container.decode(Int.self, forKey: .refBlockPrefix)
    }
}
