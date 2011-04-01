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
        winSize = [CCDirector sharedDirector].winSize;
        
        [self setupWorld];
        [self setupGroundBody];
        [self addBackground];
        [self spawnScoreboards];
        [self setupBall];
        [self spawnPaddles];
        
        [self schedule:@selector(tick:)];
        [[[CCDirector sharedDirector] openGLView] setMultipleTouchEnabled:YES];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void)addBackground{
    CCSprite* lineSprite = [CCSprite spriteWithFile:@"line.png" rect:CGRectMake(0,0, 5, winSize.height*2)];
    lineSprite.position = ccp(winSize.width/2, 0);
    
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    [lineSprite.texture setTexParameters: &params];
    
    [self addChild: lineSprite];
}

- (void)setupWorld {
    // Create a world
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    bool doSleep = true;
    _world = new b2World(gravity, doSleep);
}

- (void)setupGroundBody {
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

- (void)spawnScoreboards{
    _leftScore = [CCLabelTTF labelWithString:@"0" fontName:@"SF Square Head" fontSize:64];
    _leftScore.position = ccp(winSize.width/2 - 100,winSize.height - 45);
    [self addChild: _leftScore];
    
    _rightScore = [CCLabelTTF labelWithString:@"0" fontName:@"SF Square Head" fontSize:64];
    _rightScore.position = ccp(winSize.width/2 + 100,winSize.height - 45);
    [self addChild: _rightScore];
}

- (void)spawnPaddles{
    
    _leftPaddle = [[Paddle alloc] initWithWorld: _world: _groundBody: ccp(50,50): CGRectMake(0,0, winSize.width/2,winSize.height)];
    [self addChild:_leftPaddle.Sprite];
    
    _rightPaddle = [[Paddle alloc] initWithWorld: _world: _groundBody: ccp(winSize.width-50, 50): CGRectMake(winSize.width/2,0,winSize.width/2,winSize.height)];
    [self addChild:_rightPaddle.Sprite];
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