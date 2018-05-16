//
//  Utilities.m
//  Sample
//
//  Created by Hannah Troisi on 3/9/16.
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
//  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "Utilities.h"

#define IsDigit(v) (v >= '0' && v <= '9')

@implementation UIImage (Additions)

+ (nullable NSURLSessionTask *)downloadImageForURL:(NSURL *)url completion:(void (^)(UIImage *))block
{
    static NSCache *simpleImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simpleImageCache = [[NSCache alloc] init];
    });
    
    if (!block) {
        return nil;
    }
    
    // check if image is cached
    UIImage *image = [simpleImageCache objectForKey:url];
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(image);
        });
    } else {
        // else download image
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
        
        
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [simpleImageCache setObject:image forKey:url];
                        block(image);
                    });
                }
            }
        }];
        [task resume];
        return task;
    }
    return nil;
}

@end

static time_t parseRfc3339ToTimeT(const char *string)
{
    int dy, dm, dd;
    int th, tm, ts;
    int oh, om, osign;
    char current;
    
    if (!string)
        return (time_t)0;
    
    // date
    if (sscanf(string, "%04d-%02d-%02d", &dy, &dm, &dd) == 3) {
        string += 10;
        
        if (*string++ != 'T')
            return (time_t)0;
        
        // time
        if (sscanf(string, "%02d:%02d:%02d", &th, &tm, &ts) == 3) {
            string += 8;
            
            current = *string;
            
            // optional: second fraction
            if (current == '.') {
                ++string;
                while(IsDigit(*string))
                    ++string;
                
                current = *string;
            }
            
            if (current == 'Z') {
                oh = om = 0;
                osign = 1;
            } else if (current == '-') {
                ++string;
                if (sscanf(string, "%02d:%02d", &oh, &om) != 2)
                    return (time_t)0;
                osign = -1;
            } else if (current == '+') {
                ++string;
                if (sscanf(string, "%02d:%02d", &oh, &om) != 2)
                    return (time_t)0;
                osign = 1;
            } else {
                return (time_t)0;
            }
            
            struct tm timeinfo;
            timeinfo.tm_wday = timeinfo.tm_yday = 0;
            timeinfo.tm_zone = NULL;
            timeinfo.tm_isdst = -1;
            
            timeinfo.tm_year = dy - 1900;
            timeinfo.tm_mon = dm - 1;
            timeinfo.tm_mday = dd;
            
            timeinfo.tm_hour = th;
            timeinfo.tm_min = tm;
            timeinfo.tm_sec = ts;
            
            // convert to utc
            return timegm(&timeinfo) - (((oh * 60 * 60) + (om * 60)) * osign);
        }
    }
    
    return (time_t)0;
}

static NSDate *parseRfc3339ToNSDate(NSString *rfc3339DateTimeString)
{
    time_t t = parseRfc3339ToTimeT([rfc3339DateTimeString cStringUsingEncoding:NSUTF8StringEncoding]);
    return [NSDate dateWithTimeIntervalSince1970:t];
}


@implementation UIColor (Additions)

+ (UIColor *)darkBlueColor
{
    return [UIColor colorWithRed:70.0/255.0 green:102.0/255.0 blue:118.0/255.0 alpha:1.0];
}

+ (UIColor *)lightBlueColor
{
    return [UIColor colorWithRed:70.0/255.0 green:165.0/255.0 blue:196.0/255.0 alpha:1.0];
}

@end

@implementation NSString (Additions)

/*
 * Returns a user-visible date time string that corresponds to the
 * specified RFC 3339 date time string. Note that this does not handle
 * all possible RFC 3339 date time strings, just one of the most common
 * styles.
 */
+ (NSDate *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString
{
    return parseRfc3339ToNSDate(rfc3339DateTimeString);
}

+ (NSString *)elapsedTimeStringSinceDate:(NSString *)uploadDateString
{
    // early return if no post date string
    if (!uploadDateString)
    {
        return @"NO POST DATE";
    }
    
    NSDate *postDate = [self userVisibleDateTimeStringForRFC3339DateTimeString:uploadDateString];
    
    if (!postDate) {
        return @"DATE CONVERSION ERROR";
    }
    
    NSDate *currentDate         = [NSDate date];
    
    NSCalendar *calendar        = [NSCalendar currentCalendar];
    
    NSUInteger seconds = [[calendar components:NSCalendarUnitSecond fromDate:postDate toDate:currentDate options:0] second];
    NSUInteger minutes = [[calendar components:NSCalendarUnitMinute fromDate:postDate toDate:currentDate options:0] minute];
    NSUInteger hours   = [[calendar components:NSCalendarUnitHour   fromDate:postDate toDate:currentDate options:0] hour];
    NSUInteger days    = [[calendar components:NSCalendarUnitDay    fromDate:postDate toDate:currentDate options:0] day];
    
    NSString *elapsedTime;
    
    if (days > 7) {
        elapsedTime = [NSString stringWithFormat:@"%luw", (long)ceil(days/7.0)];
    } else if (days > 0) {
        elapsedTime = [NSString stringWithFormat:@"%lud", (long)days];
    } else if (hours > 0) {
        elapsedTime = [NSString stringWithFormat:@"%luh", (long)hours];
    } else if (minutes > 0) {
        elapsedTime = [NSString stringWithFormat:@"%lum", (long)minutes];
    } else if (seconds > 0) {
        elapsedTime = [NSString stringWithFormat:@"%lus", (long)seconds];
    } else if (seconds == 0) {
        elapsedTime = @"1s";
    } else {
        elapsedTime = @"ERROR";
    }
    
    return elapsedTime;
}

@end

@implementation NSAttributedString (Additions)

+ (NSAttributedString *)attributedStringWithString:(NSString *)string fontSize:(CGFloat)size
                                             color:(nullable UIColor *)color firstWordColor:(nullable UIColor *)firstWordColor
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    if (string) {
        NSDictionary *attributes = @{NSForegroundColorAttributeName: color ? : [UIColor blackColor],
                                     NSFontAttributeName: [UIFont systemFontOfSize:size]};
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttributes:attributes range:NSMakeRange(0, string.length)];
        
        if (firstWordColor) {
            NSRange firstSpaceRange = [string rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
            NSRange firstWordRange  = NSMakeRange(0, firstSpaceRange.location);
            [attributedString addAttribute:NSForegroundColorAttributeName value:firstWordColor range:firstWordRange];
        }
    }
    
    return attributedString;
}

@end
