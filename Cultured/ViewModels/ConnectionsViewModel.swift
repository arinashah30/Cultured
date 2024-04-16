//
//  ConnectionsViewModel.swift
//  Cultured
//
//  Created by Austin Huguenard on 2/13/24.
//

import Foundation
import OrderedCollections

class ConnectionsViewModel: ObservableObject {
    var connections: [String : Connections] = [:]
    @Published var viewModel: ViewModel
    @Published var current_connections_game: Connections? = nil
    let categories = ["Culture", "Food", "Customs", "Places"]
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func load_connections(completion: @escaping (Bool) -> Void) {
        if viewModel.current_user != nil && !viewModel.current_user!.country.isEmpty {
            var activityNames = categories
            var i = 0
            for activity in activityNames {
                activityNames[i] = "\(self.viewModel.current_user!.country)\(activity)Connections"
                i += 1
            }
            viewModel.getAllActivitiesOfType(userId: viewModel.current_user!.id, type: "connections", completion: { activities in
                for activity in activityNames {
                    self.viewModel.getConnectionsFromFirebase(activityName: activity, completion: { connInfo in
                        if var connInfo = connInfo {
                            if let activityHistory = activities[activity] {
                                let history = activityHistory["history"] as! [String]
                                
                                
                                var splitHistory: [[String]] = []
                                let size = 4

                                for index in stride(from: 0, to: history.count, by: size) {
                                    let endIndex = index + size < history.count ? index + size : history.count
                                    splitHistory.append(Array(history[index..<endIndex]))
                                    connInfo.history.append(splitHistory[splitHistory.count - 1])
                                }
                                
                                for history in splitHistory {
                                    var amount_correct: [String: Int] = [:]
                                    for index in history.indices {
                                        for item in connInfo.answer_key {
                                            for submittedOption in item.value {
                                                if submittedOption.content == history[index] {
                                                    amount_correct.updateValue((amount_correct[item.key] ?? 0) + 1, forKey: item.key)
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                    if amount_correct.values.contains(4) {
                                        connInfo.points += 25
                                        let category = Array(amount_correct.keys)[0]
                                        for index in history.indices {
                                            for index2 in connInfo.options.indices {
                                                if connInfo.options[index2].content == history[index] {
                                                    connInfo.options.remove(at: index2)
                                                    break
                                                }
                                            }
                                        }
                                        
                                        var historyOptions: [Connections.Option] = []
                                        for historyItem in history {
                                            historyOptions.append(Connections.Option(content: historyItem, category: category))
                                        }
                                        
                                        connInfo.correct_history.updateValue(historyOptions, forKey: category)
                                    } else if amount_correct.values.contains(3) {
                                        var historyOptions: [Connections.Option] = []
                                        for historyItem in history {
                                            for item in connInfo.answer_key {
                                                for submittedOption in item.value {
                                                    if submittedOption.content == historyItem {
                                                        historyOptions.append(Connections.Option(content: historyItem, category: item.key))
                                                    }
                                                }
                                            }
                                            
                                        }
                                        connInfo.mistake_history.updateValue(true, forKey: historyOptions)
                                    } else {
                                        var historyOptions: [Connections.Option] = []
                                        for historyItem in history {
                                            for item in connInfo.answer_key {
                                                for submittedOption in item.value {
                                                    if submittedOption.content == historyItem {
                                                        historyOptions.append(Connections.Option(content: historyItem, category: item.key))
                                                    }
                                                }
                                            }
                                        }
                                        connInfo.mistake_history.updateValue(false, forKey: historyOptions)
                                    }
                                }
                                
                                connInfo.mistakes_remaining = 4 - (activityHistory["current"] as? Int ?? 0)
                            }
                            
                            
                            self.connections[activity] = connInfo
                        }
                    })
                }
            })
        }
    }
    
    func start_connections(category: String, completion: @escaping () -> ()) {
        if (connections["\(viewModel.current_user!.country)\(category)Connections"] != nil && !connections["\(viewModel.current_user!.country)\(category)Connections"]!.title.isEmpty) {
            current_connections_game = connections["\(viewModel.current_user!.country)\(category)Connections"]
            if current_connections_game!.history.count == 0 {
                viewModel.addOnGoingActivity(userID: viewModel.current_user!.id, titleOfActivity: current_connections_game!.title, typeOfActivity: "connections", completion: { _ in
                    completion()
                })
            } else {
                completion()
            }
        }
    }
    
        
    var options: [Connections.Option] {
        return current_connections_game!.options
    }
    
    var mistake_history: OrderedDictionary<[Connections.Option], Bool> {
        return current_connections_game!.mistake_history
    }
    
    var mistake_history_keys: [[Connections.Option]] {
        var store: [[Connections.Option]] = []
        for key in current_connections_game!.mistake_history.keys {
            store.append(key)
        }
        return store
    }
    
    var correct_history: OrderedDictionary<String, [Connections.Option]> {
        return current_connections_game!.correct_history
    }
    
    var correct_history_keys: [String] {
        var store: [String] = []
        for key in current_connections_game!.correct_history.keys {
            store.append(key)
        }
        return store
    }
    
    var selection: [Connections.Option] {
        return current_connections_game!.selection
    }
    
    var mistakes_remaining: Int {
        return current_connections_game!.mistakes_remaining
    }
    
    var one_away: Bool {
        return current_connections_game!.one_away
    }
    
    var already_guessed: Bool {
        return current_connections_game!.already_guessed
    }
    
    func select(_ option: Connections.Option) {
        //print(option.content)
        let chosenIndex = index(of: option)
        if chosenIndex >= 0 {
            if !options[chosenIndex].isSelected {
                if selection.count < 4 {
                    current_connections_game!.options[chosenIndex].isSelected = true
                    current_connections_game!.selection.append(options[chosenIndex])
                }
            } else {
                current_connections_game!.options[chosenIndex].isSelected = false
                for index in selection.indices {
                    if selection[index].content == options[chosenIndex].content {
                        current_connections_game!.selection.remove(at: index)
                        break
                    }
                }
            }
        }
    }
    
    func index(of option: Connections.Option) -> Int {
        for index in options.indices {
            if options[index] == option {
                return index
            }
        }
        
        return -1
    }
    
    func submit(completion: @escaping () -> ()) {
        if selection.count == 4 && current_connections_game!.mistakes_remaining != 0 {
            var temp_selection: [Connections.Option] = selection
            temp_selection.sort()
            
            for key in mistake_history.keys {
                var temp_key: [Connections.Option] = key
                temp_key.sort()
                
                if (temp_key == temp_selection) {
                    current_connections_game!.already_guessed = true
                    return
                }
            }
            
            var selectionString: [String] = []
            for selectionTile in selection {
                selectionString.append(selectionTile.content)
            }
            current_connections_game!.history.append(selectionString)
            viewModel.updateHistory(userID: viewModel.current_user!.id, activity: current_connections_game!.title, history: current_connections_game!.history.flatMap{$0}) { _ in
                var amount_correct: [String: Int] = [:]
                
                for index in self.selection.indices {
                    let category: String = self.selection[index].category
                    amount_correct.updateValue((amount_correct[category] ?? 0) + 1, forKey: category)
                }
                
                for index in self.selection.indices {
                    for index2 in self.options.indices {
                        if self.options[index2].content == self.selection[index].content {
                            self.current_connections_game!.options[index2].isSelected = false
                        }
                    }
                }
                
                if amount_correct.values.contains(4) {
                    self.current_connections_game!.points += 25
                    
                    for index in self.selection.indices {
                        for index2 in self.options.indices {
                            if self.options[index2].content == self.selection[index].content {
                                self.current_connections_game!.options.remove(at: index2)
                                break
                            }
                        }
                    }
                    
                    self.current_connections_game!.correct_history.updateValue(self.selection, forKey: self.selection[0].category)
                    self.current_connections_game!.selection = []
                    
                    if self.current_connections_game!.points == 100 {
                        self.viewModel.updateCompleted(userID: self.viewModel.current_user!.id, activity: self.current_connections_game!.title, completed: true, completion: { _ in
                            self.viewModel.updateScore(userID: self.viewModel.current_user!.id, activity: self.current_connections_game!.title, newScore: self.current_connections_game!.points, completion: { _ in
                                self.viewModel.update_points(userID: self.viewModel.current_user!.id, pointToAdd: self.current_connections_game!.points, completion: { success in
                                    self.viewModel.current_user!.points = success
                                    completion()
                                })
                            })
                        })
                    } else {
                        completion()
                    }
                } else {
                    if amount_correct.values.contains(3) {
                        self.current_connections_game!.mistake_history.updateValue(true, forKey: self.selection)
                        self.current_connections_game!.one_away = true
                    } else {
                        self.current_connections_game!.mistake_history.updateValue(false, forKey: self.selection)
                    }
                    self.viewModel.incrementCurrent(userID: self.viewModel.current_user!.id, activityName: self.current_connections_game!.title, completion: { _ in
                        self.current_connections_game!.mistakes_remaining -= 1
                        self.current_connections_game!.selection = []
                        if self.current_connections_game!.mistakes_remaining == 0 {
                            self.current_connections_game!.options.removeAll()
                            
                            for (key, value) in self.current_connections_game!.answer_key {
                                if !self.current_connections_game!.correct_history.keys.contains(key) {
                                    self.current_connections_game!.correct_history.updateValue(value, forKey: key)
                                }
                            }
                            
                            self.viewModel.updateCompleted(userID: self.viewModel.current_user!.id, activity: self.current_connections_game!.title, completed: true, completion: { _ in
                                self.viewModel.updateScore(userID: self.viewModel.current_user!.id, activity: self.current_connections_game!.title, newScore: self.current_connections_game!.points, completion: { _ in
                                    self.viewModel.update_points(userID: self.viewModel.current_user!.id, pointToAdd: self.current_connections_game!.points, completion: { success in
                                        self.viewModel.current_user!.points = success
                                        
                                        completion()
                                    })
                                })
                            })
                        } else {
                            completion()
                        }
                    })
                }
                
            }
        }
    }
    
    func shuffle() {
        current_connections_game!.options.shuffle()
    }
    
    func reset_alerts() {
        current_connections_game!.one_away = false
        current_connections_game!.already_guessed = false
    }
    
    func getProgress() -> [Float] {
        var progress: [Float] = []
        if let country = viewModel.current_user?.country {
            for category in categories {
                print(connections["\(country)\(category)Connections"])
                if (Array(connections.keys).firstIndex(of: "\(country)\(category)Connections") != nil) {
                    if connections["\(country)\(category)Connections"]!.mistakes_remaining == 0 || connections["\(country)\(category)Connections"]!.correct_history.count == 4 {
                        progress.append(1.0)
                    } else {
                        progress.append(Float(connections["\(country)\(category)Connections"]!.history.count) / Float(7))
                    }
                } else {
                    progress.append(0.0)
                }
            }
        } else {
            return [0.0, 0.0, 0.0, 0.0]
        }
        print(progress)
        return progress
    }
}
