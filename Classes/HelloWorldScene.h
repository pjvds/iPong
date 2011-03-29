#import "cocos2d.h"
#import "Box2D.h"

@interface HelloWorld : CCLayer {  
    b2World *_world;
    b2Body *_groundBody;
    b2Fixture *_bottomFixture;
    b2Fixture *_ballFixture;
}

+ (id) scene;

- (b2Vec2) getStartingForce;
- (void) setupWorld;	
@end