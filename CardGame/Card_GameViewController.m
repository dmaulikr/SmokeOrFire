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
@property (nonatomic) int flipCount;
@property (nonatomic, strong) PlayingCardDeck *deck;

/* Buttons */
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *displayCard;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UILabel *CorrectOrDrinkLabel;

@property (strong, nonatomic) UIButton *firstCard;

/* Choices */
@property (nonatomic) NSInteger smokeOrFire;

@property (nonatomic, strong) PlayingCard *currentCard;

@end

@implementation Card_GameViewController
{
    NSInteger gameState;
}

#pragma mark - Initializers

- (void) viewDidLoad
{
    self.smokeOrFire = -1;
    self.deck = [[PlayingCardDeck alloc] init];
    [self.displayCard setContentMode:UIViewContentModeScaleAspectFit];
    [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
    self.displayCard.userInteractionEnabled = NO;
    self.firstCard.userInteractionEnabled = NO;
    self.CorrectOrDrinkLabel.hidden = YES;
    
    gameState = SMOKEFIRE;
}

- (void) initButtons
{
    switch (gameState) {
        case SMOKEFIRE:
            // Left Button init
            [self.leftButton setTitle:@"Smoke" forState:UIControlStateNormal];
            [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            // Right Button init
            [self.rightButton setTitle:@"Fire" forState:UIControlStateNormal];
            [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            break;
        case HIGHLOW:
            [self.leftButton setTitle:@"Higher" forState:UIControlStateNormal];
            
            [self.rightButton setTitle:@"Lower" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark - Helpers


- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    NSLog(@"flipCount = %d", self.flipCount);
}

- (void) flipCard
{
    // use drawRandomCard
    // flip the card from the image side to the actual card side
    // displaying *the contents*
    
    if ([self.displayCard.currentTitle length] )
    {
        [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"]
                                forState:UIControlStateNormal];
        [self.displayCard setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"%@", [UIImage imageNamed:@"cardFront"]);
        [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardFront"]
                                forState:UIControlStateNormal];
        
    // draws random card from deck, type: PlayingCard, varName: currentCard
        self.currentCard = (PlayingCard *)[self.deck drawRandomCard];
        
    /*  for debugging
         
    if ([newCard smokeOrFire] == SMOKE)
     NSLog(@"Smoke");
    else
     NSLog(@"Fire");    */
        
        [self.displayCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
        [self setTextColor:self.displayCard];
    }
    self.flipCount++;
}

// TODO: need help making this work
//- (void) timeDelay:(NSInteger) num
//{
//    [self performSelector:@selector(moveCardToPositionIndex:) withObject:SMOKEFIRE afterDelay:2.0];
//}

// Returns yes if guessed correctly, no otherwise
- (BOOL) checkSmokeOrFire
{
    // Time Delay for 2s before location change
    [self performSelector:@selector(moveCardToPositionIndex:) withObject:SMOKEFIRE afterDelay:2.0];
    
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

//- (BOOL) checkHigherLower
//{
//    // activate when finished
//    //[self performSelector:@selector(moveCardToPositionIndex:) withObject:HIGHLOW afterDelay:2.0];
//    
//    
//    // fix this
//    return NO;
//}

#pragma mark - Button Presses

- (IBAction)leftButtonPressed:(UIButton *)sender
{
    switch (gameState) {
        case SMOKEFIRE:
            [self flipCard];
            self.smokeOrFire = SMOKE;
            [self checkSmokeOrFire];
            break;
        case HIGHLOW:
            NSLog(@"left button - state: highLow");
            // TODO: implement highlow, card flow
        default:
            break;
    }
    

    // now do higher or lower
}

- (IBAction)rightButtonPressed:(UIButton *)sender
{
    switch (gameState) {
        case SMOKEFIRE:
            [self flipCard];
            self.smokeOrFire = FIRE;
            [self checkSmokeOrFire];
            break;
        case HIGHLOW:
            NSLog(@"right button - state: highLow");
            // TODO: implement highlow, card flow
        default:
            break;
    }
    
}

- (void) moveCardToPositionIndex:(NSInteger)index
{
    self.CorrectOrDrinkLabel.hidden = YES;
    
    switch (index) {
        case SMOKEFIRE:
        {
            CGRect btFrame = self.displayCard.frame;
            btFrame.origin.x = 15;
            btFrame.origin.y = 30;
            [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
            [self.displayCard setTitle:@"" forState:UIControlStateNormal];
            
            self.firstCard = [[UIButton alloc] initWithFrame:btFrame];
            [self.firstCard setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            [self.firstCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
            [self setTextColor:self.firstCard];
            
            NSLog(@"%@", [self.currentCard contents]);
            [self.view addSubview:self.firstCard];
            
            gameState = HIGHLOW;
            [self initButtons];
            break;
        }
//        case HIGHLOW:
//        {
//            // TODD: implement this feature
//        }
        default:
            break;
    }
    
}

- (void) setTextColor:(UIButton *)button
{
    if (self.currentCard.smokeOrFire == FIRE)
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


@end