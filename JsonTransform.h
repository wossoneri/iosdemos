//
//  JsonTransform.h
//  Quiz
//
//  Created by mythware on 11/23/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonTransform : NSObject

+ (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString;
+ (NSDictionary *)dictionaryFromJsonData:(NSData *)jsonData;


+ (NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary;

@end
