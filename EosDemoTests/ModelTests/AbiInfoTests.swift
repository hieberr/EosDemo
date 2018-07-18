//
//  AbiInfoTests.swift
//  EosDemoTests
//
//  Created by floatingpoint on 7/17/18.
//  Copyright © 2018 HologramPacific. All rights reserved.
//

import XCTest

class AbiInfoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_decodeAbiInfo() {
        var json = """
        {
            "account_name":"eosio.token",
            "abi":
            {
                "version":"eosio::abi/1.0",
                "types":[{"new_type_name":"account_name","type":"name"}],
                "structs":[
                    {
                        "name":"transfer",
                        "base":"","fields":[
                            {"name":"from","type":"account_name"},
                            {"name":"to","type":"account_name"},
                            {"name":"quantity","type":"asset"},
                            {"name":"memo","type":"string"}
                        ]
                    },
                    {
                        "name":"create",
                        "base":"","fields":[
                            {"name":"issuer","type":"account_name"},
                            {"name":"maximum_supply","type":"asset"}
                        ]
                    },
                    {
                        "name":"issue","base":"",
                        "fields":[
                            {"name":"to","type":"account_name"},{"name":"quantity","type":"asset"},
                            {"name":"memo","type":"string"}
                        ]
                    },
                    {"name":"account","base":"",
                    "fields":[{"name":"balance","type":"asset"}]},
                    {"name":"currency_stats",
                    "base":"",
                    "fields":[{"name":"supply","type":"asset"},
                    {"name":"max_supply","type":"asset"},
                    {"name":"issuer",
                    "type":"account_name"}]}
                ],
                "actions":[
                    {
                        "name":"transfer",
                        "type":"transfer",
                        "ricardian_contract":"## Transfer Terms & Conditions I, {{from}}, certify the following to be true to the best of my knowledge: 1. I certify that {{quantity}} is not the proceeds of fraudulent or violent activities. 2. I certify that, to the best of my knowledge, {{to}} is not supporting initiation of violence against others. 3. I have disclosed any contractual terms & conditions with respect to {{quantity}} to {{to}}. I understand that funds transfers are not reversible after the {{transaction.delay}} seconds or other delay as configured by {{from}}'s permissions. If this action fails to be irreversibly confirmed after receiving goods or services from '{{to}}', I agree to either return the goods or services or resend {{quantity}} in a timely manner. "
                    },
                    {"name":"issue","type":"issue","ricardian_contract":""},
                    {
                        "name":"create",
                        "type":"create",
                        "ricardian_contract":""
                    }
                ],
                "tables":[{"name":"accounts",
                "index_type":"i64",
                "key_names":["currency"],
                "key_types":["uint64"],
                "type":"account"},
                {"name":"stat",
                "index_type":"i64",
                "key_names":["currency"],
                "key_types":["uint64"],
                "type":"currency_stats"}],
                "ricardian_clauses":[],
                "error_messages":[],
                "abi_extensions":[]
            }
        }
        """.data(using: .utf8)!

        let expectedContract = "## Transfer Terms & Conditions I, {{from}}, certify the following to be true to the best of my knowledge: 1. I certify that {{quantity}} is not the proceeds of fraudulent or violent activities. 2. I certify that, to the best of my knowledge, {{to}} is not supporting initiation of violence against others. 3. I have disclosed any contractual terms & conditions with respect to {{quantity}} to {{to}}. I understand that funds transfers are not reversible after the {{transaction.delay}} seconds or other delay as configured by {{from}}'s permissions. If this action fails to be irreversibly confirmed after receiving goods or services from '{{to}}', I agree to either return the goods or services or resend {{quantity}} in a timely manner. "
        if let result = try?JSONDecoder().decode(AbiInfo.self, from: json) {
            XCTAssertEqual(result.actions.count, 3)
            if result.actions.count == 3 {
                XCTAssertEqual(result.actions[0].ricardianContract, expectedContract)
            } else {
                XCTAssert(false, "Incorrect number of actions")
            }
        } else {
            XCTAssert(false, "Failed to decode")
        }
        
        // ======= Test invalid json input: ==========
        json = "".data(using: .utf8)!
        XCTAssertNil(try?JSONDecoder().decode(TransactionHeader.self, from: json))
    }
    
    func test_renderAbi() {
        var rawContract = "## {{from}} transfers {{quantity}} to {{to}} with delay {{transaction.delay}}."
        var expected = "## from transfers quantity to to with delay 5."
        
        var info = AbiAction(ricardianContract: rawContract)
        var action = Action(account: "account", name: "name", authorization: [], data: Action.Data(from: "from", to: "to", quantity: "quantity", memo: "memo"), hexData: "hexData")
        var result = info.render(with: action, transactionDelay: 5)
        XCTAssertEqual(result, expected)
        
        
        rawContract = "## Transfer Terms & Conditions I, {{from}}, certify the following to be true to the best of my knowledge: 1. I certify that {{quantity}} is not the proceeds of fraudulent or violent activities. 2. I certify that, to the best of my knowledge, {{to}} is not supporting initiation of violence against others. 3. I have disclosed any contractual terms & conditions with respect to {{quantity}} to {{to}}. I understand that funds transfers are not reversible after the {{transaction.delay}} seconds or other delay as configured by {{from}}'s permissions. If this action fails to be irreversibly confirmed after receiving goods or services from '{{to}}', I agree to either return the goods or services or resend {{quantity}} in a timely manner."

        expected = "## Transfer Terms & Conditions I, from, certify the following to be true to the best of my knowledge: 1. I certify that quantity is not the proceeds of fraudulent or violent activities. 2. I certify that, to the best of my knowledge, to is not supporting initiation of violence against others. 3. I have disclosed any contractual terms & conditions with respect to quantity to to. I understand that funds transfers are not reversible after the 55 seconds or other delay as configured by from's permissions. If this action fails to be irreversibly confirmed after receiving goods or services from 'to', I agree to either return the goods or services or resend quantity in a timely manner."
        
        info = AbiAction(ricardianContract: rawContract)
        action = Action(account: "account", name: "name", authorization: [], data: Action.Data(from: "from", to: "to", quantity: "quantity", memo: "memo"), hexData: "hexData")
        result = info.render(with: action, transactionDelay: 55)
        
        XCTAssertEqual(result, expected)
    }
}
