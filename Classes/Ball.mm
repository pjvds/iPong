#define PTM_RATIO 32
#import "Ball.h"
@implementation Ball
@synthesize Sprite, Body, Fixture;

-(id) spawn: (CCLayer*) layer: (b2World*) world: (b2Body*) groundBody: (b2Vec2) force {
    if ((self=[super init])) {
        // Create sprite.
        Sprite = [CCSprite spriteWithFile:@"whitedot.png"
                                     rect:CGRectMake(50, 50, 50, 50)];
        Sprite.position = ccp(500,500);
        [layer addChild:Sprite];
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.fixedRotation = true;
        bodyDef.position.Set(Sprite.position.x/PTM_RATIO, 
                             Sprite.position.y/PTM_RATIO);
        bodyDef.userData = Sprite;
        Body = world->CreateBody(&bodyDef);
        
        b2PolygonShape shape;
        shape.SetAsBox(Sprite.contentSize.width/PTM_RATIO/2,
                       Sprite.contentSize.height/PTM_RATIO/2);
        
        b2FixtureDef shapeDef;
        shapeDef.shape = &shape;        
        shapeDef.density = 1.0f;
        shapeDef.friction = 0.0f;
        shapeDef.restitution = 1.0f;
        Fixture = Body->CreateFixture(&shapeDef);
        
        Body->ApplyLinearImpulse(force, Body->GetPosition());
    }
    return self;
}


-(void)dealloc{
    [super dealloc];
}

@end
