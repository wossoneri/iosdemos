//
//  NSString+Extension.h
//  
//
//  Created by wossoneri on 16/4/18.
//
//

#import <UIKit/UIKit.h>

@interface NSString (TrimmingAdditions)

- (NSString *)stringByTrimmingLeadingWhitespace;
- (NSString *)stringByTrimmingTrailingWhitespace;
- (NSString *)stringByTrimmingLeadingWhitespaceAndNewline;
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewline;

@end
