
#import <Growl/Growl.h>
#import "CCMNotifier.h"
#import "CCMServerMonitor.h"


struct {
	NSString *key;
	NSString *name;
	NSString *description;
} userNotifications[5];

				
@implementation CCMNotifier

+ (void)initialize
{
	userNotifications[0].key = CCMSuccessfulBuild;
	userNotifications[0].name = NSLocalizedString(@"Build successful", "Notification for successful build");
	userNotifications[0].description = NSLocalizedString(@"Yet another successful build!", "For user notification");

	userNotifications[1].key = CCMStillFailingBuild;
	userNotifications[1].name = NSLocalizedString(@"Build still failing", "Notification for successful build");
	userNotifications[1].description = NSLocalizedString(@"The build is still broken.", "For user notification");
	
	userNotifications[2].key = CCMBrokenBuild;
	userNotifications[2].name = NSLocalizedString(@"Broken build", "Notification for successful build");
	userNotifications[2].description = NSLocalizedString(@"Recent checkins have broken the build.", "For user notification");

	userNotifications[3].key = CCMFixedBuild;
	userNotifications[3].name = NSLocalizedString(@"Fixed build", "Notification for successful build");
	userNotifications[3].description = NSLocalizedString(@"Recent checkins have fixed the build.", "For user notification");
}	

- (NSDictionary *)registrationDictionaryForGrowl
{
	NSMutableArray *names = [NSMutableArray array];
	for(int i = 0; userNotifications[i].key != nil; i++)
		[names addObject:userNotifications[i].name];
	return [NSDictionary dictionaryWithObject:names forKey:GROWL_NOTIFICATIONS_ALL];
}

- (void)start
{
	[GrowlApplicationBridge setGrowlDelegate:(id)self];
	[[NSNotificationCenter defaultCenter] 
		addObserver:self selector:@selector(buildComplete:) name:CCMBuildCompleteNotification object:nil];
}

- (void)buildComplete:(NSNotification *)notification
{
	NSString *projectName = [[notification object] name];
	NSString *buildResult = [[notification userInfo] objectForKey:@"buildResult"];

	for(int i = 0; userNotifications[i].key != nil; i++)
	{
		if([buildResult isEqualToString:userNotifications[i].key])
		{
			NSString *title = [NSString stringWithFormat:@"%@: %@", projectName, userNotifications[i].name];
			NSString *description = userNotifications[i].description;
			NSString *notificationName = userNotifications[i].name;
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1080
			if ([NSUserNotification class])
			{
				// Notification Center is available, use that
				NSUserNotification *notification = [[[NSUserNotification alloc] init] autorelease];
				notification.title = title;
				notification.informativeText = description;

				[[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
			}
			else
#endif
			{
				// Fallback to Growl
				[GrowlApplicationBridge
					notifyWithTitle:title
						description:description
					notificationName:notificationName
							iconData:nil
							priority:0
							isSticky:NO
						clickContext:nil];

			}
			break;
		}
	}
}

@end
