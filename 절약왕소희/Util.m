//
//  Util.m
//  절약왕소희
//
//  Created by SH on 2015. 9. 28..
//  Copyright © 2015년 SH. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString *)commaFormat:(NSInteger)val{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter stringFromNumber:[NSNumber numberWithInteger:val]];
}

+ (NSInteger)removeComma:(NSString *)formattedStr{
    NSString *removedString = [[formattedStr componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                               componentsJoinedByString:@""];
    
//    NSLog(@"%@",removedString);
    return removedString.integerValue;
}

+ (UIAlertController *)shortAlert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"이런이런" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    return alert;
}

+ (NSMutableDictionary *)getLocalData{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFilePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"data.archive"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *localDic = nil;
    
    if ([fileManager fileExistsAtPath:dataFilePath]) {
        localDic = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:dataFilePath]];
    }

    return localDic;
}

+ (void)setLocalData:(NSObject *)data forKey:(NSString *)key{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFilePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"data.archive"]];
    NSMutableDictionary *localDic = [self getLocalData];
    
    //최초사용에 대해서 실행되는 코드
    if (localDic == nil) {
        localDic = [[NSMutableDictionary alloc] init];
    }

    [localDic setObject:data forKey:key];
    [NSKeyedArchiver archiveRootObject:localDic toFile:dataFilePath];
}


@end

