#define PTM_RATIO 32

#import "cocos2d.h"
#import "Box2D.h"
#import "Paddle.h"


@implementation Paddle
@synthesize Sprite, Body, Fixture;

+(id) initWithWorld:(b2World*)world {
    return [self initWithWorld: world];
}

-(id) initWithWorld: (b2World*) world {
    if ((self=[super init])) {
        Sprite = [CCSprite spriteWithFile:@"whitedot.png"
                                              rect:CGRectMake(50, 50, 50, 50)];
        Sprite.position = ccp(10,10);
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(Sprite.position.x/PTM_RATIO, 
                                  Sprite.position.y/PTM_RATIO);
        bodyDef.userData = Sprite;
        Body = world->CreateBody(&bodyDef);
        
        b2PolygonShape brickShape;
        brickShape.SetAsBox(Sprite.contentSize.width/PTM_RATIO/2,
                            Sprite.contentSize.height/PTM_RATIO/2);
        b2FixtureDef shapeDef;
        shapeDef.shape = &brickShape;
        shapeDef.density = 10.0;
        shapeDef.isSensor = true;
        Fixture = Body->CreateFixture(&shapeDef);
        
        
    }
    return self;
}

-(BOOL) testPoint: (b2Vec2) point{
    return Fixture->TestPoint(point);
}

-(void)dealloc{
    [super dealloc];
}

@end
