//
//  PlayingCard.h
//  lec1
//
//  Created by Nicholas Blackburn on 9/29/14.
//  Copyright (c) 2014 Nicholas Blackburn. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card <NSCopying>

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

// Implementing the basic elements of a card, suit and rank
+ (NSArray *) validSuits;
+ (NSUInteger) maxRank;
+ (NSArray *) rankStrings;

// Checkers
+ (NSInteger) smokeOrFire:(PlayingCard *)card;
+ (NSInteger) highOrLow:(PlayingCard *)currentCard withPreviousCard:(PlayingCard *)previousCard;
+ (NSInteger) inOrOut:(PlayingCard *)currentCard withSecondCard:(PlayingCard *)secondCard withFirstCard:(PlayingCard *)firstCard;

- (NSString *) contents;

@end
