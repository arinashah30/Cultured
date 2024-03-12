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
    
    func testGetLeaderBoardInfo() {
        let expectation = self.expectation(description: "Print top 20 users with highest points")
        
        vm.getLeaderBoardInfo() { topUsers in
            print("Top Users:",topUsers ?? [("None", 0)])
            XCTAssertNotNil(topUsers, "Top users shouldn't be nil")
            XCTAssertEqual(true, self.vm.isSorted(topUsers ?? [("None", 0)]))
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
                    
        vm.getOnGoingActivity(userId: "ryanomeara", type: "quiz") { quizArray in
            XCTAssertNotNil(quizArray, "Information should not be nil")
            print("Name of On-Going Quizzes: \(quizArray)")
            XCTAssertTrue(quizArray.contains("MexicoTraditionQuiz"))
            XCTAssertTrue(quizArray.contains("IndiaCultureQuiz"))
            XCTAssertFalse(quizArray.contains("EgyptFoodQuiz"))
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
                    
        vm.getOnGoingActivity(userId: "ryanomeara", type: "connection") { connectionArray in
            XCTAssertNotNil(connectionArray, "Information should not be nil")
            print("Name of On-Going Connections: \(connectionArray)")
            XCTAssertFalse(connectionArray.contains("FranceFoodConnections"))
            XCTAssertTrue(connectionArray.contains("UAECelebritiesConnections"))
            XCTAssertTrue(connectionArray.contains("ChinaCultureConnections"))
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
            
        vm.getOnGoingActivity(userId: "ryanomeara", type: "wordgame") { wordGameArray in
            XCTAssertNotNil(wordGameArray, "Information should not be nil")
            print("Name of On-Going Word Games: \(wordGameArray)")
            XCTAssertFalse(wordGameArray.contains("UAELandmarkWordGame"))
            XCTAssertTrue(wordGameArray.contains("NigeriaMusicWordGame"))
            XCTAssertTrue(wordGameArray.contains("IndiaTraditionWordGame"))
            expectation.fulfill()
        }
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
