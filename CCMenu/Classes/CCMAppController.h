
#import <Cocoa/Cocoa.h>
#import "CCMPreferencesController.h"
#import "CCMServerMonitor.h"
#import "CCMNotifier.h"
#import "CCMImageFactory.h"
#import "CCMBuildTimer.h"
#import "CCMSoundPlayer.h"


@interface CCMAppController : NSObject
{
	IBOutlet CCMPreferencesController	*preferencesController;
	IBOutlet CCMImageFactory			*imageFactory;
	IBOutlet CCMServerMonitor			*serverMonitor;
	IBOutlet CCMNotifier				*userNotifier;
	CCMBuildTimer						*buildTimer;
	CCMSoundPlayer						*soundPlayer;
}

@end
