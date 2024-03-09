//
//  ViewModelUnitTests.swift
//  ViewModelUnitTests
//
//  Created by Connor on 2/27/24.
//

import XCTest
@testable import Cultured

final class ViewModelUnitTests: XCTestCase {

    var vm: ViewModel!

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vm = ViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    //Unit Test for basic functionality of 'getInfoFromModule()'
    func testGetInfoFromModule() {
            let expectation = self.expectation(description: "Retrieve information from module")
            
            vm.getInfoFromModule(countryName: "UAE", moduleName: "TRADITIONS") { information in
                XCTAssertNotNil(information, "Information should not be nil")
                print("Value of Information: \(information)")
                XCTAssertEqual(information, "value")
                XCTAssertNotEqual(information, "anythingElse")
                expectation.fulfill()
            }
            
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
            
        } // Adjust the timeout as needed
        }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUpdateLastLoggedOn() {
        vm.updateLastLoggedOn(userID: "ryanomeara") {completed in
            print(completed)
        }
    }
    
    func testStreak() {
        print("Hello world")
        let expectation = XCTestExpectation(description: "Streak check")
        vm.checkIfStreakIsIntact(userID: "ryanomeara") { intact in
            print("Is intact?: \(intact)")
            print("Hello world")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5) // Adjust timeout as needed
        print("Hello world")
    }

}
