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

/* Card Images (at top of screen) */
@property (strong, nonatomic) UIButton *firstCard;
@property (strong, nonatomic) UIButton *secondCard;
@property (strong, nonatomic) UIButton *thirdCard;
@property (strong, nonatomic) UIButton *fourthCard;

/* Choices */
@property (nonatomic) NSInteger smokeOrFireGuess;
@property (nonatomic) NSInteger highOrLowGuess;

/* Cards*/
@property (nonatomic, strong) PlayingCard *currentCard;
@property (nonatomic, strong) NSMutableArray *cards;    // of PlayingCard

@end

@implementation Card_GameViewController
{
    NSInteger gameState;
}

#pragma mark - Initializers

- (void) viewDidLoad
{
    self.smokeOrFireGuess = -1;
    self.deck = [[PlayingCardDeck alloc] init];
    
    self.firstCard.userInteractionEnabled = NO;
    self.CorrectOrDrinkLabel.hidden = YES;
    
    self.displayCard.userInteractionEnabled = NO;
    [self.displayCard setContentMode:UIViewContentModeScaleAspectFit];
    [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
    
    self.cards = [NSMutableArray array];
    
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
        case INOUT:
            [self.leftButton setTitle:@"Inside" forState:UIControlStateNormal];
            [self.rightButton setTitle:@"Outside" forState:UIControlStateNormal];
            
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
    
    if ([self.displayCard.currentTitle length])
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
        
        [self.cards addObject:[self.currentCard copy]];
    }
    
    self.flipCount++;
}

// Returns yes if guessed correctly, no otherwise
- (BOOL) checkSmokeOrFire
{
    if ([self.cards count] <= SMOKEFIRE)
        return NO;

    return (self.smokeOrFireGuess == [PlayingCard smokeOrFire:[self.cards objectAtIndex:SMOKEFIRE]]);
}

- (BOOL) checkHigherLower
{
    if ([self.cards count] <= HIGHLOW)
        return NO;
    
    return (self.highOrLowGuess == [PlayingCard highOrLow:[self.cards objectAtIndex:HIGHLOW] withPreviousCard:[self.cards objectAtIndex:SMOKEFIRE]]);
}

#pragma mark - Button Presses

- (IBAction)leftButtonPressed:(UIButton *)sender
{
    switch (gameState) {
        case SMOKEFIRE:
            [self flipCard];
            self.smokeOrFireGuess = SMOKE;
            [self smokeOrFire];

            break;
        case HIGHLOW:
            NSLog(@"left button - state: highLow");
            [self flipCard];
            self.highOrLowGuess = HIGH;
            [self highOrLow];
            
            break;
        default:
            break;
    }
    
}

- (IBAction)rightButtonPressed:(UIButton *)sender
{
    switch (gameState) {
        case SMOKEFIRE:
            [self flipCard];
            self.smokeOrFireGuess = FIRE;
            [self smokeOrFire];
            
            break;
        case HIGHLOW:
            NSLog(@"right button - state: highLow");
            [self flipCard];
            self.highOrLowGuess = LOW;
            [self highOrLow];
            
            break;
        default:
            break;
    }
    
}

- (void) smokeOrFire
{
    [self performSelector:@selector(moveCardToPositionIndex:) withObject:[NSNumber numberWithInt:SMOKEFIRE] afterDelay:2.0];
    [self setStatusLabelForCorrect:[self checkSmokeOrFire]];
    
    [self.CorrectOrDrinkLabel sizeToFit];
    self.CorrectOrDrinkLabel.hidden = NO;
}

- (void) highOrLow
{
    [self performSelector:@selector(moveCardToPositionIndex:) withObject:[NSNumber numberWithInt:HIGHLOW] afterDelay:2.0];
    [self setStatusLabelForCorrect:[self checkHigherLower]];
    
    [self.CorrectOrDrinkLabel sizeToFit];
    self.CorrectOrDrinkLabel.hidden = NO;
}

- (void) moveCardToPositionIndex:(NSNumber *)num
{
    NSInteger index = [num integerValue];
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
        case HIGHLOW:
        {
            CGRect btFrame = self.displayCard.frame;
            btFrame.origin.x = 80;
            btFrame.origin.y = 30;
            [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
            [self.displayCard setTitle:@"" forState:UIControlStateNormal];
            
            self.secondCard = [[UIButton alloc] initWithFrame:btFrame];
            [self.secondCard setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            [self.secondCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
            [self setTextColor:self.secondCard];
            
            NSLog(@"%@", [self.currentCard contents]);
            [self.view addSubview:self.secondCard];
            
            gameState = INOUT;
            [self initButtons];
            
            break;
            
        }
        default:
            break;
    }
    
}

- (void) setStatusLabelForCorrect:(BOOL)correct
{
    if (correct)
        self.CorrectOrDrinkLabel.text = @"CORRECT";
    else
        self.CorrectOrDrinkLabel.text = @"Take a drink";
}

- (void) clearStatusLabel
{
    self.CorrectOrDrinkLabel.text = @"";
}

- (void) setTextColor:(UIButton *)button
{
    if ([PlayingCard smokeOrFire:self.currentCard] == FIRE)
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


@end