//
//  Deck.h
//  lec1
//
//  Created by Nicholas Blackburn on 9/28/14.
//  Copyright (c) 2014 Nicholas Blackburn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
