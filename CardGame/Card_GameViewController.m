//
//  Card_GameViewController.m
//  CardGame
//
//  Created by Nicholas Blackburn on 9/29/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "Card_GameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "Utilities.h"

@interface Card_GameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (nonatomic, strong) PlayingCardDeck *deck;

/* Buttons */
@property (strong, nonatomic) IBOutlet UIButton *smokeButton;
@property (strong, nonatomic) IBOutlet UIButton *displayCard;
@property (strong, nonatomic) IBOutlet UIButton *fireButton;
@property (strong, nonatomic) IBOutlet UILabel *CorrectOrDrinkLabel;


/* Choices */
@property (nonatomic) NSInteger smokeOrFire;

@property (nonatomic, strong) PlayingCard *currentCard;

@end

@implementation Card_GameViewController

- (void) viewDidLoad
{
    self.smokeOrFire = -1;
    self.deck = [[PlayingCardDeck alloc] init];
    [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardback"] forState:UIControlStateNormal];
    self.CorrectOrDrinkLabel.hidden = YES;
}

- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flipCount = %d", self.flipCount);
}

- (void) flipCard
{
    
    // use drawRandomCard
    // flip the card from the image side to the actual card side
    // displaying *the contents*
    
    if ([_displayCard.currentTitle length] )
    {
        [_displayCard setBackgroundImage:[UIImage imageNamed:@"cardback"]
                          forState:UIControlStateNormal];
        [_displayCard setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        [_displayCard setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                          forState:UIControlStateNormal];
        
        self.currentCard = (PlayingCard *)[self.deck drawRandomCard];
        
        /*  for debugging
         
         if ([newCard smokeOrFire] == SMOKE)
         NSLog(@"Smoke");
         else
         NSLog(@"Fire");
         */
        
        
        [_displayCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
    }
    self.flipCount++;
}

// Returns yes if guessed correctly, no otherwise
- (BOOL) checkSmokeOrFire
{
    BOOL status = self.smokeOrFire == [self.currentCard smokeOrFire];
    
    if (status)
        self.CorrectOrDrinkLabel.text = @"CORRECT";
    else
        self.CorrectOrDrinkLabel.text = @"Take a drink";

  // not working properly if use sizeToFit
    [self.CorrectOrDrinkLabel sizeToFit];
    self.CorrectOrDrinkLabel.hidden = NO;
    
    return status;
}

- (IBAction)smokeButtonPressed:(UIButton *)sender
{
    [self flipCard];
    self.smokeOrFire = SMOKE;
    [self checkSmokeOrFire];

   // wait 2 seconds, then automatically flip the card back over
    // without using a new card
    // move the image to the top right corner
    // now do higher or lower
}

- (IBAction)fireButtonPressed:(UIButton *)sender
{
    [self flipCard];
    self.smokeOrFire = FIRE;
    [self checkSmokeOrFire];
    
//    if ([self checkSmokeOrFire])
//        NSLog(@"CORRECT");
//    else
//        NSLog(@"WRONG");
}





@end
