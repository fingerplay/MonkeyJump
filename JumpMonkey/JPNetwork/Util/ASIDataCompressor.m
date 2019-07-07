//
//  ASIDataCompressor.m
//  Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by Ben Copsey on 17/08/2010.
//  Copyright 2010 All-Seeing Interactive. All rights reserved.
//

#import "ASIDataCompressor.h"
//#import "ASIHTTPRequest.h"

#define DATA_CHUNK_SIZE 262144 // Deal with gzipped data in 256KB chunks
#define COMPRESSION_AMOUNT Z_DEFAULT_COMPRESSION


NSString* const NetworkRequestErrorDomain = @"ASIHTTPRequestErrorDomain";

typedef enum _ASINetworkErrorType {
    ASIConnectionFailureErrorType = 1,
    ASIRequestTimedOutErrorType = 2,
    ASIAuthenticationErrorType = 3,
    ASIRequestCancelledErrorType = 4,
    ASIUnableToCreateRequestErrorType = 5,
    ASIInternalErrorWhileBuildingRequestType  = 6,
    ASIInternalErrorWhileApplyingCredentialsType  = 7,
    ASIFileManagementError = 8,
    ASITooMuchRedirectionErrorType = 9,
    ASIUnhandledExceptionError = 10,
    ASICompressionError = 11
    
} ASINetworkErrorType;


@interface ASIDataCompressor ()
+ (NSError *)deflateErrorWithCode:(int)code;
@end

@implementation ASIDataCompressor

+ (id)compressor
{
	ASIDataCompressor *compressor = [[self alloc] init];
	[compressor setupStream];
	return compressor;
}

- (void)dealloc
{
	if (streamReady) {
		[self closeStream];
	}
}

- (NSError *)setupStream
{
	if (streamReady) {
		return nil;
	}
	// Setup the inflate stream
	zStream.zalloc = Z_NULL;
	zStream.zfree = Z_NULL;
	zStream.opaque = Z_NULL;
	zStream.avail_in = 0;
	zStream.next_in = 0;
	int status = deflateInit2(&zStream, COMPRESSION_AMOUNT, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
	if (status != Z_OK) {
		return [[self class] deflateErrorWithCode:status];
	}
	streamReady = YES;
	return nil;
}

- (NSError *)closeStream
{
	if (!streamReady) {
		return nil;
	}
	// Close the deflate stream
	streamReady = NO;
	int status = deflateEnd(&zStream);
	if (status != Z_OK) {
		return [[self class] deflateErrorWithCode:status];
	}
	return nil;
}

- (NSData *)compressBytes:(Bytef *)bytes length:(NSUInteger)length error:(NSError **)err shouldFinish:(BOOL)shouldFinish
{
	if (length == 0) return nil;
	
	NSUInteger halfLength = length/2;
	
	// We'll take a guess that the compressed data will fit in half the size of the original (ie the max to compress at once is half DATA_CHUNK_SIZE), if not, we'll increase it below
	NSMutableData *outputData = [NSMutableData dataWithLength:length/2]; 
	
	int status;
	
	zStream.next_in = bytes;
	zStream.avail_in = (unsigned int)length;
	zStream.avail_out = 0;

	NSUInteger bytesProcessedAlready = zStream.total_out;
	while (zStream.avail_out == 0) {
		
		if (zStream.total_out-bytesProcessedAlready >= [outputData length]) {
			[outputData increaseLengthBy:halfLength];
		}
		
		zStream.next_out = (Bytef*)[outputData mutableBytes] + zStream.total_out-bytesProcessedAlready;
		zStream.avail_out = (unsigned int)([outputData length] - (zStream.total_out-bytesProcessedAlready));
		status = deflate(&zStream, shouldFinish ? Z_FINISH : Z_NO_FLUSH);
		
		if (status == Z_STREAM_END) {
			break;
		} else if (status != Z_OK) {
			if (err) {
				*err = [[self class] deflateErrorWithCode:status];
			}
			return nil;
		}
	}

	// Set real length
	[outputData setLength: zStream.total_out-bytesProcessedAlready];
	return outputData;
}


+ (NSData *)compressData:(NSData*)uncompressedData error:(NSError **)err
{
	NSError *theError = nil;
	NSData *outputData = [[ASIDataCompressor compressor] compressBytes:(Bytef *)[uncompressedData bytes] length:[uncompressedData length] error:&theError shouldFinish:YES];
	if (theError) {
		if (err) {
			*err = theError;
		}
		return nil;
	}
	return outputData;
}

+ (NSError *)deflateErrorWithCode:(int)code
{
    return [NSError errorWithDomain:NetworkRequestErrorDomain code:ASICompressionError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Compression of data failed with code %d",code],NSLocalizedDescriptionKey,nil]];
}


@synthesize streamReady;
@end
