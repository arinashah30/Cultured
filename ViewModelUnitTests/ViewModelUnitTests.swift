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
    
    
    func testCreateNewQuiz() {
        let expectation = self.expectation(description: "Update Quiz information in Firebase")
        let quizQuestion1 = QuizQuestion(question: "What color is the French Flag",
                                         answers: ["Blue", "Orange", "Red", "Yellow"],
                                         correctAnswer: 2,
                                         correctAnswerDescription: "IDK this is a test highkey",
                                         submitted: false)
        
        let quizQuestion2 = QuizQuestion(question: "What is a french food",
                                         answers: ["Baguette", "Orange Chicken", "Cupcakes", "Bok-Choy"],
                                         correctAnswer: 0,
                                         correctAnswerDescription: "Obviously it's Baguette...duh",
                                         submitted: false)
        let quizQuestionArray = [quizQuestion1, quizQuestion2]
        let quiz1 = Quiz(title: "FrenchCultureQuiz", questions: quizQuestionArray)
        vm.createNewQuiz(quiz: quiz1)
        
        let quizQuestion3 = QuizQuestion(question: "How many cups of coffee are consumed everyday in the US",
                                         answers: ["200 Million", "300 Million", "400 Million", "500 Million"],
                                         correctAnswer: 1,
                                         correctAnswerDescription: "The average coffee drinker drinks 3 cups or whatever",
                                         submitted: false)
        
        let quizQuestion4 = QuizQuestion(question: "Which is an American food?",
                                         answers: ["Burger", "Pasta", "Tacos", "Gyros"],
                                         correctAnswer: 0,
                                         correctAnswerDescription: "Blah blah blah McDonald's started the burger hype in the US",
                                         submitted: false)
        let quizQuestionArray2 = [quizQuestion3, quizQuestion4]
        let quiz2 = Quiz(title: "UnitedStatesFoodQuiz", questions: quizQuestionArray2)
        vm.createNewQuiz(quiz: quiz2)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
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
            XCTAssertEqual(quiz?.title, "FrenchCultureQuiz")
            XCTAssertFalse(quiz?.questions.isEmpty ??  true)
            XCTAssertEqual(quiz?.points, 0)
            XCTAssertEqual(quiz?.pointsGoal, 0)
            XCTAssertEqual(quiz?.currentQuestion, 0)
            print("Quiz1 =====", quiz!)
//            expectation.fulfill()
        }
        
        vm.getQuizFromFirebase(activityName: "UnitedStatesFoodQuiz") {quiz in
            XCTAssertNotNil(quiz, "Quiz should not be nil")
            XCTAssertEqual(quiz?.title, "UnitedStatesFoodQuiz")
            XCTAssertFalse(quiz?.questions.isEmpty ??  true)
            XCTAssertEqual(quiz?.points, 0)
            XCTAssertEqual(quiz?.pointsGoal, 0)
            XCTAssertEqual(quiz?.currentQuestion, 0)
            print("Quiz2 =====", quiz!)
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
            OptionTile(option: "Dough", isFlipped: true),
            OptionTile(option: "Filling", isFlipped: true),
            OptionTile(option: "Steamed", isFlipped: false),
            OptionTile(option: "Asian", isFlipped: false),
            OptionTile(option: "Wrapper", isFlipped: false),
            OptionTile(option: "Boiled", isFlipped: false),
            OptionTile(option: "Delicious", isFlipped: false),
            OptionTile(option: "Bite Size", isFlipped: false)
        ]
        let wordGuessing = WordGuessing(title: "ChinaFoodWordGuessing",
                                       options: options,
                                       answer: "Dumpling")
        
        vm.createNewWordGuessing(wordGuessing: wordGuessing)

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
        
        vm.getWordGameFromFirebase(activityName: "ChinaFoodWordGuessing") {wordgame in
            XCTAssertNotNil(wordgame, "Word Game should not be nil")
            XCTAssertEqual(wordgame?.answer, "Dumpling")
            XCTAssertEqual(wordgame?.title, "ChinaFoodWordGuessing")
            XCTAssertFalse(wordgame?.options.isEmpty ?? true, "The Options array is Empty")
            print("China Food WordGame =====", wordgame!)
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
//    func testCreateNewConnections() {
//        let expectation = self.expectation(description: "Update Information in Firebase")
//        
//        let title = "ChinaFoodConnections"
//        let categories = ["Food", "GT Locations"]
//        let answerKey: [String: [String]] = ["Food": ["Pizza", "Pasta", "Sour Patch Kids"],
//                                           "Gt Locations": ["College of Computing Building", "Klaus Advanced Computing Building", "Bio Quad"]]
//        let points = 1500
//        let attempts = 2
//        let mistakesRemaining = 2
//        let correctCategories = 4
//
//        // Options
//        let option1 = Connections.Option(id: "Pizza", isSelected: false, isSubmitted: false, content: "Pizza", category: "Category1")
//        let option2 = Connections.Option(id: "Pasta", isSelected: false, isSubmitted: false, content: "Pasta", category: "Category1")
//        let option3 = Connections.Option(id: "College of Computing Building", isSelected: false, isSubmitted: false, content: "College of Computing Building", category: "Category2")
//        let option4 = Connections.Option(id: "Klaus Advanced Computing Building", isSelected: false, isSubmitted: false, content: "Klaus Advanced Computing Building", category: "Category2")
//        let option5 = Connections.Option(id: "Bio Quad", isSelected: false, isSubmitted: false, content: "Bio Quad", category: "Category")
//        let options = [option1, option2, option3, option4, option5]
//        
//        // Option selection
//        let selection = [option2, option4, option5]
//
//        // History
//        let history: [[Connections.Option]] = [[option1, option2], [option3, option4, option5]]
//
//        // Create Connections object
//        let connections = Connections(title: title,
//                                      categories: categories,
//                                      answerKey: answerKey,
//                                      options: options,
//                                      selection: selection,
//                                      history: history,
//                                      points: points,
//                                      attempts: attempts,
//                                      mistakes_remaining: mistakesRemaining,
//                                      correct_categories: correctCategories
//                                      )
//
//        // Test the createNewConnections function
//        vm.createNewConnections(connection: connections)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            expectation.fulfill()
//        }
//                
//        waitForExpectations(timeout: 5) { error in
//            if let error = error {
//                XCTFail("waitForExpectations error: \(error)")
//            }
//        }
//    }
    
    func testGetConnectionsFromFirebase() {
        let expectation = self.expectation(description: "Retrieve information from Connections")
        
        vm.getConnectionsFromFirebase(activityName: "ChinaFoodConnections") {connection in
            XCTAssertNotNil(connection, "Connection should not be nil")
            XCTAssertEqual(connection?.title, "ChinaFoodConnections")
            XCTAssertEqual(connection?.points, 0)
            XCTAssertEqual(connection?.attempts, 0)
            XCTAssertEqual(connection?.mistakes_remaining, 0)
            XCTAssertEqual(connection?.correct_categories, 0)
            XCTAssertTrue(connection?.options.isEmpty ?? false, "The Options array is NOT Empty")
            XCTAssertTrue(connection?.selection.isEmpty ?? false, "The Selection array is NOT Empty")
            print("ChinaFoodConnections =====", connection!)
        }
        
        vm.getConnectionsFromFirebase(activityName: "USFoodConnections") {connection in
            XCTAssertNotNil(connection, "Connection should not be nil")
            XCTAssertEqual(connection?.title, "USFoodConnections")
            XCTAssertEqual(connection?.points, 0)
            XCTAssertEqual(connection?.attempts, 0)
            XCTAssertEqual(connection?.mistakes_remaining, 0)
            XCTAssertEqual(connection?.correct_categories, 0)
            XCTAssertTrue(connection?.options.isEmpty ?? false, "The Options array is NOT Empty")
            XCTAssertTrue(connection?.selection.isEmpty ?? false, "The Selection array is NOT Empty")
            print("USFoodConnections =====", connection!)
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

    
    func testOngoingActivityFields() {
        print("Hello world")
        let expectation = XCTestExpectation(description: "ongoing activity fields check")
        vm.getfieldsofOnGoingActivity(userId: "ryanomeara", activity: "EgyptFoodQuiz") { intact in
            print("Completed: \(String(describing: intact!["completed"]))")
            print("Current: \(String(describing: intact?["current"]))")
            print("NumQ: \(String(describing: intact?["numberOfQuestions"]))")
            print("Score: \(String(describing: intact?["score"]))")
            print("Type: \(String(describing: intact?["type"]))")
            print("Hello world")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5) // Adjust timeout as needed
    }
}
