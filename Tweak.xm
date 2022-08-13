#import <Tweak.h>

%hook EAOutputStream
-(long long)write:(const char*)arg1 maxLength:(unsigned long long)arg2  { 
	long long r = %orig;
	NSMutableString *hex = [NSMutableString stringWithCapacity:arg2];
	for (int i=0; i < r; i++) {
		[hex appendFormat:@"0x%02x ", arg1[i]];
	}
	NSString *protocol = [[self valueForKey:@"_session"] valueForKey:@"protocolString"]; 
	
	NSLog(@"[EALogger] %@ | %lld ⬆ %@", protocol, r, hex);
	return r;
}
%end

%hook EAInputStream
-(long long)read:(char*)arg1 maxLength:(unsigned long long)arg2 {
	long long r = %orig;
	NSMutableString *hex = [NSMutableString stringWithCapacity:arg2];
	for (int i=0; i < r; i++) {
		[hex appendFormat:@"0x%02x ", arg1[i]];
	}
	NSString *protocol = [[self valueForKey:@"_session"] valueForKey:@"protocolString"]; 
	NSLog(@"[EALogger] %@ | %lld ⬇ %@", protocol, r, hex);
	return r;
}
%end

%ctor {
	// This method causes bugs, because it creates file in a lot of places, so we won't log to files, but instead to console.
	// NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    // NSString *documentsDirectory = [paths objectAtIndex:0];
    // NSString *fileName = @"EALogger.log";
    // NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    // freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

