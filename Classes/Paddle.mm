#define PTM_RATIO 32

#import "cocos2d.h"
#import "Box2D.h"
#import "Paddle.h"

@implementation Paddle
@synthesize Sprite, Body, Fixture;

-(id) initWithWorld: (b2World*) world: (b2Body*) groundBody: (CGPoint) startPosition: (CGRect) touchArea {
    if ((self=[super init])) {
        World = world;
        Ground = groundBody;
        _touchArea = touchArea;
        
        // Create sprite.
        Sprite = [CCSprite spriteWithFile:@"whitedot.png"
                                              rect:CGRectMake(50, 50, 50, 100)];
        Sprite.position = startPosition;
        
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.linearDamping = 0.0f;
        bodyDef.angularDamping = 1000.0f;
        bodyDef.position.Set(Sprite.position.x/PTM_RATIO, 
                                  Sprite.position.y/PTM_RATIO);
        bodyDef.userData = Sprite;
        Body = world->CreateBody(&bodyDef);
        
        b2PolygonShape brickShape;
        brickShape.SetAsBox(Sprite.contentSize.width/PTM_RATIO/2,
                            Sprite.contentSize.height/PTM_RATIO/2);
        
        b2FixtureDef shapeDef;
        shapeDef.shape = &brickShape;        
        shapeDef.density = 1.0f;
        shapeDef.friction = 0.0f;
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
    
    BOOL hit = CGRectContainsPoint(_touchArea, location);
    
    CCLOG(@"Touch inside touch area: %", hit);
    
    if (hit) {
        b2MouseJointDef md;
        md.bodyA = Ground;
        md.bodyB = Body;
        md.target = locationWorld;
        md.collideConnected = true;
        md.maxForce = 250 * Body->GetMass();
        
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
    b2Vec2 locationWorld = b2Vec2(bodyPos.x, location.y/PTM_RATIO);
    
    CCLOG(@"MOVED location is %.2f x %.2f", locationWorld.x, locationWorld.y);
    
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
