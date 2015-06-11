//
//  CommonCrytoFunctions.m
//  AVPlayer Progressive Download
//
//  Created by Mohammad Bharmal on 6/10/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

#import "CommonCrytoFunctions.h"

@implementation CommonCrytoFunctions
-(id)initWithKey:(NSString*)_key andIV:(NSString*)_iv{
    self = [super init];
    if (self) {
        //@"111C8197C8BDEC29005F9E9F5EAF54D9"
        NSData *keyData = [self dataFromHexString:_key];
        [keyData getBytes:&key length:16];
        
        //@"3BD2CD5D9A309F8267BB89EE66AF9840"
        NSData *ivData = [self dataFromHexString:_iv];
        [ivData getBytes:&iv length:16];
        
        CCCryptorCreate(kCCDecrypt, kCCAlgorithmAES128, ccNoPadding, key, kCCKeySizeAES128, iv, &cryptorRef);

    }
    return self;
}

-(NSData*)decrypt:(NSData*)data{
    size_t dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t dataOutMoved;
    CCCryptorUpdate(cryptorRef, [data bytes], dataLength, buffer, bufferSize, &dataOutMoved);
    return [NSData dataWithBytesNoCopy:buffer length:dataOutMoved];
}

-(NSData*)final{
    size_t bufferSize = 1024;
    void *buffer = malloc(bufferSize);
    size_t dataOutMoved;
    CCCryptorFinal(cryptorRef, buffer, bufferSize, &dataOutMoved);
    return [NSData dataWithBytesNoCopy:buffer length:dataOutMoved];
}

- (NSData *)dataFromHexString:(NSString*)string {
    const char *chars = [string UTF8String];
    int i = 0, len = 32;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

-(void)finalize{
    CCCryptorRelease(cryptorRef);
}
@end
