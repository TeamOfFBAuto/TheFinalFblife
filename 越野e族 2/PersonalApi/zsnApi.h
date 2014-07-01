//
//  zsnApi.h
//  FbLife
//
//  Created by soulnear on 13-4-2.
//  Copyright (c) 2013年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface zsnApi : NSObject

+(NSString *)timechange:(NSString *)placetime;
+(NSString *)timechange1:(NSString *)placetime;

+(NSString *)timeFromDate:(NSDate *)date;
+ (NSString*)imgreplace:(NSString*)imgSrc;

+ (NSString*)Eximgreplace:(NSString*)imgSrc;


+(NSString *)exchangeString:(NSString *)string;

+ (float)theHeight:(NSString *)content withHeight:(CGFloat)theheight WidthFont:(UIFont *)font;

+(NSString *)exchangeFrom:(NSString *)from;

+(NSString *) fileSizeAtPath:(NSString*) filePath;

+(UIImage *)fitSmallImage:(UIImage *)image withSize:(CGSize)theSize;

+(NSString *)returnUrl:(NSString *)theUrl;

+(NSArray *)stringExchange:(NSString *)string;


+(float)calculateheight:(NSArray *)array;


+(NSMutableArray *)conversionFBContent:(NSDictionary *)userinfo isSave:(BOOL)isSave WithType:(int)theType;

//微博资源分享类型内容转换

+(NSString *)ShareResourceContent:(NSString *)theResource;

+(float)boolLabelLength:(NSString *)strString withFont:(int)theFont wihtWidth:(float)theWidth;

+(NSString*)FBImageChange:(NSString*)imgSrc;

+ (NSString*)FBEximgreplace:(NSString*)imgSrc;

+(BOOL) validateEmail: (NSString *) candidate;

+(CGPoint)LinesWidth:(NSString *)string Label:(UILabel *)label font:(UIFont *)thefont linebreak:(NSLineBreakMode)linebreak;

@end






