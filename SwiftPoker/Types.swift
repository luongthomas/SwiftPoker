//
//  Types.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/19/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Swift

public enum Suit {
    case hearts
    case spades
    case diamonds
    case clubs

    public enum Color {
        case black
        case red
    }

    public var color: Color {
        switch self {
        case .hearts, .diamonds: return .red
        case .spades, .clubs: return .black
        }
    }

    public static var allSuits: Set<Suit> {
        return [.hearts, .spades, .diamonds, .clubs]
    }
}

extension Suit: CustomStringConvertible {
    public var description: String {
        switch self {
        case .hearts: return "♥️"
        case .spades: return "♠️"
        case .diamonds: return "♦️"
        case .clubs: return "♣️"
        }
    }
}

public enum Number {
    case ace
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king

    fileprivate static let allNumbers: [Number] = [.two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king, .ace]
}

extension Number: Comparable {
    public static func <(lhs: Number, rhs: Number) -> Bool {
        return Number.compare(aceAsLowestCard: false)(lhs, rhs)
    }

    static func compare(aceAsLowestCard: Bool) -> (Number, Number) -> Bool  {
        return { lhs, rhs in
            return lhs.numericValue(aceAsLowestCard: aceAsLowestCard) < rhs.numericValue(aceAsLowestCard: aceAsLowestCard)
        }
    }
}

extension Number {
    func numericValue(aceAsLowestCard: Bool = false) -> Int {
        switch self {
        case .ace: return aceAsLowestCard ? 1 : 14
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten: return 10
        case .jack: return 11
        case .queen: return 12
        case .king: return 13
        }
    }
}

extension Number: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ace: return "A"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .ten: return "10"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        }
    }
}

public struct Card {
    public let suit: Suit
    public let number: Number

    public init(suit: Suit, number: Number) {
        self.suit = suit
        self.number = number
    }
}

extension Card: Hashable {
    public var hashValue: Int {
        return self.suit.hashValue ^ self.number.hashValue
    }

    public static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.suit == rhs.suit && lhs.number == rhs.number
    }
}

extension Card: CustomStringConvertible {
    public var description: String {
        return "\(self.number)\(self.suit)"
    }
}

public struct Deck {
    public var cards: [Card]

    public static var sortedDeck: Deck {
        var cards: [Card] = []

        for suit in Suit.allSuits {
            for number in Number.allNumbers {
                cards.append(Card(suit: suit, number: number))
            }
        }

        return Deck(cards: cards)
    }

    public mutating func shuffle() {
        var cards = self.cards

        for index in cards.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count - 1)))

            if index == randomIndex {
                continue
            }

            swap(&cards[index], &cards[randomIndex])
        }

        self.cards = cards
    }

    public var shuffled: Deck {
        var deck = self
        deck.shuffle()
        
        return deck
    }
}

extension Deck: CustomStringConvertible {
    public var description: String {
        return self.cards
            .map { $0.description }
            .joined(separator: ", ")
    }
}
