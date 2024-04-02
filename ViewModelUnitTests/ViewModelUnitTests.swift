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
    
    func testCreateNewConnections() {
        let expectation = self.expectation(description: "Update Information in Firebase")
        
        let title = "ChinaFoodConnections"
        let categories = ["Food", "GT Locations"]
        let answerKey: [String: [String]] = ["Food": ["Pizza", "Pasta", "Sour Patch Kids"],
                                           "Gt Locations": ["College of Computing Building", "Klaus Advanced Computing Building", "Bio Quad"]]
        let points = 1500
        let attempts = 2
        let mistakesRemaining = 2
        let correctCategories = 4

        // Options
        let option1 = Connections.Option(id: "Pizza", isSelected: false, isSubmitted: false, content: "Pizza", category: "Category1")
        let option2 = Connections.Option(id: "Pasta", isSelected: false, isSubmitted: false, content: "Pasta", category: "Category1")
        let option3 = Connections.Option(id: "College of Computing Building", isSelected: false, isSubmitted: false, content: "College of Computing Building", category: "Category2")
        let option4 = Connections.Option(id: "Klaus Advanced Computing Building", isSelected: false, isSubmitted: false, content: "Klaus Advanced Computing Building", category: "Category2")
        let option5 = Connections.Option(id: "Bio Quad", isSelected: false, isSubmitted: false, content: "Bio Quad", category: "Category")
        let options = [option1, option2, option3, option4, option5]
        
        // Option selection
        let selection = [option2, option4, option5]

        // History
        let history: [[Connections.Option]] = [[option1, option2], [option3, option4, option5]]

        // Create Connections object
        let connections = Connections(title: title,
                                      categories: categories,
                                      answerKey: answerKey,
                                      options: options,
                                      selection: selection,
                                      history: history,
                                      points: points,
                                      attempts: attempts,
                                      mistakes_remaining: mistakesRemaining,
                                      correct_categories: correctCategories
                                      )

        // Test the createNewConnections function
        vm.createNewConnections(connection: connections)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
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
            XCTAssertEqual(connection?.mistakes_remaining, 2)
            XCTAssertEqual(connection?.correct_categories, 4)
            XCTAssertFalse(connection?.options.isEmpty ?? true, "The Options array is Empty")
            XCTAssertFalse(connection?.selection.isEmpty ?? true, "The Selection array is Empty")
            XCTAssertFalse(connection?.history.isEmpty ?? true, "The History array is Empty")
            print("Connections =====", connection!)
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
                    
        vm.getOnGoingActivity(userId: "ryanomeara", type: "quiz") { quizDictionary in
            XCTAssertNotNil(quizDictionary, "Information should not be nil")
            print("Name of On-Going Quizzes: \(quizDictionary)")
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
                    
        vm.getOnGoingActivity(userId: "ryanomeara", type: "connection") { connectionDictionary in
            XCTAssertNotNil(connectionDictionary, "Information should not be nil")
            print("Name of On-Going Connections: \(connectionDictionary)")
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
            
        vm.getOnGoingActivity(userId: "ryanomeara", type: "wordgame") { wordGameDictionary in
            XCTAssertNotNil(wordGameDictionary, "Information should not be nil")
            print("Name of On-Going Word Games: \(wordGameDictionary)")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    //Unit Tests for basic functionality of 'getAllCompletedActivities(userId, type, completion)'
    //Next Three unit tests assess the functinoality for each activity: quiz, connection, wordgame
    func testGetCompletedQuizzes() {
        let expectation = self.expectation(description: "Retrieve an On-Going Quiz")
                    
        vm.getAllCompletedActivities(userId: "ryanomeara", type: "quiz") { quizDictionary in
            XCTAssertNotNil(quizDictionary, "Information should not be nil")
            print("Completed Quizzes: \(quizDictionary)")
            expectation.fulfill()
        }
             
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetCompletedConnections() {
        let expectation = self.expectation(description: "Retrieve an On-Going Connection")
                    
        vm.getAllCompletedActivities(userId: "ryanomeara", type: "connection") { connectionDictionary in
            XCTAssertNotNil(connectionDictionary, "Information should not be nil")
            print("Completed Connections: \(connectionDictionary)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testGetCompletedWordGames() {
        let expectation = self.expectation(description: "Retrieve an On-Going Word Game")
            
        vm.getAllCompletedActivities(userId: "ryanomeara", type: "wordgame") { wordGameDictionary in
            XCTAssertNotNil(wordGameDictionary, "Information should not be nil")
            print("Completed Word Games: \(wordGameDictionary)")
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

    func testGetWinCountDictionary() {
        
        let expectation = self.expectation(description: "Retrieving Win Count Dictionary")
        var winCount = [String : Int]()
        for i in 1..<10 {
            winCount["\(i)"] = 0 //initialize every win count to 0 for every hint number
        }
        
        vm.getWinCountDictionary(nameOfWordgame: "UAETraditionsWordGuessing") { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(winCount, result)
            print("Result: ", result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    
    func testUpdateWinCountDictionary() {
        let expectation = self.expectation(description: "Updating Win Count Dictionary")
        
        vm.updateWinCountDictionary(nameOfWordgame: "UAETraditionsWordGuessing", hintCount: 7) { result in
            XCTAssertNotNil(result)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    func testAddOngoingActivity() {
        let expectation = XCTestExpectation(description: "Ongoing check")
        vm.addOnGoingActivity(userID: "ryanomeara", numQuestions: 9, titleOfActivity: "NigeriaMusicWordGame", typeOfActivity: "wordgame") { completed in
            print(completed)
        }
    }
      
    func testRetrieveImage() {
            // Create an expectation for a background download task.
            let expectation = XCTestExpectation(description: "Download meme1.jpeg from Firebase Storage")

            // Instantiate the class that contains your image retrieval function.
            //let yourClassInstance = YourClass()

            // Call the image retrieval function.
            vm.getImage(imageName: "meme1.jpeg") { image in
                // If the image is non-nil, we consider the retrieval a success.
                if let image = image {
                    XCTAssertNotNil(image, "Image should not be nil")
                    expectation.fulfill() // This will end the wait.
                } else {
                    XCTFail("Image was nil. Expected to retrieve the image successfully.")
                }
            }

            // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
            wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetLongitudeLatitude() {
            let expectation = XCTestExpectation(description: "Retrieve longitude and latitude from Firebase")

            vm.getLatitudeLongitude(countryName: "CHINA") { coordinatesDict in
                // Assert that the coordinates are not nil
                XCTAssertNotNil(coordinatesDict, "Coordinates dictionary should not be nil")

                if let coordinatesDict = coordinatesDict {
                    //print("Lat: \(coordinatesDict["latitude"])")
                    //print("Long: \(coordinatesDict["longitude"])")
                    XCTAssertNotNil(coordinatesDict["latitude"], "Latitude should be present in the dictionary")
                    XCTAssertNotNil(coordinatesDict["longitude"], "Longitude should be present in the dictionary")
                    

                }
                expectation.fulfill()

            }
            wait(for: [expectation], timeout: 10.0) // Adjust timeout to your needs
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
    
    func testSetCountrySuccess() {
            let newID = "Ganden Fung"
            let newCountry = "China"
            let expectation = self.expectation(description: "set country success")

            vm.setCurrentCountry(userID: newID, countryName: newCountry) { success in
                XCTAssertTrue(success, "The currentCountry should be set successfully.")
                expectation.fulfill()
            }

            waitForExpectations(timeout: 5, handler: nil)
        }
}
