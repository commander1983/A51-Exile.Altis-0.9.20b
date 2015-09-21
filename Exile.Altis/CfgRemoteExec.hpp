class CfgRemoteExec
{
	class Functions
	{
		mode = 1;
		jip = 0;
		class fnc_AdminReq { allowedTargets=2; };
		class ExileServer_system_network_dispatchIncomingMessage { allowedTargets=2; };
		
		class FN_infiSTAR_C { allowedTargets=1; };
		class ExileClient_system_network_dispatchIncomingMessage { allowedTargets=1; };
	};
	class Commands
	{
		mode=0;
		jip=0;
	};
};