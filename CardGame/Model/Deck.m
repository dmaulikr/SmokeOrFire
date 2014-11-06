//
//  Deck.m
//  lec1
//
//  Created by Nicholas Blackburn on 9/28/14.
//  Copyright (c) 2014 Nicholas Blackburn. All rights reserved.
//

#import "Deck.h"

@interface Deck()

// mutable array of type Card
@property (strong, nonatomic) NSMutableArray *cards;
@end

@implementation Deck

- (NSMutableArray *) cards
{
    if (!_cards)
        _cards = [[NSMutableArray alloc] init];
    return _cards;
}

// adds a card to the top of the deck
- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop)
    {
        [self.cards insertObject:card atIndex:0];
    }
    else
    {
        [self.cards addObject:card];
    }
    
}

- (void)addCard:(Card *)card
{
    [self addCard:card atTop:NO];
}

// draws a random card from the deck
- (Card *)drawRandomCard
{
    Card *randomCard = nil;
    
    if ([self.cards count])
    {
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}

@end
