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

-(void) reset {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float32 angle = Body->GetAngle();
    
    Body->SetLinearDamping(0);
    Body->SetAngularDamping(0);
    Body->SetAngularVelocity(0);
    Body->SetLinearVelocity(b2Vec2(0,0));
    
    b2Vec2 center = b2Vec2(winSize.width/2/PTM_RATIO, winSize.height/2/PTM_RATIO);
    Body->SetTransform(center, angle);    
}

-(void) respawnLeft {
    [self reset];

    b2Vec2 force = b2Vec2(-10,10);
    Body->ApplyLinearImpulse(force, Body->GetPosition());
}

-(void) respawnRight{
    [self reset];
    
    b2Vec2 force = b2Vec2(10,0);
    Body->ApplyLinearImpulse(force, Body->GetPosition());
}

-(void)dealloc{
    [super dealloc];
}

@end
