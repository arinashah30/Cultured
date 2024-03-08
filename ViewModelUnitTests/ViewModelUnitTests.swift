//
//  ViewModelUnitTests.swift
//  ViewModelUnitTests
//
//  Created by Connor on 2/27/24.
//

import XCTest
import Firebase
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
        
    func testGetQuizFromFirebase() {
        let expectation = self.expectation(description: "Retrieve information from Quiz")
        
        vm.getQuizFromFirebase(activityName: "FrenchCultureQuiz") {quiz in
            XCTAssertNotNil(quiz, "Quiz should not be nil")
            XCTAssertEqual(quiz?.points, 999)
            XCTAssertEqual(quiz?.pointsGoal, 800000000000)
            XCTAssertEqual(quiz?.title, "FrenchCultureQuiz")
            XCTAssertFalse(quiz?.questions.isEmpty ??  true)
            //print("Quiz =====", quiz!)
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testCreateNewWordGuessing() {
        let expectation = self.expectation(description: "Update Information in Firebase")
        
        let options = [
            OptionTile(option: "Bio Quad", isFlipped: true),
            OptionTile(option: "THE Olympic Pool", isFlipped: true),
            OptionTile(option: "Stamps Student Health Center", isFlipped: false),
            OptionTile(option: "Dorothy Crossland Tower", isFlipped: false),
            OptionTile(option: "Clough Undergraduate Learning Commons", isFlipped: false),
            OptionTile(option: "Bobby Dodd", isFlipped: false)
        ]
        let wordGuessing = WordGuessing(title: "UAETraditionsWordGuessing",
                                       options: options,
                                       answer: "THE Olympic Pool",
                                       totalPoints: 17,
                                       flipPoints: 4,
                                       flipsDone: 2,
                                       numberOfGuesses: 3)
        
        vm.createNewWordGuessing(wordGuessing: wordGuessing)
        
        // Wait for some time for Firestore operation to complete
        // !!!THIS IS VITAL TO TEST FUNCTIONS THAT UPDATE TO THE FIRESTORE!!!
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
                
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetWordGameFromFirebase() {
        let expectation = self.expectation(description: "Retrieve information from WordGame")
        
        vm.getWordGameFromFirebase(activityName: "MexicoFoodWordGuessing") {wordgame in
            XCTAssertNotNil(wordgame, "Word Game should not be nil")
            XCTAssertEqual(wordgame?.answer, "Cheese")
            XCTAssertEqual(wordgame?.flipPoints, 18)
            XCTAssertEqual(wordgame?.flipsDone, 0)
            XCTAssertEqual(wordgame?.numberOfGuesses, 0)
            XCTAssertEqual(wordgame?.title, "MexicoFoodWordGuessing")
            XCTAssertEqual(wordgame?.totalPoints, 200)
            XCTAssertFalse(wordgame?.options.isEmpty ?? true, "The Options array is Empty")
            print("WordGame =====", wordgame!)
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetConnectionsFromFirebase() {
        let expectation = self.expectation(description: "Retrieve information from Connections")
        
        vm.getConnectionsFromFirebase(activityName: "ChinaFoodConnections") {connection in
            XCTAssertNotNil(connection, "Connection should not be nil")
            XCTAssertEqual(connection?.title, "ChinaFoodConnections")
            XCTAssertEqual(connection?.points, 1500)
            XCTAssertEqual(connection?.attempts, 2)
            XCTAssertFalse(connection?.options.isEmpty ?? true, "The Options array is Empty")
            print("Connections =====", connection!)
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
