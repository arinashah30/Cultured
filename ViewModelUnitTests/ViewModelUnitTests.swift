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
    var db: Firestore!

    
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
            OptionTile(option: "Sandwich", isFlipped: true),
            OptionTile(option: "Deli", isFlipped: true),
            OptionTile(option: "Provolone", isFlipped: false)
        ]
        let wordGuessing = WordGuessing(title: "MexicoFoodWordGuessing",
                                       options: options,
                                       answer: "Cheese",
                                       totalPoints: 200,
                                       flipPoints: 18,
                                       flipsDone: 0,
                                       numberOfGuesses: 0)
        
        vm.createNewWordGuessing(wordGuessing: wordGuessing) { success in
                XCTAssertTrue(success, "Creation of game failed")
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
        
        vm.getWordGameFromFirebase(activityName: "UAETraditionsWordGuessing") {wordgame in
            XCTAssertNotNil(wordgame, "Word Game should not be nil")
            XCTAssertEqual(wordgame?.answer, "THE Olympic Pool")
            XCTAssertEqual(wordgame?.title, "UAETraditionsWordGuessing")
            XCTAssertEqual(wordgame?.totalPoints, 17)
            XCTAssertFalse(wordgame?.options.isEmpty ?? true, "The Options array is Empty")
            //print("WordGame =====", wordgame!)
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
