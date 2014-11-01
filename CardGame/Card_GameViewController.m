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

/* Additional Suit Images */

@property (strong, nonatomic) IBOutlet UIButton *firstSuit;
@property (strong, nonatomic) IBOutlet UIButton *secondSuit;

/* Choices */
@property (nonatomic) NSInteger smokeOrFireGuess;
@property (nonatomic) NSInteger highOrLowGuess;
@property (nonatomic) NSInteger inOrOutGuess;
@property (nonatomic) NSString *suitGuess;

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
    
    self.firstSuit.hidden = YES;
    self.secondSuit.hidden = YES;
    
    self.firstCard.userInteractionEnabled = NO;
    self.secondCard.userInteractionEnabled = NO;
    self.thirdCard.userInteractionEnabled = NO;
    self.fourthCard.userInteractionEnabled = NO;
    self.firstSuit.userInteractionEnabled = NO;
    self.secondSuit.userInteractionEnabled = NO;
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
            // TODO: DISABLE SMOKE AND FIRE BUTTONS WHEN THEY ARE USELESS
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
            
            self.firstSuit.userInteractionEnabled = YES;
            self.secondSuit.userInteractionEnabled = YES;
            
            break;
        case SUIT:
            [self.leftButton setTitle:@"♥︎" forState:UIControlStateNormal];
            self.leftButton.font = [UIFont systemFontOfSize:28.0];
            [self.leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.rightButton setTitle:@"♠︎" forState:UIControlStateNormal];
            self.rightButton.font = [UIFont systemFontOfSize:28.0];
            [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.firstSuit setTitle:@"♦︎" forState:UIControlStateNormal];
            self.firstSuit.font = [UIFont systemFontOfSize:28.0];
            [self.firstSuit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.secondSuit setTitle:@"♣︎" forState:UIControlStateNormal];
            self.secondSuit.font = [UIFont systemFontOfSize:28.0];
            [self.secondSuit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.firstSuit.hidden = NO;
            self.secondSuit.hidden = NO;
            
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

- (BOOL) checkInOut
{
    if ([self.cards count] <= INOUT)
        return NO;
    
    return (self.inOrOutGuess == [PlayingCard inOrOut:[self.cards objectAtIndex:INOUT] withSecondCard:[self.cards objectAtIndex:HIGHLOW] withFirstCard:[self.cards objectAtIndex:SMOKEFIRE]]);
}

- (BOOL) checkSuit
{
    if ([self.cards count] <= SUIT)
        return NO;
    
    return ([self.currentCard.suit isEqualToString:self.suitGuess]);
}

#pragma mark - Button Presses

- (IBAction)leftButtonPressed:(UIButton *)sender
{
    self.leftButton.userInteractionEnabled = NO;
    self.rightButton.userInteractionEnabled = NO;
    
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
        case INOUT:
            NSLog(@"left button - state: inOut");
            [self flipCard];
            self.inOrOutGuess = IN;
            [self inOrOut];
            
            break;
        case SUIT:
            NSLog(@"left button - state: suit");
            self.firstSuit.userInteractionEnabled = NO;
            self.secondSuit.userInteractionEnabled = NO;
            [self flipCard];
            self.suitGuess = @"♥︎";
            [self whichSuit];
            
            break;
        default:
            break;
    }
    
}

- (IBAction)rightButtonPressed:(UIButton *)sender
{
    self.leftButton.userInteractionEnabled = NO;
    self.rightButton.userInteractionEnabled = NO;
    
    switch (gameState) {
        case SMOKEFIRE:
            [self flipCard];
            self.smokeOrFireGuess = FIRE;
            [self smokeOrFire];
            
            break;
        case HIGHLOW:
            NSLog(@"right button - state: highLow");
            [self flipCard];
            self.highOrLowGuess = LOW;;
            [self highOrLow];
            
            break;
        case INOUT:
            NSLog(@"right button - state: inOut");
            [self flipCard];
            self.inOrOutGuess = OUT;
            [self inOrOut];
            
            break;
        case SUIT:
            NSLog(@"right button - state: suit");
            self.firstSuit.userInteractionEnabled = NO;
            self.secondSuit.userInteractionEnabled = NO;
            [self flipCard];
            self.suitGuess = @"♠︎";
            [self whichSuit];
            
            break;
        default:
            break;
    }
    
}

- (IBAction)firstSuitPressed:(UIButton *)sender
{
    self.firstSuit.userInteractionEnabled = NO;
    self.secondSuit.userInteractionEnabled = NO;
    self.leftButton.userInteractionEnabled = NO;
    self.rightButton.userInteractionEnabled = NO;
    NSLog(@"firstSuit button - state: suit");
    [self flipCard];
    self.suitGuess = @"♦︎";
    [self whichSuit];
}

- (IBAction)secondSuitPressed:(UIButton *)sender
{
    self.firstSuit.userInteractionEnabled = NO;
    self.secondSuit.userInteractionEnabled = NO;
    self.leftButton.userInteractionEnabled = NO;
    self.rightButton.userInteractionEnabled = NO;
    NSLog(@"secondSuit button - state: suit");
    [self flipCard];
    self.suitGuess = @"♣︎";
    [self whichSuit];
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

- (void) inOrOut
{
    [self performSelector:@selector(moveCardToPositionIndex:) withObject:[NSNumber numberWithInt:INOUT] afterDelay:2.0];
    [self setStatusLabelForCorrect:[self checkInOut]];
    
    [self.CorrectOrDrinkLabel sizeToFit];
    self.CorrectOrDrinkLabel.hidden = NO;
}

- (void) whichSuit
{
    [self performSelector:@selector(moveCardToPositionIndex:) withObject:[NSNumber numberWithInt:SUIT] afterDelay:2.0];
    [self setStatusLabelForCorrect:[self checkSuit]];
    
    [self.CorrectOrDrinkLabel sizeToFit];
    self.CorrectOrDrinkLabel.hidden = NO;
}

- (void) moveCardToPositionIndex:(NSNumber *)num
{
    if (gameState != SUIT)
    {
        self.leftButton.userInteractionEnabled = YES;
        self.rightButton.userInteractionEnabled = YES;
    }
    
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
            btFrame.origin.x = 90;
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
        case INOUT:
        {
            CGRect btFrame = self.displayCard.frame;
            btFrame.origin.x = 165;
            btFrame.origin.y = 30;
            [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
            [self.displayCard setTitle:@"" forState:UIControlStateNormal];
            
            self.thirdCard = [[UIButton alloc] initWithFrame:btFrame];
            [self.thirdCard setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            [self.thirdCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
            [self setTextColor:self.thirdCard];
            
            NSLog(@"%@", [self.currentCard contents]);
            [self.view addSubview:self.thirdCard];
            
            gameState = SUIT;
            [self initButtons];
            
            break;
        }
        case SUIT:
        {
            CGRect btFrame = self.displayCard.frame;
            btFrame.origin.x = 240;
            btFrame.origin.y = 30;
            [self.displayCard setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
            [self.displayCard setTitle:@"" forState:UIControlStateNormal];
            
            self.fourthCard = [[UIButton alloc] initWithFrame:btFrame];
            [self.fourthCard setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            [self.fourthCard setTitle:[self.currentCard contents] forState:UIControlStateNormal];
            [self setTextColor:self.fourthCard];
            
            NSLog(@"%@", [self.currentCard contents]);
            [self.view addSubview:self.fourthCard];
            
            gameState = REPLAY;
//            [self initButtons];
            
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