//
//  ContentView.swift
//  TicTacToe
//
//  Created by Anshul Kanwar on 27/5/22.
//

import SwiftUI

func checkWinner(board: [[Character?]]) -> Character? {
    // Check for row
    var winner: Character? = nil
    
    for row in board {
        if row[0] == row[1] && row[1] == row[2] {
            winner = row[0]
        }
    }
    
    // Check for column
    for idx in 0...2 {
        if board[0][idx] == board[1][idx] && board[1][idx] == board[2][idx] {
            winner = board[0][idx]
        }
    }
    
    // Check for main diagonal
    if board[0][0] == board[1][1] && board[1][1] == board[2][2] {
        winner = board[0][0]
    }
    
    // Check for other diagonal
    if board[0][2] == board[1][1] && board[1][1] == board[2][0] {
        winner = board[0][2]
    }
    
    return winner
}

struct Tile: View {
    @Binding var marker: Character?
    @Binding var player: Character
    var handleWinner: () -> Void
    
    var body: some View {
        Button(LocalizedStringKey.init(String(marker ?? " "))) {
            if marker == nil {
                marker = player
                player = player == "X" ? "O" : "X"
                handleWinner()
            }
        }
        .padding(25.0)
        .frame(width: 120.0)
        .buttonStyle(.plain)
        .background(.white)
        .font(.system(size: 75))
        .fontWeight(.bold)
    }
}

struct Row: View {
    @Binding var row: [Character?]
    @Binding var player: Character
    var handleWinner: () -> Void
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { idx in
                Tile(marker: $row[idx], player: $player, handleWinner: handleWinner)
            }
        }
    }
}

struct ContentView: View {
    
    @State var board: [[Character?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    @State var player: Character = "X"
    
    @State var tries = 0
    @State var winner: Character? = nil
    @State var isGameOver = false
    
    var body: some View {
        VStack(spacing: 80) {
            VStack(spacing: 20) {
                Text("TicTacToe")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                
                Text("\(String(player))'s turn")
                    .font(.system(size: 30))
            }
            
            VStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { idx in
                    Row(row: $board[idx], player: $player) {
                        tries += 1
                        winner = checkWinner(board: board)
                        if winner != nil {
                            isGameOver = true
                        } else if tries == 9 {
                            isGameOver = true
                        }
                        
                        if isGameOver {
                            player = "X"
                            tries = 0
                            board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
                        }
                    }
                }
            }
            .background(.black)
            .aspectRatio(1.0, contentMode: .fill)
        }
        .alert(isPresented: $isGameOver) {
            Alert(title: Text("Game Over"), message: Text(winner != nil ? "\(String(winner!)) won" : "Its a draw"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
