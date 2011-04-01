#import "cocos2d.h"
#import "Box2D.h"

@interface iPongLayer : CCLayer {  
    b2MouseJoint *_mouseJoint;
    b2World *_world;
    b2Body *_groundBody;
    b2Fixture *_bottomFixture;
    b2Fixture *_ballFixture;
    b2Body *_p1BrickBody;
    b2Fixture *_p1BrickFixture;
}

+ (id) scene;
+ (b2Vec2) getStartingForce;

- (void) setupWorld;
- (void)setupGroundBody;
- (void) setupBall;
- (void)setupPlayer1Brick;
@end