//
//  PlayingCardDeck.m
//  lec1
//
//  Created by Nicholas Blackburn on 9/29/14.
//  Copyright (c) 2014 Nicholas Blackburn. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

// instance type
// an object of the same class type of the object that you sent this to
// perfect for when using init
// init will always return self
// used ONLY when using [[alloc .. ] init]
-  (instancetype) init
{
    self = [super init];
    if (self)
    {
        for (NSString *suit in [PlayingCard validSuits])
        {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++)
            {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
        }
    }
    
    return self;
}

@end
