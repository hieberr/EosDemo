//
//  ChainInfoTests.swift
//  EosDemoTests
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import XCTest

class ChainInfoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_decodeFromJson() {
        var json = """
        {
            "server_version": "b2eb1667",
            "head_block_num": 259590,
            "last_irreversible_block_num": 259573,
            "head_block_id": "0003f60677f3707f0704f16177bf5f007ebd45eb6efbb749fb1c468747f72046",
            "head_block_time": "2017-12-10T17:05:36",
            "head_block_producer": "initp",
            "recent_slots": "1111111111111111111111111111111111111111111111111111111111111111",
            "participation_rate": "1.00000000000000000"
        }
        """
        let request = ChainInfoRequest(url: URL(string:"http://fakeurl.com")!)
        if let result = request.decode(json.data(using: .utf8)!) {
            XCTAssertEqual(result.headBlockId, "0003f60677f3707f0704f16177bf5f007ebd45eb6efbb749fb1c468747f72046")
            XCTAssertEqual(result.headBlockNum, 259590)
        } else {
            XCTAssert(false, "Failed to decode")
        }
        
        // ======= Test invalid json input: ==========
        json = ""
        XCTAssertNil(request.decode(json.data(using: .utf8)!))

        json = """
        {
        "server_version": "b2eb1667",
        "head_block_num": BADDATA
        "last_irreversible_block_num": 259573,
        "head_block_id": "0003f60677f3707f0704f16177bf5f007ebd45eb6efbb749fb1c468747f72046",
        "head_block_time": "2017-12-10T17:05:36",
        "head_block_producer": "initp",
        "recent_slots": "1111111111111111111111111111111111111111111111111111111111111111",
        "participation_rate": "1.00000000000000000"
        }
        """
        XCTAssertNil(request.decode(json.data(using: .utf8)!))
    }
    

    
}
