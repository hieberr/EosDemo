//
//  RequestTests.swift
//  EosDemoTests
//
//  Created by floatingpoint on 7/16/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import XCTest

class RequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Test actually fetching the chain info from the network.
    func test_fetchChainInfo() {
        let expectation = self.expectation(description: "received response")
        
        let request = ChainInfoRequest(url: URL(string: "https://api.eosnewyork.io/v1/chain/get_info")!)
        request.load(withCompletion: { info in
            expectation.fulfill()
            if let info = info {
                XCTAssertNotEqual(info.headBlockId, "")
                XCTAssertNotEqual(info.headBlockNum, 0)
            } else {
                XCTAssert(false, "Couldn't retrieve the data.")
            }
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    /// Test actually fetching info for a block from the network
    func test_fetchBlockInfo() {
        let expectation = self.expectation(description: "received response")
        
        let blockId = "005f5746996fb8385ba88be4a992bedf882845640d8064b2b63f98867d83b9ad"
        let request = BlockInfoRequest(url: URL(string: "https://api.eosnewyork.io/v1/chain/get_block")!, blockId: blockId)
        request.load(withCompletion: { info in
            expectation.fulfill()
            if let info = info {
                // Make sure we got some valid data.
                XCTAssertEqual(info.id, blockId)
                XCTAssertNotEqual(info.timestamp, "")
            } else {
                XCTAssert(false, "Couldn't retrieve the data.")
            }
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
