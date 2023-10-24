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
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
        }
    }
    
    // add validation methods here
    
    // isOriginal (not yet in the list)
    // isPossible (letters are in root word)
    // isRealWord (does exist)
    // another function for creating error message and title and toggle the alert boolean
    // lastly add the alert modifier to the view
    
    
    
    func addNewWord() -> Void {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
       
        // more validation to come
        withAnimation{
            usedWords.insert(newWord, at: 0)
        }
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
