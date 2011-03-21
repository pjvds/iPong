#import "HelloWorldScene.h"

@implementation HelloWorld

+ (id)scene {
    
    CCScene *scene = [CCScene node];
    HelloWorld *layer = [HelloWorld node];
    [scene addChild:layer];
    return scene;
    
}

- (id)init {
    
    if ((self=[super init])) {
    }
    return self;
}

@end