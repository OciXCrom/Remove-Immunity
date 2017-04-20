#include <amxmodx>
#include <amxmisc>

#define PLUGIN_VERSION "1.0"

new bool:g_bImmune[33]

public plugin_init()
{
	register_plugin("Remove Immunity", PLUGIN_VERSION, "OciXCrom")
	register_concmd("amx_remove_imm", "ToggleImmunity", ADMIN_RCON, "<nick|#userid>")
	register_concmd("amx_restore_imm", "ToggleImmunity", ADMIN_RCON, "<nick|#userid>")
	register_cvar("@CRXRemoveImmunity", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED)
}

public client_putinserver(id)
	g_bImmune[id] = false

public ToggleImmunity(id, iLevel, iCid)
{
	if(!cmd_access(id, iLevel, iCid, 2))
		return PLUGIN_HANDLED
	
	new szPlayer[32]
	read_argv(1, szPlayer, charsmax(szPlayer))
	
	new iPlayer = cmd_target(id, szPlayer, CMDTARGET_ALLOW_SELF)
	
	if(!iPlayer)
		return PLUGIN_HANDLED
		
	new szName[32]
	get_user_name(iPlayer, szName, charsmax(szName))
	
	new szCommand[8]
	read_argv(0, szCommand, charsmax(szCommand))
	
	switch(szCommand[6])
	{
		case 'm':
		{
			if(is_user_immune(iPlayer))
			{
				remove_user_flags(iPlayer, ADMIN_IMMUNITY)
				console_print(id, "* Removed immunity from %s.", szName)
				g_bImmune[id] = true
			}
			else
				console_print(id, "* %s doesn't have immunity!", szName)
		}
		case 's':
		{
			if(is_user_immune(iPlayer))
				console_print(id, "* %s already has immunity!", szName)
			else if(!g_bImmune[id])
				console_print(id, "* %s didn't have immunity, so you can't restore it!", szName)
			else
			{
				set_user_flags(iPlayer, ADMIN_IMMUNITY)
				console_print(id, "* Restored %s's immunity.", szName)
			}
		}
	}
	
	return PLUGIN_HANDLED
}

bool:is_user_immune(id)
	return get_user_flags(id) & ADMIN_IMMUNITY ? true : false