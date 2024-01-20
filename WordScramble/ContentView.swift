//
//  ContentView.swift
//  WordScramble
//
//  Created by Henrieke Baunack on 10/23/23.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorMessage = ""
    @State private var errorTitle = ""
    @State private var showAlert = false
    @State private var usersScore = 0
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Put in a word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section{
                    ForEach(usedWords, id: \.self){ word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        // the following would just group the views together
//                        .accessibilityElement(children: .combine)
                        // the following will group them and ignore their labels which means we have to add a custom label
                        .accessibilityElement()
                        .accessibilityLabel("\(word), \(word.count) letters")
                    }
                }
            }
            .navigationTitle(rootWord)
            .toolbar{
                HStack{
                    Text("Score: \(usersScore)").font(.headline)
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Button("New game", action: startGame)
                }
            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showAlert){} message: {
                Text(errorMessage)
            }
        }
    }
    
    // add validation methods here
    
    // another function for creating error message and title and toggle the alert boolean
    // lastly add the alert modifier to the view
    
    func createAlert(title: String, message: String) {
        errorMessage = message
        errorTitle = title
        showAlert = true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
//    So, our last method will make an instance of UITextChecker, which is responsible for scanning strings for misspelled words. We’ll then create an NSRange to scan the entire length of our string, then call rangeOfMisspelledWord() on our text checker so that it looks for wrong words. When that finishes we’ll get back another NSRange telling us where the misspelled word was found, but if the word was OK the location for that range will be the special value NSNotFound.
    
    func isRealWord(word:String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isLongEnough(word:String) -> Bool {
        return word.count >= 3
    }
    
    func isNotRootWord(word:String) -> Bool {
        return word != rootWord
    }
    
    func scoreWord(word:String) -> Int {
        return word.count
    }
    
    
    func addNewWord() -> Void {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
       
        guard isOriginal(word: newWord) else {
            createAlert(title: "Word already submitted!", message: "Try something else!")
            return
        }
        guard isRealWord(word: newWord) else {
            createAlert(title: "This is not a real word!", message: "Try something real!")
            return
        }
        guard isPossible(word: newWord) else {
            createAlert(title: "This word is not possible!", message: "Try a different combination")
            return
        }
        guard isLongEnough(word: newWord) else {
            createAlert(title: "Word is not long enough!", message: "Your word has to have at least three characters!")
            return
        }
        guard isNotRootWord(word: newWord) else {
            createAlert(title: "Submitting the root word does not count!", message: "Be more creative!")
            return
        }
        
        withAnimation{
            usedWords.insert(newWord, at: 0)
        }
        usersScore += scoreWord(word: newWord)
        newWord = ""
    }
    
    func startGame(){
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                // when we get here, everything worked and we have a 8 letter root word
                return
            }
        }
        // something went wrong with loading the file
        fatalError("Could not load start.txt from bundle!")
    }
}

#Preview {
    ContentView()
}
