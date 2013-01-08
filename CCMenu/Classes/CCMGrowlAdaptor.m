
#import <Growl/Growl.h>
#import "CCMGrowlAdaptor.h"
#import "CCMServerMonitor.h"


struct {
	NSString *key;
	NSString *name;
	NSString *description;
} growlNotifications[5];		

				
@implementation CCMGrowlAdaptor

+ (void)initialize
{
	growlNotifications[0].key = CCMSuccessfulBuild;
	growlNotifications[0].name = NSLocalizedString(@"Build successful", "Growl notification for successful build");
	growlNotifications[0].description = NSLocalizedString(@"Yet another successful build!", "For Growl notification");

	growlNotifications[1].key = CCMStillFailingBuild;
	growlNotifications[1].name = NSLocalizedString(@"Build still failing", "Growl notification for successful build");
	growlNotifications[1].description = NSLocalizedString(@"The build is still broken.", "For Growl notification");
	
	growlNotifications[2].key = CCMBrokenBuild;
	growlNotifications[2].name = NSLocalizedString(@"Broken build", "Growl notification for successful build");
	growlNotifications[2].description = NSLocalizedString(@"Recent checkins have broken the build.", "For Growl notification");

	growlNotifications[3].key = CCMFixedBuild;
	growlNotifications[3].name = NSLocalizedString(@"Fixed build", "Growl notification for successful build");
	growlNotifications[3].description = NSLocalizedString(@"Recent checkins have fixed the build.", "For Growl notification");
}	

- (NSDictionary *)registrationDictionaryForGrowl
{
	NSMutableArray *names = [NSMutableArray array];
	for(int i = 0; growlNotifications[i].key != nil; i++)
		[names addObject:growlNotifications[i].name];
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

	for(int i = 0; growlNotifications[i].key != nil; i++)
	{
		if([buildResult isEqualToString:growlNotifications[i].key])
		{
			NSString *title = [NSString stringWithFormat:@"%@: %@", projectName, growlNotifications[i].name];
			NSString *description = growlNotifications[i].description;
			NSString *notificationName = growlNotifications[i].name;
			if ([NSUserNotification class])
			{
				// Notification Center is available, use that
				NSUserNotification *notification = [[[NSUserNotification alloc] init] autorelease];
				notification.title = title;
				notification.informativeText = description;

				[[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
			}
			else
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
