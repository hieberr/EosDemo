//
//  BlockInfoTests.swift
//  EosDemoTests
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import XCTest

class BlockInfoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_blockInfoDecodeFromJson() {
        var json = """
        {
            "timestamp":"2018-07-16T19:54:35.500",
            "producer":"eosbixinboot",
            "confirmed":0,
            "previous":"005f1de277ee9bc9d887a563322785c2d0fa2d4aab05ccd655ec9cb64aa47db3",
            "transaction_mroot":"0000000000000000000000000000000000000000000000000000000000000000",
            "action_mroot":"ac64b1e98542dabd1c9df403fce53624c89bc3b578f0829b4c770d3d0865b3ae",
            "schedule_version":143,
            "new_producers":null,
            "header_extensions":[],
            "producer_signature":"SIG_K1_K8RznJ1wvai1tN9wPvw2KARX9SVRy1ezkCswXqesj4rXsDdnMrU1P2j6cJU6HP7SNRrMto683UNQwqmx7UjV6467jgay7H",
            "transactions":[],
            "block_extensions":[],
            "id":"005f1de30773f13c663738d2fb73a652a5a0e97622bef21a4eb741d6de6e3e52",
            "block_num":6233571,
            "ref_block_prefix":3526899558
        }
        """.data(using: .utf8)!
        if let result = try?JSONDecoder().decode(BlockInfo.self, from: json) {
            XCTAssertEqual(result.timestamp, "2018-07-16T19:54:35.500")
            XCTAssertEqual(result.producer, "eosbixinboot")
            XCTAssertEqual(result.confirmed, false)
            XCTAssertEqual(result.previous, "005f1de277ee9bc9d887a563322785c2d0fa2d4aab05ccd655ec9cb64aa47db3")
            XCTAssertEqual(result.transactionMerckleRoot, "0000000000000000000000000000000000000000000000000000000000000000")
            XCTAssertEqual(result.actionMerckleRoot, "ac64b1e98542dabd1c9df403fce53624c89bc3b578f0829b4c770d3d0865b3ae")
            XCTAssertEqual(result.scheduleVersion, 143)
            XCTAssertNil(result.newProducers)
            XCTAssertEqual(result.headerExtensions.count, 0)
            XCTAssertEqual(result.producerSignature, "SIG_K1_K8RznJ1wvai1tN9wPvw2KARX9SVRy1ezkCswXqesj4rXsDdnMrU1P2j6cJU6HP7SNRrMto683UNQwqmx7UjV6467jgay7H")
            XCTAssertEqual(result.transactions.count, 0)
            XCTAssertEqual(result.id, "005f1de30773f13c663738d2fb73a652a5a0e97622bef21a4eb741d6de6e3e52")
            XCTAssertEqual(result.blockNum, 6233571)
            XCTAssertEqual(result.refBlockPrefix, 3526899558)
        } else {
            XCTAssert(false, "Failed to decode")
        }
        
        // ======= Test invalid json input: ==========
        json = "".data(using: .utf8)!
        XCTAssertNil(try?JSONDecoder().decode(BlockInfo.self, from: json))

        json = """
        {
        "timestamp":"2018-07-16T19:54:35.500",
        "producer":"eosbixinboot",
        "confirmed":0,
        "previous": BADDATA,
        "transaction_mroot":"0000000000000000000000000000000000000000000000000000000000000000",
        "action_mroot":"ac64b1e98542dabd1c9df403fce53624c89bc3b578f0829b4c770d3d0865b3ae",
        "schedule_version":143,
        "new_producers":null,
        "header_extensions":[],
        "producer_signature":"SIG_K1_K8RznJ1wvai1tN9wPvw2KARX9SVRy1ezkCswXqesj4rXsDdnMrU1P2j6cJU6HP7SNRrMto683UNQwqmx7UjV6467jgay7H",
        "transactions":[],
        "block_extensions":[],
        "id":"005f1de30773f13c663738d2fb73a652a5a0e97622bef21a4eb741d6de6e3e52",
        "block_num":6233571,
        "ref_block_prefix":3526899558
        }
        """.data(using: .utf8)!
        XCTAssertNil(try?JSONDecoder().decode(BlockInfo.self, from: json))
    }
}
