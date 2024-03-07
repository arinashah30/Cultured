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
    
    
    func testGetQuizFromFirebase() {
        let expectation = self.expectation(description: "Retrieve information from Quiz")
        
        vm.getQuizFromFirebase(activityName: "FrenchCultureQuiz") {quiz in
            XCTAssertNotNil(quiz, "Quiz should not be nil")
            XCTAssertEqual(quiz?.points, 999)
            XCTAssertEqual(quiz?.pointsGoal, 800000000000)
            XCTAssertEqual(quiz?.title, "FrenchCultureQuiz")
            XCTAssertFalse(quiz?.questions.isEmpty ??  true)
            print("Quiz =====", quiz!)
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
//            print("WordGame =====", wordgame!)            
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
