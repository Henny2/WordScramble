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
        }
    }
    
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
        
    }
}

#Preview {
    ContentView()
}
