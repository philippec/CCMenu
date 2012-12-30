
#import <EDCommon/EDCommon.h>
#import "NSCalendarDate+CCMAdditions.h"


@implementation NSCalendarDate(CCMAdditions)

- (NSString *)relativeDescriptionOfPastDate:(NSCalendarDate *)other
{
	NSInteger days, hours, mins;
	[self years:NULL months:NULL days:&days hours:&hours minutes:&mins seconds:NULL sinceDate:other];
	
	if(days > 1)
		return [NSString stringWithFormat:@"%ld days ago", (long)days];
	if(days == 1)
		return @"1 day ago";
	if(hours > 1)
		return [NSString stringWithFormat:@"%ld hours ago", (long)hours];
	if(hours == 1)
		return @"an hour ago";
	if(mins > 1)
		return [NSString stringWithFormat:@"%ld minutes ago", (long)mins];
	if(mins == 1)
		return @"a minute ago";
	return @"less than a minute ago";
}

- (NSString *)descriptionOfIntervalWithDate:(NSCalendarDate *)other
{  
    return [self descriptionOfIntervalSinceDate:other withSign:NO];
}

- (NSString *)descriptionOfIntervalSinceDate:(NSCalendarDate *)other withSign:(BOOL)withSign
{
    return [[self class] descriptionOfInterval:[self timeIntervalSinceDate:other] withSign:withSign];
}

+ (NSString *)descriptionOfInterval:(NSTimeInterval)timeInterval withSign:(BOOL)withSign
{
    NSInteger interval = timeInterval;
    NSString *sign = withSign ? ((interval < 0) ? @"-" : @"+") : @"";
    interval = labs(interval);

    if(interval > 3600)
        return [NSString stringWithFormat:@"%@%ld:%02ld:%02ld", sign, (long)interval / 3600, ((long)interval / 60) % 60, (long)interval % 60];
    if(interval > 60)
        return [NSString stringWithFormat:@"%@%ld:%02ld", sign, (long)interval / 60, (long)interval % 60];
    return [NSString stringWithFormat:@"%@%lds", sign, (long)interval];
}


@end

@implementation NSDate(CCMAdditions)

- (NSString *)timeAsString
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    return [[dateFormatter stringFromDate:self] stringByRemovingSurroundingWhitespace];
}

@end
