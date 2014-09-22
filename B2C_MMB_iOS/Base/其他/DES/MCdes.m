//
//  MCdes.m
//  des
//
//  Created by duomai on 13-12-24.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#import "MCdes.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation MCdes

static Byte iv[] = {1,2,3,4,5,6,7,8};
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key

{
    
    NSString *ciphertext = nil;
    
    const char *textBytes = [plainText UTF8String];
    
    NSUInteger dataLength = [plainText length];
    
    
    unsigned char buffer[1024];
    
    memset(buffer, 0, sizeof(char));
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          
                                          kCCOptionECBMode|kCCOptionPKCS7Padding,  //kCCOptionECBMode  kCCOptionPKCS7Padding
                                          
                                          [key UTF8String], kCCKeySizeDES,
                                          
                                          iv,
                                          
                                          textBytes, dataLength,
                                          
                                          buffer, 1024,
                                          
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        //NSLog(@"ssf:%s",buffer);
        ciphertext = [self base64Encoding:data];
        // NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        //        Byte* bb = (Byte*)[data bytes];
        //        ciphertext = [self parseByteArray2HexString:bb];
        
    }
    
    ciphertext = [ciphertext stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ciphertext = [ciphertext stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    return ciphertext;
}

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


+(NSString *)base64Encoding:(NSData*) text
{
    if (text.length == 0)
        return @"";
    
    char *characters = malloc(text.length*3/2);
    
    if (characters == NULL)
        return @"";
    
    int end = text.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[text bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[text bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == text.length - 2)
    {
        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[text bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == text.length - 1)
    {
        int d = ((int)(((char *)[text bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;
}
@end
