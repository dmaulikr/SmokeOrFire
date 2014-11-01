//
//  PlayingCard.m
//  lec1
//
//  Created by Nicholas Blackburn on 9/29/14.
//  Copyright (c) 2014 Nicholas Blackburn. All rights reserved.
//

#import "PlayingCard.h"
#import "Utilities.h"

@interface PlayingCard()

@end

@implementation PlayingCard

- (NSString *) contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;   // becuase we probide setter AND getter

// class methods (for creating and utilization)
+ (NSArray *) validSuits
{
    return @[@"♥︎", @"♦︎", @"♣︎", @"♠︎"];
}

+ (NSArray *) rankStrings
{
    return @[@"?", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", @"A"];
}

+ (NSUInteger) maxRank
{
    return [[self rankStrings] count] - 1;
}
// setter for Suit property
- (void)setSuit:(NSString *) suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

// getter for Suit property
- (NSString *) suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
        _rank = rank;
}

// TODO: why isnt this implementation working in GameLogic?
//      doesnt recognize object suit??
+ (NSInteger) smokeOrFire:(PlayingCard *)card
{
    if ([card.suit isEqualToString:@"♣︎" ] || [card.suit isEqualToString:@"♠︎"])
        return SMOKE;
    else if ([card.suit isEqualToString:@"♥︎"] || [card.suit isEqualToString:@"♦︎"])
        return FIRE;
    else
        return -1;
    
}

+ (NSInteger) highOrLow:(PlayingCard *)currentCard withPreviousCard:(PlayingCard *)previousCard
{
    if (currentCard.rank < previousCard.rank)
        return LOW;
    else if (currentCard.rank > previousCard.rank)
        return HIGH;
    else
        return PUSH;
}

+ (NSInteger) inOrOut:(PlayingCard *)currentCard withSecondCard:(PlayingCard *)secondCard withFirstCard:(PlayingCard *)firstCard
{
    if (currentCard.rank >= secondCard.rank)
    {
        if (currentCard.rank <= firstCard.rank)
            return IN;
        else
            return OUT;
    }
    else if (currentCard.rank < secondCard.rank)
    {
        if (currentCard.rank >= firstCard.rank)
            return IN;
        else
            return OUT;
    }
    else
        return -1;
}

// ability to be copied
- (id) copyWithZone:(NSZone *)zone
{
    PlayingCard *newCard = [[PlayingCard alloc] init];
    newCard.suit = self.suit;
    newCard.rank = self.rank;
    
    return newCard;
}

@end
