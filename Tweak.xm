#import <Tweak.h>

%hook CBPeripheral
- (void)openL2CAPChannel:(CBL2CAPPSM)PSM {
	NSLog(@"[BLELogger] openL2CAPChannel psm: %d", PSM);
	%orig;
}
- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic {
	NSLog(@"[BLELogger] readValueForCharacteristic characteristic: %@", characteristic);
	%orig;
}
- (void)readValueForDescriptor:(CBDescriptor *)descriptor {
	NSLog(@"[BLELogger] readValueForDescriptor descriptor: %@", descriptor);
	%orig;
}
- (void)writeValue:(NSData *)value forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type {
	NSLog(@"[BLELogger] writeValue: %@ forCharacteristic: %@ type: %ld", value, characteristic, type);
	%orig;
}
- (void)writeValue:(NSData *)value forDescriptor:(CBDescriptor *)descriptor {
	NSLog(@"[BLELogger] writeValue: %@ forDescriptor: %@", value, descriptor);
	%orig;
}
- (void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service{
	NSLog(@"[BLELogger] discoverCharacteristics: %@ forService: %@", characteristicUUIDs, service);
	%orig;
}
- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic {
	NSLog(@"[BLELogger] discoverDescriptorsForCharacteristic: %@", characteristic);
	%orig;
}
- (void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs {
	NSLog(@"[BLELogger] discoverServices: %@", serviceUUIDs);
	%orig;
}
%end

%hook CBCentralManager 
- (void)scanForPeripheralsWithServices:(NSArray *)services options:(NSDictionary *)options {
	NSLog(@"[BLELogger] scanForPeripheralsWithServices: %@ options: %@", services, options);
	%orig;
}
- (NSArray *)retrieveConnectedPeripheralsWithServices:(NSArray *)services {
	NSLog(@"[BLELogger] retrieveConnectedPeripheralsWithServices: %@", services);
	return %orig;
}
- (void)connnectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options {
	NSLog(@"[BLELogger] connectPeripheral: %@ options: %@", peripheral, options);
	%orig;
}
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral {
	NSLog(@"[BLELogger] cancelPeripheralConnection: %@", peripheral);
	%orig;
}
%end

%hook NSOutputStream
-(long long)write:(const char*)arg1 maxLength:(unsigned long long)arg2  { 
	long long r = %orig;
	NSMutableString *hex = [NSMutableString stringWithCapacity:arg2];
	for (int i=0; i < r; i++) {
		[hex appendFormat:@"0x%02x ", arg1[i]];
	}
	NSLog(@"[BLELogger] %lld ⬆ %@", r, hex);
	return r;
}
%end

%hook NSInputStream
-(long long)read:(char*)arg1 maxLength:(unsigned long long)arg2 {
	long long r = %orig;
	NSMutableString *hex = [NSMutableString stringWithCapacity:arg2];
	for (int i=0; i < r; i++) {
		[hex appendFormat:@"0x%02x ", arg1[i]];
	}
	NSLog(@"[BLELogger] %lld ⬇ %@", r, hex);
	return r;
}
%end

%ctor {
	// this method will cause bugs, because it creates new files in many places. So we won't log to files, but instead to console.
	
	// NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	// NSString *documentsDirectory = [paths objectAtIndex:0];
	// NSString *fileName = @"tweak.log";
	// NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	// NSLog(@"%@", logFilePath);
	// freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

