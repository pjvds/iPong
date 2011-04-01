#define PTM_RATIO 32

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "iPongLayer.h"
#import "Paddle.h"


@implementation iPongLayer

+ (id)scene {
    
    CCScene *scene = [CCScene node];
    iPongLayer *layer = [iPongLayer node];
    [scene addChild:layer];
    return scene;
    
}

+ (b2Vec2) getStartingForce{
    return b2Vec2(10,10);
}


- (id)init {
    
    if ((self=[super init])) {
        
        [self setupWorld];
        [self setupGroundBody];
        [self setupBall];
        [self setupPlayer1Brick];
        
        [self schedule:@selector(tick:)];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

- (void)setupWorld {
    // Create a world
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    bool doSleep = true;
    _world = new b2World(gravity, doSleep);
}

- (void)setupGroundBody {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // Create edges around the entire screen
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    _groundBody = _world->CreateBody(&groundBodyDef);
    b2PolygonShape groundBox;
    b2FixtureDef groundBoxDef;
    groundBoxDef.shape = &groundBox;
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
    _bottomFixture = _groundBody->CreateFixture(&groundBoxDef);
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&groundBoxDef);
    groundBox.SetAsEdge(b2Vec2(0, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&groundBoxDef);
    groundBox.SetAsEdge(b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 0));
    _groundBody->CreateFixture(&groundBoxDef);
}

- (void)setupPlayer1Brick{
    _paddle = [[Paddle alloc] initWithWorld: _world: _groundBody];
    [self addChild:_paddle.Sprite];
}

- (void) setupBall{
    _ball = [[Ball alloc] spawn:self :_world : _groundBody: b2Vec2(10,10)];
}



- (void)tick:(ccTime) dt {
    _world->Step(dt, 10, 10);
    
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        CCSprite *sprite = (CCSprite *)b->GetUserData();
        
        if(sprite != NULL) {
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
            sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
}

- (void)dealloc {
    delete _world;
    _groundBody = NULL;
    [super dealloc];
}

@end