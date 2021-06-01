#import <Tweak.h>

%hook EAOutputStream
-(long long)write:(const char*)arg1 maxLength:(unsigned long long)arg2  { 
	long long r = %orig;
	NSMutableString *hex = [NSMutableString stringWithCapacity:arg2];
	for (int i=0; i < arg2; i++) {
		[hex appendFormat:@"0x%02x ", arg1[i]];
	}
	NSString *protocol = [[self valueForKey:@"_session"] valueForKey:@"protocolString"]; 
	NSLog(@"%@ | %lld ⬆ %@", protocol, r, hex);
	return r;
}
%end

%hook EAInputStream
-(long long)read:(char*)arg1 maxLength:(unsigned long long)arg2 {
	long long r = %orig;
	NSMutableString *hex = [NSMutableString stringWithCapacity:arg2];
	for (int i=0; i < arg2; i++) {
		[hex appendFormat:@"0x%02x ", arg1[i]];
	}
	NSString *protocol = [[self valueForKey:@"_session"] valueForKey:@"protocolString"]; 
	NSLog(@"%@ | %lld ⬇ %@", protocol, r, hex);
	return r;
}
%end