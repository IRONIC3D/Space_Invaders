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

#define kInvaderSize CGSizeMake(24, 16)
#define kInvaderGridSpacing CGSizeMake(12, 12)
#define kInvaderRowCount 6
#define kInvaderColCount 6

#define kInvaderName @"invader"

#pragma mark - Private GameScene Properties

@interface GameScene ()
@property BOOL contentCreated;
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
    
    [self setupInvader];
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

#pragma mark - Scene Update

- (void)update:(NSTimeInterval)currentTime
{
}

#pragma mark - Scene Update Helpers

#pragma mark - Invader Movement Helpers

#pragma mark - Bullet Helpers

#pragma mark - User Tap Helpers

#pragma mark - HUD Helpers

#pragma mark - Physics Contact Helpers

#pragma mark - Game End Helpers

@end
