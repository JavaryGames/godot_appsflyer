#include "register_types.h"
#if defined(__APPLE__)
#include "ios/GodotAppsFlyer.h"
#endif

void register_godot_appsflyer_types() {
#if defined(__APPLE__)
	ClassDB::register_class<GodotAppsFlyer>();
#endif
}

void unregister_godot_appsflyer_types() {
}