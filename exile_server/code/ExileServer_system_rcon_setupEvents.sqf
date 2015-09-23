/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_restartTime","_useRestartMessages"];
_restartTime = getArray (configFile >> "CfgSettings" >> "RCON" >> "restartTimer");
ExileServerRestartOnHour = getNumber (configFile >> "CfgSettings" >> "RCON" >> "restartOnHour");
ExileServerRestartTime = ((_restartTime select 0) * 60) + (_restartTime select 1);
if (ExileServerRestartOnHour > 0) then
{
	_endTime = (ExileServerStartTime select 4) + ExileServerRestartTime;
	_endMinute = _endTime % 60;
	_restartTime = +ExileServerStartTime;
	_restartTime set [4, 0];
	_restartOffset = [0,0,0,0,0];
	_adjustment = 0;

	if (_endMinute > 30) then
	{
		// Round up
		_adjustment = 60 - _endMinute;
		ExileServerRestartTime = ExileServerRestartTime - _endMinute + 60;
		_restartOffset = ExileServerRestartTime call ExileServer_util_time_toArma;
		_restartTime set [3, ((_restartTime select 3) + (_restartOffset select 3) + 1)];
	}
	else
	{
		// Round down
		_adjustment = _endMinute;
		ExileServerRestartTime = ExileServerRestartTime - _endMinute;
		_restartOffset = ExileServerRestartTime call ExileServer_util_time_toArma;
		_restartTime set [3, ((_restartTime select 3) + (_restartOffset select 3) + 1)];

	};

	diag_log format ["ExileServer - Server Start Time: %1", ExileServerStartTime];
	diag_log format ["ExileServer - Adjusted Restart Timer by %1 minutes. Server will restart in %2 at %3", _adjustment, _restartOffset, _restartTime];
};
ExileServerKickTime = getNumber (configFile >> "CfgSettings" >> "RCON" >> "kickTime");
ExileServerLockTime = getNumber (configFile >> "CfgSettings" >> "RCON" >> "restartAutoLock");
ExileServerUseAutokick = getNumber (configFile >> "CfgSettings" >> "RCON" >> "useAutoKick");
_useRestartMessages = getNumber (configFile >> "CfgSettings" >> "RCON" >> "useRestartMessages");
if(_useRestartMessages isEqualTo 1)then
{
	ExileServerRestartMessages = getArray(configFile >> "CfgSettings" >> "RCON" >> "restartWarrningTime");
}
else
{
	ExileServerRestartMessages = false;
};
[
	30,
	ExileServer_system_rcon_thread_check,
	[
		ExileServerRestartTime,
		ExileServerRestartMessages,
		ExileServerUseAutokick,
		ExileServerKickTime,
		ExileServerLockTime
	],
	true
] 
call ExileServer_system_thread_addTask;
true