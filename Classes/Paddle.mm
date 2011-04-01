#define PTM_RATIO 32

#import "cocos2d.h"
#import "Box2D.h"
#import "Paddle.h"

@implementation Paddle
@synthesize Sprite, Body, Fixture;

-(id) initWithWorld: (b2World*) world: (b2Body*) groundBody {
    if ((self=[super init])) {
        World = world;
        Ground = groundBody;
        
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
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];
    }
    return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL touched = NO;
    
    if (_mouseJoint != NULL) {
        return touched;
    }
    
    CGPoint location = [touch locationInView:[touch view]];
    CCLOG(@"BEGAN location is %.2f x %.2f", location.x,location.y);
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    BOOL hit = YES;//[_paddle testPoint:locationWorld];
    
    if (hit) {
        b2MouseJointDef md;
        md.bodyA = Ground;
        md.bodyB = Body;
        md.target = locationWorld;
        md.collideConnected = true;
        md.maxForce = 1000.0f * Body->GetMass();
        
        _mouseJoint = (b2MouseJoint *)World->CreateJoint(&md);
        Body->SetAwake(true);
        
        touched = YES;
    }
    
    return touched;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (_mouseJoint == NULL) return;
    
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 bodyPos = Body->GetPosition();
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO,	location.y/PTM_RATIO);
    
    _mouseJoint->SetTarget(locationWorld);
    
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        World->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_mouseJoint) {
        World->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }  
}

-(void)dealloc{
    [super dealloc];
}

@end
