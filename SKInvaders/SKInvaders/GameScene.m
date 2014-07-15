//
//  GameScene.m
//  SKInvaders
//

//  Copyright (c) 2013 RepublicOfApps, LLC. All rights reserved.
//

#import "GameScene.h"
#import <CoreMotion/CoreMotion.h>

#pragma mark - Custom Type Definitions

typedef enum InvaderType {
    InvaderTypeA,
    InvaderTypeB,
    InvaderTypeC
} InvaderType;

typedef enum InvaderMovementDirection {
    InvaderMovementDirectionRight,
    InvaderMovementDirectionLeft,
    InvaderMovementDirectionDownThenRight,
    InvaderMovementDirectionDownThenLeft,
    InvaderMovementDirectionNone
} InvaderMovementDirection;

#define kInvaderSize CGSizeMake(24, 16)
#define kInvaderGridSpacing CGSizeMake(12, 12)
#define kInvaderRowCount 6
#define kInvaderColCount 6

#define kInvaderName @"invader"

#define kShipSize CGSizeMake(30, 16)
#define kShipName @"ship"

#define kScoreHudName @"scoreHud"
#define kHealthHudName @"healthHud"

#pragma mark - Private GameScene Properties

@interface GameScene ()
@property BOOL contentCreated;
@property InvaderMovementDirection invaderMovementDirection;
@property NSTimeInterval timeOfLastMove;
@property NSTimeInterval timePerMove;
@end


@implementation GameScene

#pragma mark Object Lifecycle Management

#pragma mark - Scene Setup and Content Creation

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createContent];
        self.contentCreated = YES;
    }
}

- (void)createContent
{
//    SKSpriteNode* invader = [SKSpriteNode spriteNodeWithImageNamed:@"InvaderA_00.png"];
//    invader.position = CGPointMake(self.size.width/2, self.size.height/2);
//    [self addChild:invader];
    
    self.invaderMovementDirection = InvaderMovementDirectionRight;
    self.timePerMove = 1.0;
    self.timeOfLastMove = 0.0;
    
    [self setupInvader];
    [self setupShip];
    [self setupHud];
}

-(SKNode*)makeInvaderOfType:(InvaderType)invaderType {
    SKColor* invaderColor;
    switch (invaderType) {
        case InvaderTypeA:
            invaderColor = [SKColor redColor];
            break;
        case InvaderTypeB:
            invaderColor = [SKColor greenColor];
            break;
        case InvaderTypeC:
        default:
            invaderColor = [SKColor blueColor];
            break;
    }
    
    SKSpriteNode *invader = [SKSpriteNode spriteNodeWithColor:invaderColor size:kInvaderSize];
    invader.name = kInvaderName;
    
    return invader;
}

- (void)setupInvader {
    CGPoint baseOrigin = CGPointMake(kInvaderSize.width / 2, 180);
    for (NSUInteger row = 0; row < kInvaderRowCount; ++row) {
        InvaderType invaderType;
        if (row % 3 == 0)       invaderType = InvaderTypeA;
        else if (row % 3 == 1)  invaderType = InvaderTypeB;
        else                    invaderType = InvaderTypeC;
        
        CGPoint invaderPosition = CGPointMake(baseOrigin.x, row * (kInvaderGridSpacing.height + kInvaderSize.height) + baseOrigin.y);
        
        for (NSUInteger col = 0; col < kInvaderColCount; ++col) {
            SKNode *invader = [self makeInvaderOfType:invaderType];
            invader.position = invaderPosition;
            [self addChild:invader];
            
            invaderPosition.x += kInvaderSize.width + kInvaderGridSpacing.width;
        }
    }
}

- (void)setupShip {
    SKNode *ship = [self makeShip];
    
    ship.position = CGPointMake(self.size.width / 2.0f, kShipSize.height / 2.0f);
    [self addChild:ship];
}

- (SKNode*)makeShip {
    SKNode *ship = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:kShipSize];
    ship.name = kShipName;
    return ship;
}

- (void)setupHud {
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    scoreLabel.name = kScoreHudName;
    scoreLabel.fontSize = 15;
    scoreLabel.fontColor = [SKColor greenColor];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %04u", 0];
    scoreLabel.position = CGPointMake(20 + scoreLabel.frame.size.width / 2, self.size.height - (20 + scoreLabel.frame.size.height / 2));
    [self addChild:scoreLabel];
    
    SKLabelNode *healthLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    healthLabel.name = kHealthHudName;
    healthLabel.fontSize = 15;
    healthLabel.fontColor = [SKColor redColor];
    healthLabel.text = [NSString stringWithFormat:@"Health: %.1f%%", 100.0f];
    healthLabel.position = CGPointMake(self.size.width - healthLabel.frame.size.width / 2 - 20, self.size.height - (20 + healthLabel.frame.size.height / 2));
    [self addChild:healthLabel];
}

#pragma mark - Scene Update

- (void)update:(NSTimeInterval)currentTime {
    [self moveInvadersForUpdate:currentTime];
}

#pragma mark - Scene Update Helpers

- (void)moveInvadersForUpdate:(NSTimeInterval)currentTime {
    if (currentTime - self.timeOfLastMove < self.timePerMove) return;
    
    [self enumerateChildNodesWithName:kInvaderName usingBlock:^(SKNode *node, BOOL *stop) {
        switch (self.invaderMovementDirection) {
            case InvaderMovementDirectionRight:
                node.position = CGPointMake(node.position.x + 10, node.position.y);
                break;
            case InvaderMovementDirectionLeft:
                node.position = CGPointMake(node.position.x - 10, node.position.y);
                break;
            case InvaderMovementDirectionDownThenLeft:
            case InvaderMovementDirectionDownThenRight:
                node.position = CGPointMake(node.position.x, node.position.y - 10);
                break;
            case InvaderMovementDirectionNone:
            default:
                break;
        }
    }];
    
    self.timeOfLastMove = currentTime;
}

#pragma mark - Invader Movement Helpers

#pragma mark - Bullet Helpers

#pragma mark - User Tap Helpers

#pragma mark - HUD Helpers

#pragma mark - Physics Contact Helpers

#pragma mark - Game End Helpers

@end
