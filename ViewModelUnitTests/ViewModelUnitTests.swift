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


    //Unit Test for basic functionality of 'getInfoFromModule(countryName, moduleName, completion)'
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
        }
    }
    
    
    
    //Unit Tests for basic functionality of 'getOnGoingActivity(userId, type, completion)'
    //Next Three unit tests assess the functinoality for each activity: quiz, connection, wordgame
    func testGetOnGoingQuiz() {
        let expectation = self.expectation(description: "Retrieve an On-Going Quiz")
            
        vm.getOnGoingActivity(userId: "dummyUsername_12", type: "quiz") { nameOfQuiz in
            XCTAssertNotNil(nameOfQuiz, "Information should not be nil")
            print("Name of On-Going Quiz: \(nameOfQuiz)")
            XCTAssertEqual(nameOfQuiz, "FranceQuiz")
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetOnGoingConnection() {
        let expectation = self.expectation(description: "Retrieve an On-Going Connection")
            
        vm.getOnGoingActivity(userId: "dummyUsername_12", type: "connection") { nameOfConnection in
            XCTAssertNotNil(nameOfConnection, "Information should not be nil")
            print("Name of On-Going Connection: \(nameOfConnection)")
            XCTAssertEqual(nameOfConnection, "UAEConnection")
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetOnGoingWordGame() {
        let expectation = self.expectation(description: "Retrieve an On-Going Word Game")
            
        vm.getOnGoingActivity(userId: "dummyUsername_12", type: "wordgame") { nameOfWordGame in
            XCTAssertNotNil(nameOfWordGame, "Information should not be nil")
            print("Name of On-Going Word Game: \(nameOfWordGame)")
            XCTAssertEqual(nameOfWordGame, "NigeriaWordGame")
            XCTAssertNotEqual(nameOfWordGame, "EgyptWordGame")
            XCTAssertNotEqual(nameOfWordGame, "UAEWordGame")

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
