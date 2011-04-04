#define PTM_RATIO 32
#import "Ball.h"
#import "CCScheduler.h"

@implementation Ball
@synthesize Sprite, Body, Fixture;

-(id) spawn: (CCLayer*) layer: (b2World*) world: (b2Body*) groundBody: (b2Vec2) force {
    if ((self=[super init])) {
        _winSize = [CCDirector sharedDirector].winSize;
        
        // Create sprite.
        Sprite = [CCSprite spriteWithFile:@"whitedot.png"
                                     rect:CGRectMake(50, 50, 50, 50)];
        Sprite.position = ccp(500,500);
        [layer addChild:Sprite];

        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(Sprite.position.x/PTM_RATIO, 
                             Sprite.position.y/PTM_RATIO);
        bodyDef.userData = Sprite;
        Body = world->CreateBody(&bodyDef);
        
        b2CircleShape shape;
        shape.m_radius = 26.0/PTM_RATIO;
        
        b2FixtureDef shapeDef;
        shapeDef.shape = &shape;        
        shapeDef.density = 1.0f;
        shapeDef.friction = 0.1f;
        shapeDef.restitution = 1.0f;
        Fixture = Body->CreateFixture(&shapeDef);
        
        Body->ApplyLinearImpulse(force, Body->GetPosition());
        [[CCScheduler sharedScheduler] scheduleSelector:@selector(tick:) forTarget:self interval:0 paused:FALSE];
    }
    return self;
}

-(void) reset {
    float32 angle = Body->GetAngle();
    
    Body->SetLinearDamping(0);
    Body->SetAngularDamping(0);
    Body->SetAngularVelocity(0);
    Body->SetLinearVelocity(b2Vec2(0,0));
    
    b2Vec2 center = b2Vec2(_winSize.width/2/PTM_RATIO, _winSize.height/2/PTM_RATIO);
    Body->SetTransform(center, angle);
}

- (void)tick:(ccTime) dt {
    b2Vec2 ballPos = Body->GetPosition();
    ballPos *= PTM_RATIO;
    
    if(ballPos.x < 0){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"RightScores"
         object:nil ];
        [self respawnLeft];
    } else if(ballPos.x > _winSize.width){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"LeftScores"
         object:nil ];
        [self respawnRight];
    }
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
    Sprite = NULL;
    Body = NULL;
    Fixture = NULL;
    [super dealloc];
}

@end
