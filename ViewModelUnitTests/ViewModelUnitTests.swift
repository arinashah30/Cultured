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
    
    func testSignUp() {
        let expectation = self.expectation(description: "Signing up in Firebase")
                    
        vm.firebase_email_password_sign_up_(email: "Dylan.whatever@gmail.com", password: "adkdk1", username: "Dylan Evans") { _ in
            
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
    
    func testSignIn() {
        let expectation = self.expectation(description: "Logging into Firebase")
        
                    
        vm.fireBaseSignIn(email: "Dylan.whatever@gmail.com", password: "adkdk1") { result in
            XCTAssertNotNil(result)
            XCTAssertTrue(result)
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
    
//    func testGetLeaderBoardInfo() {
//        let expectation = self.expectation(description: "Print top 20 users with highest points")
//        
//        vm.getLeaderBoardInfo() { topUsers in
//            print("Top Users:",topUsers ?? [("None", 0)])
//            XCTAssertNotNil(topUsers, "Top users shouldn't be nil")
//            XCTAssertEqual(true, self.vm.isSorted(topUsers ?? [("None", 0): ]))
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5) { error in
//            if let error = error {
//                XCTFail("waitForExpectations error: \(error)")
//            }
//        }
//    }
    
    func testCreateNewQuiz() {
        let expectation = self.expectation(description: "Update Quiz information in Firebase")
        let quizQuestion1 = QuizQuestion(question: "What historical figure played a significant role in establishing classical ballet in France?",
                                         answers: ["Isadora Duncan", "Pierre Beauchamp", "Louis XIV", "Maurice Béjart"],
                                         correctAnswer: 2,
                                         correctAnswerDescription: "Louis XIV played a significant role in classical ballet influence during the Renaissance.")

        let quizQuestion2 = QuizQuestion(question: "Which institution has contributed to France's global reputation in classical ballet?",
                                         answers: ["Royal Academy of Dance", "Paris Opera Ballet", "Bolshoi Ballet", "Opéra Bastille"],
                                         correctAnswer: 1,
                                         correctAnswerDescription: "Ballet has been refined and perfected in prestigious institutions like the Paris Opera Ballet.")
        
        let quizQuestion3 = QuizQuestion(question: "What is the leading sport in France, capturing widespread support from both local clubs and the national team?",
                                         answers: ["Rugby", "Basketball", "Football", "Tennis"],
                                         correctAnswer: 2,
                                         correctAnswerDescription: "Football is the predominant sport in France, with widespread support for both local clubs and the national team, Les Bleus.")
        
        let quizQuestion4 = QuizQuestion(question: "Which annual cycling race is a testament to France's love for cycling and contributes significantly to its cultural heritage?",
                                         answers: ["Tour de France", "Paris-Roubaix", "Critérium du Dauphiné", "Paris-Nice"],
                                         correctAnswer: 0,
                                         correctAnswerDescription: "The Tour de France, an annual cycling race, not only is a testament to the country's love for cycling but also contributes significantly to its cultural heritage and global sports reputation.")
        
        let quizQuestion5 = QuizQuestion(question: "What major tennis tournament held in France attracts global attention and is considered one of the sport's Grand Slam events?",
                                         answers: ["Monte Carlo Masters", "Paris Masters", "Lyon Open", "French Open"],
                                         correctAnswer: 3,
                                         correctAnswerDescription: "The French Open is one of the tennis world's four Grand Slam tournaments, attracting global attention to France's sporting excellence.")
        let quizQuestionArray = [quizQuestion1, quizQuestion2, quizQuestion3, quizQuestion4, quizQuestion5]
        let quiz1 = Quiz(title: "MexicoFoodQuiz", questions: quizQuestionArray)
        vm.createNewQuiz(quiz: quiz1)

//        let quizQuestion3 = QuizQuestion(question: "How many cups of coffee are consumed everyday in the US",
//                                         answers: ["200 Million", "300 Million", "400 Million", "500 Million"],
//                                         correctAnswer: 1,
//                                         correctAnswerDescription: "The average coffee drinker drinks 3 cups or whatever",
//                                         submitted: false)
//
//        let quizQuestion4 = QuizQuestion(question: "Which is an American food?",
//                                         answers: ["Burger", "Pasta", "Tacos", "Gyros"],
//                                         correctAnswer: 0,
//                                         correctAnswerDescription: "Blah blah blah McDonald's started the burger hype in the US",
//                                         submitted: false)
//        let quizQuestionArray2 = [quizQuestion3, quizQuestion4]
//        let quiz2 = Quiz(title: "UnitedStatesFoodQuiz", questions: quizQuestionArray2)
//        vm.createNewQuiz(quiz: quiz2)

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
        
        vm.getQuizFromFirebase(activityName: "MexcioCultureQuiz") {quiz in
            XCTAssertNotNil(quiz, "Quiz should not be nil")
            XCTAssertEqual(quiz?.points, 0)
            XCTAssertEqual(quiz?.title, "MexcioCultureQuiz")
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
    
    func testCreateNewWordGuessing() {
        let expectation = self.expectation(description: "Update Information in Firebase")
        
        let options = [OptionTile(option: "Edible", isFlipped: true),
                       OptionTile(option: "Italian", isFlipped: true),
                       OptionTile(option: "Sandwich", isFlipped: false),
                       OptionTile(option: "Semi-hard", isFlipped: false),
                       OptionTile(option: "White", isFlipped: false),
                       OptionTile(option: "Rounded", isFlipped: false),
                       OptionTile(option: "Deli Sub", isFlipped: false),
                       OptionTile(option: "Cheese", isFlipped: false)]
        
        let wordGuessing = WordGuessing(title: "USFoodWordGuessing",
                                       options: options,
                                       answer: "Provolone",
                                        stats: [1, 2, 3, 5, 8, 8, 6, 5, 3, 10])
        
        let option2 = [OptionTile(option: "Dough", isFlipped: true),
                       OptionTile(option: "Filling", isFlipped: true),
                       OptionTile(option: "Steamed", isFlipped: false),
                       OptionTile(option: "Asian", isFlipped: false),
                       OptionTile(option: "Wrapper", isFlipped: false),
                       OptionTile(option: "Boiled", isFlipped: false),
                       OptionTile(option: "Delicious", isFlipped: false),
                       OptionTile(option: "Bite Size", isFlipped: false)]

        let wordGuessing2 = WordGuessing(title: "ChinaFoodWordGuessing",
                                         options: options,
                                         answer: "Dumpling",
                                         stats: [1, 2, 3, 5, 8, 8, 6, 5, 3, 10])
        
        vm.createNewWordGuessing(wordGuessing: wordGuessing)
        vm.createNewWordGuessing(wordGuessing: wordGuessing2)

        
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
        
        vm.getWordGameFromFirebase(activityName: "USFoodWordGuessing") {wordgame in
            XCTAssertNotNil(wordgame, "Word Game should not be nil")
            XCTAssertEqual(wordgame?.answer, "Provolone")
            XCTAssertEqual(wordgame?.title, "USFoodWordGuessing")
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
        
        let title = "UnitedStatesCultureConnections"
        let answerKey: [String: [String]] = ["Ways to Prepare Eggs": ["Boil", "Fry", "Poach", "Scramble"],
                                             "Thrown in Target Games": ["Axe", "Dart", "Horseshoe", "Ring"],
                                             "____ Wrap": ["Body", "Bubble", "Gift", "Shrink"],
                                             "Exhilaration": ["Buzz", "Kick", "Rush", "Thrill"]
                                            ]
        
        // Create Connections object
        let connections = Connections(title: title, answer_key: answerKey)

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
        
        vm.getConnectionsFromFirebase(activityName: "ChinaCultureConnections") {connection in
            XCTAssertNotNil(connection, "Connection should not be nil")
            XCTAssertEqual(connection?.title, "ChinaCultureConnections")
            XCTAssertEqual(connection?.points, 0)
            XCTAssertEqual(connection?.mistakes_remaining, 4)
            print("ChinaFoodConnections =====", connection!)
        }
        
        vm.getConnectionsFromFirebase(activityName: "USFoodConnections") {connection in
            XCTAssertNotNil(connection, "Connection should not be nil")
            XCTAssertEqual(connection?.title, "USFoodConnections")
            XCTAssertEqual(connection?.points, 0)
            XCTAssertEqual(connection?.mistakes_remaining, 4)
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
                    
        vm.getAllActivitiesOfType(userId: "ryanomeara", type: "quiz") { quizDictionary in
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
                    
        vm.getAllActivitiesOfType(userId: "ryanomeara", type: "connection") { connectionDictionary in
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
            
        vm.getAllActivitiesOfType(userId: "ryanomeara", type: "wordgame") { wordGameDictionary in
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
        let expectation = self.expectation(description: "Ongoing check")
        
        vm.addOnGoingActivity(userID: "Dylan Evans", numQuestions: 1, titleOfActivity: "ChinaFoodWordGuessing", typeOfActivity: "wordgame") { completed in
            print(completed)
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

        vm.getLatitudeLongitude(country: "CHINA") { coordinatesDict in
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
    //Before Running this, make sure Sameer's streakRecord is less than
    //the streak, to ensure we return "true" when we update streakRecord
    func testUpdateStreakRecord() {
        let expectation = self.expectation(description: "Updating Streak Record in Firebase")
                    
        vm.updateStreakRecord(userID: "ryanomeara") { result in
            XCTAssertNotNil(result, "Information should not be nil")
            XCTAssertFalse(result)
        }
        
        vm.updateStreakRecord(userID: "Sameer") { result in
            XCTAssertNotNil(result, "Information should not be nil")
            print("Result:", result)
            XCTAssertTrue(result)
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
    
    func testCheckIfStreakIsIntactWithStreakRecord() {
        let expectation = self.expectation(description: "Updating Streak Record in Firebase")
        
        vm.checkIfStreakIsIntact(userID: "ryanomeara") { result in
            XCTAssertNotNil(result, "Information should not be nil")
            //            XCTAssertTrue(result)
            XCTAssertFalse(result)
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

    func testAddCompletedCountry() {
        let newID = "Ganden Fung"
        let newCountry = "China"
        let expectation = self.expectation(description: "set country success")

        vm.addCompletedCountry(userID: newID, countryName: newCountry) { success in
            XCTAssertTrue(success, "The currentCountry should be added successfully.")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testIncrementCurrent() {
        let newID = "ryanomeara"
        let activityName = "ChinaCultureConnections"
        let expectation = self.expectation(description: "set country success")

        vm.incrementCurrent(userID: newID, activityName: activityName) { success in
            XCTAssertTrue(success, "The currentCountry should be added successfully.")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
  
    func testCurrentUser() {
        print("hello")
        let expectation = XCTestExpectation(description: "sign up check")
//        vm.firebase_email_password_sign_up_(email: "aroy351@gatech.edu", password: "test123testing", username: "Rik Roy")
//        wait(for: [expectation], timeout: 5)
//        print(vm.current_user)
//        expectation.fulfill()
        self.vm.fireBaseSignIn(email: "aroy351@gatech.edu", password: "test123testing") { completed in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        print(self.vm.current_user)
    }
    func testSetCountrySuccess() {
        let newID = "Ganden Fung"
        let newCountry = "China"
        let expectation = self.expectation(description: "set country success")

        vm.setCurrentCountry(userID: newID, countryName: newCountry) { success in
            XCTAssertTrue(success, "The currentCountry should be set successfully.")
            expectation.fulfill()
        }
    }
    
    func testCheckIfOnGoingActivityIsCompleted() {
        let expectation = self.expectation(description: "Retrieve whether an activity is completed")
            
        vm.checkIfOnGoingActivityIsCompleted(userID: "Dylan Evans", activity: "ChinaFoodWordGuessing") { completed in
            XCTAssertNotNil(completed, "Information should not be nil")
            XCTAssertFalse(completed)
        }
        
        vm.checkIfOnGoingActivityIsCompleted(userID: "Dylan Evans", activity: "MexcioCultureQuiz") { completed in
            XCTAssertNotNil(completed, "Information should not be nil")
            XCTAssertFalse(completed)
        }
        
        vm.checkIfOnGoingActivityIsCompleted(userID: "Dylan Evans", activity: "USFoodConnections") { completed in
            XCTAssertNotNil(completed, "Information should not be nil")
            XCTAssertTrue(completed)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }

    func testImage() {
        let expectation = self.expectation(description: "image stuff")
//        vm.load_image_from_url(urlString: "https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg") {
//            image in
//            self.vm.updateProfilePic(userID: "Rik Roy", image: image!) { completion in
//                print(completion)
//                expectation.fulfill()
//            }
//        }
//        wait(for: [expectation], timeout: 5)
        vm.getProfilePic(userID: "Rik Roy") { image in
            self.vm.storeImageAndReturnURL(image: image!) { url in
                print(url)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetInfoCelebrities() {
        let expectation = self.expectation(description: "Retrieve Celebrities Data From Firebase")

        let nilObject = Celebrities()

        vm.getInfoCelebrities(countryName: "MEXICO") { celebrityObject in
            XCTAssertNotNil(celebrityObject, "Information should not be nil")
            XCTAssertNotEqual(nilObject, celebrityObject)
            print("Celebrities ====", celebrityObject)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    func testGetInfoLandmarks() {
         let expectation = self.expectation(description: "Retrieve Landmark Data From Firebase")

         let nilObject = Landmarks()

         vm.getInfoLandmarks(countryName: "MEXICO") { landmarkObject in
             XCTAssertNotNil(landmarkObject, "Information should not be nil")
             XCTAssertNotEqual(nilObject, landmarkObject)
             print("Landmarks ====", landmarkObject)
             expectation.fulfill()
         }

         waitForExpectations(timeout: 5) { error in
             if let error = error {
                 XCTFail("waitForExpectations error: \(error)")
             }
         }
     }
  
    func testGetInfoEtiquettes() {
        let expectation = self.expectation(description: "Retrieve Etiquette Data From Firebase")
        
        let nilEtiquette = Etiquette()
        
        vm.getInfoEtiquettes(countryName: "MEXICO") { etiquetteObject in
            XCTAssertNotNil(etiquetteObject, "Information should not be nil")
            XCTAssertNotEqual(nilEtiquette, etiquetteObject)
            print("Etiquette ====", etiquetteObject)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }

    }
    
    func testGetInfoTraditions() {
        let expectation = self.expectation(description: "Retrieve Traditions Data From Firebase")

        let nilObject = Traditions()
        
        vm.getInfoTraditions(countryName: "MEXICO") { traditionsObject in
            XCTAssertNotNil(traditionsObject, "Information should not be nil")
            XCTAssertNotEqual(nilObject, traditionsObject)
            print("Traditions ====", traditionsObject)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }

    func testGetInfoSports() {
        let expectation = self.expectation(description: "Retrieve Sports Data From Firebase")
        
        let nilObject = Sports()
        
        vm.getInfoSports(countryName: "MEXICO") { sportsObject in
            XCTAssertNotNil(sportsObject, "Information should not be nil")
            XCTAssertNotEqual(nilObject, sportsObject)
            print("Sports ====", sportsObject)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
    func testGetInfoMajorCities() {
                let expectation = self.expectation(description: "Retrieve whether an activity is completed")
                let nilMajorCities = MajorCities()
                vm.getInfoMajorCities(countryName: "MEXICO") { majorCitiesObject in
                    XCTAssertNotNil(majorCitiesObject, "Information should not be nil")
                    XCTAssertNotEqual(nilMajorCities, majorCitiesObject)
                    print("Major Cities ====", majorCitiesObject)
                    expectation.fulfill()
                }
                waitForExpectations(timeout: 5) { error in
                    if let error = error {
                        XCTFail("waitForExpectations error: \(error)")
                    }
                }
        }
    
func testGetInfoFood() {
          let expectation = self.expectation(description: "Retrieve TvMovie Data From Firebase")

      //             let nilObject = Food()

          vm.getInfoFood(countryName: "MEXICO") { food in
              XCTAssertNotNil(food, "Information should not be nil")
              print(food)
              expectation.fulfill()
          }

          waitForExpectations(timeout: 5) { error in
          if let error = error {
          XCTFail("waitForExpectations error: \(error)")
          }
        }
     }

    func testGetInfoDance() {
        let expectation = self.expectation(description: "Retrieve Dance Data From Firebase")
        
        let nilObject = Dance()
        
        vm.getInfoDance(countryName: "MEXICO") { danceObject in
            XCTAssertNotNil(danceObject, "Information should not be nil")
            XCTAssertNotEqual(nilObject, danceObject)
            XCTAssertEqual(10, danceObject.danceDictionary.count)
            print("Mexico Dance ====", danceObject)
        }
        
        vm.getInfoDance(countryName: "FRANCE") { danceObject in
            XCTAssertNotNil(danceObject, "Information should not be nil")
            XCTAssertNotEqual(nilObject, danceObject)
            XCTAssertEqual(6, danceObject.danceDictionary.count)
            print("France Dance ====", danceObject)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
        if let error = error {
        XCTFail("waitForExpectations error: \(error)")
        }
      }
   }
    
    func testGetInfoTvMovie() {
          let expectation = self.expectation(description: "Retrieve TvMovie Data From Firebase")

      //             let nilObject = Food()

          vm.getInfoTvMovie(countryName: "MEXICO") { tvMovie in
              XCTAssertNotNil(tvMovie, "Information should not be nil")
              print(tvMovie)
              expectation.fulfill()
          }

          waitForExpectations(timeout: 5) { error in
            if let error = error {
              XCTFail("waitForExpectations error: \(error)")
          }
        }
     }
    func testGetInfoMusic() {
        let expectation = self.expectation(description: "Retrieve Music Data From Firebase")
        
        let nilObject = Music()
        
        vm.getInfoMusic(countryName: "MEXICO") { musicObject in
            XCTAssertNotNil(musicObject, "Information should not be nil")
            XCTAssertNotEqual(nilObject, musicObject)
            print("Music ====", musicObject)
            print("Ganden Fung")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
          if let error = error {
              XCTFail("waitForExpectations error: \(error)")
          }
      }
    }
    func testGetCompletedCountries() {
        let expectation = self.expectation(description: "getCompletedCountries")
        vm.getCompletedCountries(userID: "Rik Roy") { countries in
            print("whaaa")
            print(countries)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectations error: \(error)")
            }
        }
    }
}

