//
//  TransactionTests.swift
//  EosDemoTests
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import XCTest

class TransactionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTransactionHeaderDecodeFromJson() {
        var json = """
        {
            "status":"executed",
            "cpu_usage_us":996,
            "net_usage_words":17,
            "trx":{
                "id":"9d076f0a7e6e6170913dfcce942ab7de4282bc4fd129a0b65577204e2fd31082",
                "signatures":["SIG_K1_KdskWyhfzmo3ENsgH9vxKzGPKgZvz1c9wcc1sRhj28X8hYYZ6Udf2JyMULp2981dXwHgaqmQnYQHfNV1WmbGxWRYTU6vQ8"],
                "compression":"none",
                "packed_context_free_data":"",
                "context_free_data":[],
            "packed_trx":"aef84c5b8a1cd9bcaa38000000000100a6823403ea3055000000572d3ccdcd0110aa4a5d4db7b23b00000000a8ed32322a10aa4a5d4db7b23b80a98a48a169a63b00794e010000000004454f53000000000931303237353132353800",
                "transaction":{
                    "expiration":"2018-07-16T19:57:34",
                    "ref_block_num":7306,
                    "ref_block_prefix":950713561,
                    "max_net_usage_words":0,
                    "max_cpu_usage_ms":0,
                    "delay_sec":0,
                    "context_free_actions":[],
                    "actions":[],
                    "transaction_extensions":[]
                }
            }
        }
        """.data(using: .utf8)!
        if let result = try?JSONDecoder().decode(TransactionHeader.self, from: json) {
            XCTAssertEqual(result.status, "executed")
            XCTAssertEqual(result.cpuUsageUs, 996)
            XCTAssertEqual(result.netUsageWords, 17)
            
            XCTAssertEqual(result.trx.id, "9d076f0a7e6e6170913dfcce942ab7de4282bc4fd129a0b65577204e2fd31082")
            XCTAssertEqual(result.trx.signatures.count,  1)
            XCTAssertEqual(result.trx.signatures[0], "SIG_K1_KdskWyhfzmo3ENsgH9vxKzGPKgZvz1c9wcc1sRhj28X8hYYZ6Udf2JyMULp2981dXwHgaqmQnYQHfNV1WmbGxWRYTU6vQ8")
            XCTAssertEqual(result.trx.compression, "none")
            XCTAssertEqual(result.trx.packedContextFreeData, "")
            XCTAssertEqual(result.trx.contextFreeData.count, 0)
            XCTAssertEqual(result.trx.packedTrx, "aef84c5b8a1cd9bcaa38000000000100a6823403ea3055000000572d3ccdcd0110aa4a5d4db7b23b00000000a8ed32322a10aa4a5d4db7b23b80a98a48a169a63b00794e010000000004454f53000000000931303237353132353800")

            XCTAssertEqual(result.trx.transaction.expiration, "2018-07-16T19:57:34")
            XCTAssertEqual(result.trx.transaction.refBlockNum, 7306)
            XCTAssertEqual(result.trx.transaction.refBlockPrefix, 950713561)
            XCTAssertEqual(result.trx.transaction.maxNetUsageWords, 0)
            XCTAssertEqual(result.trx.transaction.maxCpuUsageMs, 0)
            XCTAssertEqual(result.trx.transaction.delaySec, 0)
            XCTAssertEqual(result.trx.transaction.contextFreeActions.count, 0)
            XCTAssertEqual(result.trx.transaction.actions.count, 0)
            XCTAssertEqual(result.trx.transaction.transactionExtensions.count, 0)
        } else {
            XCTAssert(false, "Failed to decode")
        }
        
        // ======= Test invalid json input: ==========
        json = "".data(using: .utf8)!
        XCTAssertNil(try?JSONDecoder().decode(TransactionHeader.self, from: json))
        
        json = """
        {
            "status":BADDATA,
            "cpu_usage_us":996,
            "net_usage_words":17,
            "trx":{
                "id":"9d076f0a7e6e6170913dfcce942ab7de4282bc4fd129a0b65577204e2fd31082",
                "signatures":["SIG_K1_KdskWyhfzmo3ENsgH9vxKzGPKgZvz1c9wcc1sRhj28X8hYYZ6Udf2JyMULp2981dXwHgaqmQnYQHfNV1WmbGxWRYTU6vQ8"],
                "compression":"none",
                "packed_context_free_data":"",
                "context_free_data":[],
            "packed_trx":"aef84c5b8a1cd9bcaa38000000000100a6823403ea3055000000572d3ccdcd0110aa4a5d4db7b23b00000000a8ed32322a10aa4a5d4db7b23b80a98a48a169a63b00794e010000000004454f53000000000931303237353132353800",
                "transaction":{
                    "expiration":"2018-07-16T19:57:34",
                    "ref_block_num":7306,
                    "ref_block_prefix":950713561,
                    "max_net_usage_words":0,
                    "max_cpu_usage_ms":0,
                    "delay_sec":0,
                    "context_free_actions":[],
                    "actions":[],
                    "transaction_extensions":[]
                }
            }
        }
        """.data(using: .utf8)!
        XCTAssertNil(try?JSONDecoder().decode(TransactionHeader.self, from: json))
    }
 
    // TODO: add test for Transaction.Action
    // TODO: add test for Transaction.Authorization
}
