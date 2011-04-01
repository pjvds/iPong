#import "cocos2d.h"
#import "Box2D.h"
#import <CCTouchDispatcher.h>
#import <Foundation/Foundation.h>


@interface Paddle : NSObject<CCTargetedTouchDelegate> {
    b2World *World;
    b2Body *Ground;
    CCSprite *Sprite;
    b2Body *Body;
    b2Fixture *Fixture;
    b2MouseJoint *_mouseJoint;
    CGRect _touchArea;
}

@property(readonly,assign) CCSprite* Sprite;
@property(readonly,assign) b2Body* Body;
@property(readonly,assign) b2Fixture* Fixture;

-(id) initWithWorld: (b2World*) world: (b2Body*) groundBody: (CGPoint) startPosition: (CGRect) touchArea;
-(void)dealloc;
@end
