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
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
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

- (NSInteger) smokeOrFire
{
    if ([self.suit isEqualToString:@"♣︎" ] || [self.suit isEqualToString:@"♠︎"])
        return SMOKE;
    else if ([self.suit isEqualToString:@"♥︎"] || [self.suit isEqualToString:@"♦︎"])
        return FIRE;
    else
        return -1;
    
}

@end
