//
//  ChainInfo.swift
//  EosDemo
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import Foundation

struct ChainInfo {
    let headBlockNum: Int
    let headBlockId: String
}

extension ChainInfo : Decodable {
    private enum CodingKeys: String, CodingKey {
        //case serverVersion = "server_version"
        case headBlockNum = "head_block_num"
        //case lastIrreversibleBlockNum = "last_irreversible_block_num"
        case headBlockId = "head_block_id"
        //case headBlockTime = "head_block_time"
        //case headBlockProducer = "head_block_producer"
        //case recentSlots = "recent_slots"
        //case participationRate = "participation_rate"
    }
    
    init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        let headBlockNum = try container.decode(Int.self, forKey: .headBlockNum)
        let headBlockId = try container.decode(String.self, forKey: .headBlockId)
        self.init(headBlockNum: headBlockNum, headBlockId: headBlockId)
    }
}
