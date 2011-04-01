#define PTM_RATIO 32

#import "cocos2d.h"
#import "Box2D.h"
#import "Paddle.h"


@implementation Paddle
@synthesize Sprite, Body, Fixture;

-(id) initWithWorld: (b2World*) world: (b2Body*) groundBody {
    if ((self=[super init])) {
        // Create sprite.
        Sprite = [CCSprite spriteWithFile:@"whitedot.png"
                                              rect:CGRectMake(50, 50, 50, 100)];
        Sprite.position = ccp(50,50);
        
        
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
        shapeDef.density = 5.0f;
        shapeDef.friction = 0.4f;
        shapeDef.restitution = 0.1f;
        Fixture = Body->CreateFixture(&shapeDef);
        
        // Restrict paddle along the x axis
        b2PrismaticJointDef jointDef;
        b2Vec2 worldAxis(0.0f, 1.0f);
        jointDef.collideConnected = true;
        jointDef.Initialize(Body, groundBody,
                            Body->GetWorldCenter(), worldAxis);
        world->CreateJoint(&jointDef);
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
