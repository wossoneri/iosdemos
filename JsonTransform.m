//
//  JsonTransform.m
//  Quiz
//
//  Created by mythware on 11/23/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "JsonTransform.h"

@implementation JsonTransform

+ (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&error];
    
    if (error)
    {
        NSLog(@"Error al leer json: %@", [error description]);
    }
    
    return jsonDictionary;
}

+ (NSDictionary *)dictionaryFromJsonData:(NSData *)jsonData {
    
    NSError *error;
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:kNilOptions
                                                                     error:&error];
    
    if (error)
    {
        NSLog(@"Error al leer json: %@", [error description]);
    }
    
    return jsonDictionary;
}







+ (NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error)
    {
        NSLog(@"Error: %@", error);
    }
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    return jsonString;
}



@end
