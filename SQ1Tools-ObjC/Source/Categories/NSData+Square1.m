//
//  NSData+Square1.m
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "NSData+Square1.h"

@implementation NSData (Square1)

- (NSString*)sq1_hexString
{
  NSUInteger length = self.length;
  unichar* hexChars = (unichar*)malloc(sizeof(unichar) * (length*2));
  unsigned char* bytes = (unsigned char*)self.bytes;
  
  for (NSUInteger i = 0; i < length; i++) {
    unichar c = bytes[i] / 16;
    if (c < 10) c += '0';
    else c += 'a' - 10;
    hexChars[i*2] = c;
    c = bytes[i] % 16;
    if (c < 10) c += '0';
    else c += 'a' - 10;
    hexChars[i*2+1] = c;
  }
  
  NSString* retVal = [[NSString alloc] initWithCharactersNoCopy:hexChars
                                                         length:length*2
                                                   freeWhenDone:YES];
  return retVal;
}

+ (NSData *)sq1_dataWithBase64EncodedString:(NSString *)string
{
  const char lookup[] =
  {
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
    99, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
    99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
  };
  
  NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  long long inputLength = [inputData length];
  const unsigned char *inputBytes = [inputData bytes];
  
  long long maxOutputLength = (inputLength / 4 + 1) * 3;
  
  NSMutableData *outputData = [NSMutableData dataWithLength:(int)maxOutputLength];
  unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
  
  int accumulator = 0;
  long long outputLength = 0;
  unsigned char accumulated[] = {0, 0, 0, 0};
  for (long long i = 0; i < inputLength; i++)
  {
    unsigned char decoded = lookup[inputBytes[i] & 0x7F];
    if (decoded != 99)
    {
      accumulated[accumulator] = decoded;
      if (accumulator == 3)
      {
        outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
        outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
        outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
      }
      accumulator = (accumulator + 1) % 4;
    }
  }
  
  //handle left-over data
  if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
  if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
  if (accumulator > 2) outputLength++;
  
  //truncate data to match actual output length
  outputData.length = (int)outputLength;
  return outputLength? outputData: nil;
}

- (NSString *)sq1_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
  //ensure wrapWidth is a multiple of 4
  wrapWidth = (wrapWidth / 4) * 4;
  
  const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  
  long long inputLength = [self length];
  const unsigned char *inputBytes = [self bytes];
  
  long long maxOutputLength = (inputLength / 3 + 1) * 4;
  maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) * 2: 0;
  unsigned char *outputBytes = (unsigned char *)malloc((long)maxOutputLength);
  
  long long i;
  long long outputLength = 0;
  for (i = 0; i < inputLength - 2; i += 3)
  {
    outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
    outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
    outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
    outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
    
    //add line break
    if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
    {
      outputBytes[outputLength++] = '\r';
      outputBytes[outputLength++] = '\n';
    }
  }
  
  //handle left-over data
  if (i == inputLength - 2)
  {
    // = terminator
    outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
    outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
    outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
    outputBytes[outputLength++] = '=';
  }
  else if (i == inputLength - 1)
  {
    // == terminator
    outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
    outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
    outputBytes[outputLength++] = '=';
    outputBytes[outputLength++] = '=';
  }
  
  if (outputLength >= 4)
  {
    //truncate data to match actual output length
    outputBytes = realloc(outputBytes, (long)outputLength);
    return [[NSString alloc] initWithBytesNoCopy:outputBytes
                                          length:(int)outputLength
                                        encoding:NSASCIIStringEncoding
                                    freeWhenDone:YES];
  }
  else if (outputBytes)
  {
    free(outputBytes);
  }
  return nil;
}

- (NSString *)sq1_base64EncodedString
{
  return [self sq1_base64EncodedStringWithWrapWidth:0];
}

@end