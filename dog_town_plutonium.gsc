//PLUTO v1 - TOWN Survival with Dogs

#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/gametypes_zm/_spawnlogic;
#include maps/mp/animscripts/traverse/shared;
#include maps/mp/animscripts/utility;
#include maps/mp/zombies/_load;
#include maps/mp/_createfx;
#include maps/mp/_music;
#include maps/mp/_busing;
#include maps/mp/_script_gen;
#include maps/mp/gametypes_zm/_globallogic_audio;
#include maps/mp/gametypes_zm/_tweakables;
#include maps/mp/_challenges;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/_demo;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/gametypes_zm/_globallogic_utils;
#include maps/mp/gametypes_zm/_spectating;
#include maps/mp/gametypes_zm/_globallogic_spawn;
#include maps/mp/gametypes_zm/_globallogic_ui;
#include maps/mp/gametypes_zm/_hostmigration;
#include maps/mp/gametypes_zm/_globallogic_score;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_ai_faller;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zombies/_zm_pers_upgrades;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/animscripts/zm_run;
#include maps/mp/animscripts/zm_death;
#include maps/mp/zombies/_zm_blockers;
#include maps/mp/animscripts/zm_shared;
#include maps/mp/animscripts/zm_utility;
#include maps/mp/zombies/_zm_ai_basic;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_net;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/gametypes_zm/_zm_gametype;
#include maps/mp/_visionset_mgr;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zombies/_zm_power;
#include maps/mp/zombies/_zm_server_throttle;
#include maps/mp/gametypes/_hud_util;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_melee_weapon;
#include maps/mp/zombies/_zm_audio_announcer;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_ai_dogs;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_buildables;
#include codescripts/character;
#include maps/mp/zombies/_zm_weap_riotshield;
init()
{
    if( getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype")  == "zstandard" )
	{
        include_zombie_powerup("fire_sale");
        add_zombie_powerup("fire_sale", "p6_zm_buildable_sq_meteor", &"ZOMBIE_POWERUP_FIRE_SALE", ::func_should_always_drop, 0, 0, 0);
	    powerup_set_can_pick_up_in_last_stand("fire_sale", 1);

        include_zombie_powerup("death_machine");
   	    add_zombie_powerup("death_machine", "zombie_teddybear", &"ZOMBIE_POWERUP_DEATH_MACHINE", ::func_should_always_drop, 1, 0, 0);
	    powerup_set_can_pick_up_in_last_stand("death_machine", 0);

	    include_zombie_powerup("unlimited_ammo");
   	    add_zombie_powerup("unlimited_ammo", "T6_WPN_AR_GALIL_WORLD", &"ZOMBIE_POWERUP_UNLIMITED_AMMO", ::func_should_always_drop, 0, 0, 0);
	    powerup_set_can_pick_up_in_last_stand("unlimited_ammo", 1);

	    include_zombie_powerup("zombie_cash");
   	    add_zombie_powerup("zombie_cash", "zombie_z_money_icon", &"ZOMBIE_POWERUP_ZOMBIE_CASH", ::func_should_always_drop, 1, 0, 0);
	    powerup_set_can_pick_up_in_last_stand("zombie_cash", 1);

	    include_zombie_powerup("random_perk");
   	    add_zombie_powerup("random_perk", "t6_wpn_zmb_perk_bottle_sleight_world", &"ZOMBIE_POWERUP_RANDOM_PERK", ::func_should_always_drop, 0, 0, 0); 
	    powerup_set_can_pick_up_in_last_stand("random_perk", 1);

	    precacheshader("menu_mp_lobby_icon_film");
	    precacheshader( "menu_mp_lobby_icon_customgamemode" );
	    precacheshader( "waypoint_revive" );
	    precacheshader( "killiconheadshot" );
	    precacheshader( "menu_lobby_icon_twitter" );
	    precacheshader( "hud_grenadeicon" ); 
	    precacheshader( "menu_mp_weapons_1911" );
	    precacheshader( "menu_mp_lobby_icon_screenshot" );
	    precacheshader( "damage_feedback" ); 
        precacheshader( "zombies_rank_1" );
	    precacheshader( "zombies_rank_3" );
	    precacheshader( "zombies_rank_2" );
	    precacheshader( "zombies_rank_4" );
	    precacheshader( "menu_mp_weapons_xm8" );
        precacheshader( "faction_cdc" ); 
	    precacheshader( "menu_mp_weapons_hamr" ); 
	    precacheshader( "zombies_rank_5" );
	    precacheshader( "hud_icon_sticky_grenade" );
        precacheshader( "specialty_instakill_zombies" );
	    precacheshader( "menu_mp_weapons_1911" );
		precacheshader( "hud_icon_colt" );
        precachemodel("p6_zm_buildable_sq_meteor");
	    precachemodel( "collision_player_wall_512x512x10" );
	    precachemodel( "collision_physics_512x512x10" );
	    precachemodel( "t5_foliage_tree_burnt03" );
	    precachemodel( "p_rus_door_roller" );
	    precachemodel( "ch_tombstone1" );
	    precachemodel( "collision_geo_256x256x10_standard" );
	    precachemodel( "zombie_vending_tombstone_on" );
	    precachemodel( "zombie_vending_revive_on" );
	    precachemodel( "zombie_vending_sleight_on" );
	    precachemodel( "zombie_vending_doubletap2_on" );
	    precachemodel( "zombie_pickup_perk_bottle" );
	    precachemodel( "zm_collision_perks1" );
	    precachemodel( "zombie_teddybear" );
	    precachemodel( "p6_zm_screecher_hole" );
	    precachemodel( "p_cub_door01_wood_fullsize" );
	    precachemodel( "veh_t6_civ_microbus_dead" );
	    precachemodel( "p_rus_door_white_window_plain_left" );
	    level._effect["fx_zombie_cola_revive_on"] = loadfx( "misc/fx_zombie_cola_revive_on" );
	    level._effect["fx_zombie_cola_dtap_on"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	    level._effect["fx_zombie_cola_on"] = loadfx( "misc/fx_zombie_cola_on" );

	    level._effect["fx_zmb_wall_buy_m16"] = loadfx( "maps/zombie/fx_zmb_wall_buy_m16" ); 
	    level._effect["fx_zmb_wall_buy_taseknuck"] = loadfx( "maps/zombie/fx_zmb_wall_buy_taseknuck" );
	    level._effect["fx_zmb_wall_buy_bowie"] = loadfx( "maps/zombie/fx_zmb_wall_buy_bowie" );
	    level._effect["fx_default_explosion"] = loadfx( "explosions/fx_default_explosion" );
		level._effect[ "wall_m16" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_m16" );
		level._effect[ "wall_claymore" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_claymore" );
	    level.effect_WebFX = loadfx("misc/fx_zombie_powerup_solo_grab");

        set_zombie_var( "zombie_powerup_fire_sale_on", 0 );
	    set_zombie_var( "zombie_powerup_fire_sale_time", 30 );
	    level.town = 1;
	    level.diner = 0;

        level thread onPlayerConnect();
	    level thread drawZombiesCounter();
	    level thread turnonpower();
        level thread setDvars();
		level thread perk_machine_removal( "specialty_scavenger" );
		level thread zombie_speed();
        level thread night_mode();
		init_custom_map(); 

        level.dog_rounds = level.round_number + randomintrange( 4, 7 );
	    level.get_player_weapon_limit = ::custom_get_player_weapon_limit;
	    level.zombie_last_stand = ::LastStand;
	    level.custom_vending_precaching = ::default_vending_precaching;
	    level.round_spawn_func = ::custom_spawning;

	    register_player_damage_callback( ::damage_callback );
		register_zombie_death_event_callback( ::Custom_death_callback );


        if(isDefined(level._zombiemode_powerup_grab))
        {
            level.original_zombiemode_powerup_grab = level._zombiemode_powerup_grab;
        }
	    level._zombiemode_powerup_grab = ::custom_powerup_grab;

	    level.player_out_of_playable_area_monitor = 0;
		level.power_up_duration = 30;
	    level.perk_purchase_limit = 50;
        level.dog_health = 100;
        level.zombie_health = 150;
		level.soulbox_active = 1;
		level.soulbox1_active = 1;
		level.soulbox2_active = 1;
		level.soulbox3_active = 1;
		level.soulbox4_active = 1;
		foreach( weapon in level.zombie_weapons) 
		{
			weapon.is_in_box = 1;
		}
    }
    else
	{
        level waittill( "connected", player );
    	player waittill("spawned_player");
        flag_wait( "initial_blackscreen_passed" );
        player iprintln( "^1Error! Please play in Green Run - Town Survival Mode." );
		setdvar( "ui_errorMessage", "^9Please use Green Run - Town Survival Mode");
	    setdvar( "ui_errorTitle", "^1Error" );
	}
}

night_mode()
{
	level waittill( "connected", player );
	player setclientdvar( "r_dof_enable", 0 );
	player setclientdvar( "r_lodBiasRigid", -1000 );
	player setclientdvar( "r_lodBiasSkinned", -1000 );
	player setclientdvar( "r_enablePlayerShadow", 1 );
	player setclientdvar( "r_skyTransition", 1 );
	player setclientdvar( "sm_sunquality", 2 );
	player setclientdvar( "vc_fbm", "0 0 0 0" );
	player setclientdvar( "vc_fsm", "1 1 1 1" );
	player setclientdvar( "r_filmUseTweaks", 1 );
	player setclientdvar( "r_bloomTweaks", 1 );
	player setclientdvar( "r_exposureTweak", 1 );
	player setclientdvar( "vc_rgbh", "0.1 0 0.3 0" );
    player setclientdvar( "vc_yl", "0 0 0.25 0" );
	player setclientdvar( "vc_yh", "0.02 0 0.1 0" );
	player setclientdvar( "vc_rgbl", "0.02 0 0.1 0" );
	player setclientdvar( "r_exposureValue", 3.9 );
	player setclientdvar( "r_lightTweakSunLight", 1 );
	player setclientdvar( "r_sky_intensity_factor0", 0 );
    level.default_r_exposureValue = getDvar( "r_exposureValue" );
	level.default_r_lightTweakSunLight = getDvar( "r_lightTweakSunLight" );
	level.default_r_sky_intensity_factor0 = getDvar( "r_sky_intensity_factor0" );
}

setdvars()
{
    setdvar("r_fog", "0");
	setDvar( "scr_screecher_ignore_player", 1 );
	setdvar( "ui_errorMessage", "^9Thank you for playing this Custom Survival Map");
	setdvar( "ui_errorTitle", "^1Nacht" );
}

onPlayerConnect()
{
	while( 1 )
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	self waittill( "spawned_player" );
	self.perkarray = [];
	self.dying_wish_on_cooldown = 0;
    self.perk_reminder = 0;
    self.perk_count = 0;
    self.num_perks = 0;
	self.boss_is_alive = 0;
	self.is_boss_round = 0;
    self thread SpawnPoint();
	self thread init_wall_fx();
	self thread removeperkshader();
    self thread perkboughtcheck();
	self thread damagehitmarker();
    level thread OnGameEndedHint( self );
	self takeweapon( "m1911_zm" );
	self giveweapon( "kard_zm" );
	self switchtoweapon( "kard_zm" );
	flag_wait( "start_zombie_round_logic" );
	wait 5;
	self iprintln( "Custom Town - Survival" );
	self thread boss_round_monitor();
	for(;;)
	{
		self waittill( "spawned_player" );
        self thread SpawnPoint();
		self takeweapon( "m1911_zm" );
		self giveweapon( "kard_zm" );
		self switchtoweapon( "kard_zm" );
		if(self.score < 2500)
		{
			self.score = 2500;
		}
	}
}

SpawnPoint()
{
	player = level.players;
	if( player[ 4] == self )
	{
		player[ 4] setorigin( ( 1588.01, 62.551, -61.875 ) );
	}
	if( player[ 5] == self )
	{
		player[ 5] setorigin( ( 1615.65, 272.551, -61.875 ) );
	}
	if( player[ 6] == self )
	{
		player[ 6] setorigin( ( 1276.65, -28.551, -61.875 ) );
    }
	if( player[ 7] == self )
	{
		player[ 7] setorigin( ( 1430.65, -133.551, -61.875 ) );
    }
}

zombie_speed()
{
	speed = [];
	speed[0] = "run";
	speed[1] = "sprint";
	while( level.round_number < 5 )
	{
		foreach(zombie in getaiarray(level.zombie_team))
		{
			if( !(IsDefined( zombie.run_set )) )
			{
				zombie maps/mp/zombies/_zm_utility::set_zombie_run_cycle( speed[randomintrange(0, 2)] ); 
				zombie.run_set = 1;
			}
		}
		wait 1;
	}
}

damagehitmarker()
{
	self thread startwaiting();
	self.hitmarker = newdamageindicatorhudelem( self );
	self.hitmarker.horzalign = "center";
	self.hitmarker.vertalign = "middle";
	self.hitmarker.x = -12;
	self.hitmarker.y = -12;
	self.hitmarker.alpha = 0;
	self.hitmarker setshader( "damage_feedback", 24, 48 );

}

startwaiting()
{
	while( 1 )
	{
		foreach( zombie in getaiarray( level.zombie_team ) )
		{
			if( !(IsDefined( zombie.waitingfordamage )) )
			{
				zombie thread hitmark();
			}
		}
		wait 0.25;
	}
}

hitmark()
{
	self endon( "killed" );
	self.waitingfordamage = 1;
	while( 1 )
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		attacker.hitmarker.alpha = 0;
		if( isplayer( attacker ) )
		{
			if( isalive( self ) )
			{
				attacker.hitmarker.color = ( 1, 1, 1 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
			}
			else
			{
				attacker.hitmarker.color = ( 1, 0, 0 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
				self notify( "killed" );
			}
		}
	}
}	

turnonpower()
{
	self maps\mp\zombies\_zm_game_module::turn_power_on_and_open_doors();
}

drawZombiesCounter()
{
    flag_wait( "initial_blackscreen_passed" );
    level.zombiesCounter = createServerFontString("hudsmall" , 1.9);
    level.zombiesCounter setPoint("RIGHT", "TOP", 315, "RIGHT");
    while(true)
    {
        enemies = get_round_enemy_array().size + level.zombie_total;
        if(level.dog_rounds == level.round_number)
        {
            level.zombiesCounter.label = &"Dogs: ^1";
        }
        else
        {
            level.zombiesCounter.label = &"Zombies: ^1";
        }
        level.zombiesCounter setValue( enemies );
        wait 0.05;
    }
}

soul_box(model)
{
	level.souls_needed = 50;
	level.soulbox_souls = 0;
	level.soulbox1_souls = 0;
	level.soulbox2_souls = 0;
	level.soulbox3_souls = 0;
	level.soulbox4_souls = 0;
	level.soulbox = spawnentity( "script_model", getweaponmodel( model ), ( 2010.65, 12.58, 94.625), ( 0, 0, 0 ));
	level.soulbox1 = spawnentity( "script_model", getweaponmodel( model ), ( 1974.65, -442.551, -53.775 ), ( 0, 0, 0 ));
	level.soulbox2 = spawnentity( "script_model", getweaponmodel( model ), ( 799.65, -1211.551, 127 ), ( 0, 0, 0 ));
	level.soulbox3 = spawnentity( "script_model", getweaponmodel( model ), ( 1479.65, -1430.551, -54.075 ), ( 0, 0, 0 ));
	level.soulbox4 = spawnentity( "script_model", getweaponmodel( model ), ( 800.65, -380.551, -54.875 ), ( 0, 0, 0 ));
}

Custom_death_callback( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex ) 
{
	if(level.soulbox_active)
	{

		if( distance( level.soulbox.origin, self.origin ) <= 200 )
		{
			playfx(loadfx("misc/fx_zombie_powerup_solo_grab"), level.soulbox.origin );
			level.soulbox_souls++;
			if(level.souls_needed <= level.soulbox_souls)
			{
				level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( "random_perk", level.soulbox.origin );
				level.soulbox delete();
				level.soulbox_active = 0;
			}
		}
	}
	if(level.soulbox1_active)
	{

		if( distance( level.soulbox1.origin, self.origin ) <= 300 )
		{
			playfx(loadfx("misc/fx_zombie_powerup_solo_grab"), level.soulbox1.origin );
			level.soulbox1_souls++;
			if(level.souls_needed <= level.soulbox1_souls)
			{
				level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( "random_perk", level.soulbox1.origin );
				level.soulbox1 delete();
				level.soulbox1_active = 0;
			}
		}
	}
	if(level.soulbox2_active)
	{
		if( distance( level.soulbox2.origin, self.origin ) <= 300 )
		{
			playfx(loadfx("misc/fx_zombie_powerup_solo_grab"), level.soulbox2.origin );
			level.soulbox2_souls++;
			if(level.souls_needed <= level.soulbox2_souls)
			{
				level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( "random_perk", level.soulbox2.origin );
				level.soulbox2 delete();
				level.soulbox2_active = 0;
			}
		}
	}
	if(level.soulbox3_active)
	{

		if( distance( level.soulbox3.origin, self.origin ) <= 300 )
		{
			playfx(loadfx("misc/fx_zombie_powerup_solo_grab"), level.soulbox3.origin );
			level.soulbox3_souls++;
			if(level.souls_needed <= level.soulbox3_souls)
			{
				level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( "random_perk", level.soulbox3.origin );
				level.soulbox3 delete();
				level.soulbox3_active = 0;
			}
		}
	}
	if(level.soulbox4_active)
	{
		if( distance( level.soulbox4.origin, self.origin ) <= 300 )
		{
			playfx(loadfx("misc/fx_zombie_powerup_solo_grab"), level.soulbox4.origin );
			level.soulbox4_souls++;
			if(level.souls_needed <= level.soulbox4_souls)
			{
				level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( "random_perk", level.soulbox4.origin );
				level.soulbox4 delete();
				level.soulbox4_active = 0;
			}
		}
	}
	return idamage;
}

init_custom_map()
{
	soul_box( "zombie_perk_bottle_tombstone"  );
	wallweapons( "riotshield_zm", ( 1983.69, 137, -30.551 ), ( 0, 105, 0 ), 1000 );
	wallweapons( "m16_zm", ( 2273.641, 167.5, 140.125 ), ( 0, 130, 0 ), 1200, 600 );
	wallweapons( "emp_grenade_zm", ( 969.69, 280.402, 6.901 ), ( 0, 45, 0 ), 750 );
	pile_of_emp( "emp_grenade_zm", ( 969.69, 284.402, 4.525 ), ( 0, 15, 90 ));
	wallweapons( "claymore_zm", ( 629.01, 441.01, 14.302 ), ( 90, -45, 0 ), 1000 );
    shootable( ( 1686, 290.722, -55.001 ), (0, -120, 0) ); 
	shootable( ( 1075, -45.4103, 535.943 ), (0, 0, 0) ); 
	shootable( ( 2495, 60.2994, 360.876 ), (0, 180, 0) ); 
	shootable( ( 680.483, -1370.62, 300.576 ), (0, 45, 0) ); 
	shootable( ( 1990.89, 942.905, -59.678 ), (0, 180, 0) ); 
	shootable( ( 1310.1, -225.9, -40.375 ), (0, 170, 0) );
	perk_system( "script_model", ( 1856, -810.722, -55.875), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_deadshot_sting", "Deadshot", 2000, "tombstone_light", "deadshot" );
	perk_system( "script_model", ( 2460, -780, -55.875 ), "zombie_vending_tombstone_on", ( 0, 225, 0 ), "custom", "mus_perks_doubletap_sting", "Burn Heart", 2500, "jugger_light", "Burn_Heart" );
	perk_system( "script_model", ( 901.86, -1575.574, -47.875 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_deadshot_sting", "Widow's Wine", 4000, "tombstone_light", "WIDOWS_WINE" );
	perk_system( "script_model", ( 613, -250.574, -61.875 ), "zombie_vending_tombstone_on", ( 0, 0, 0 ), "custom", "mus_perks_packa_sting", "Electric Cherry", 2000, "tombstone_light", "ELECTRIC_CHERRY" );
	perk_system( "script_model", ( 1069, -1133, 120.125 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_doubletap_sting", "Ethereal Razor", 4000, "tombstone_light", "Ethereal_Razor" );
	perk_system( "script_model", ( 1823.86, 670.574, -55.875 ), "zombie_vending_tombstone_on", ( 0, 45, 0 ), "custom", "mus_perks_doubletap_sting", "Mule Kick", 4000, "tombstone_light", "MULE" );
	perk_system( "script_model", ( 840, 603.809, -40.875 ), "zombie_vending_tombstone_on", ( 0, 0, 0 ), "custom", "mus_perks_packa_sting", "PhD Flopper", 2000, "tombstone_light", "PHD_FLOPPER" );
	perk_system( "script_model", ( 2358, -87, -55.875  ), "zombie_vending_tombstone_on", ( 0, -90, 0 ), "custom", "mus_perks_doubletap_sting", "Downer's Delight", 2500, "tombstone_light", "Downers_Delight" );
	perk_system( "script_model", (  2015, 858, -56.875  ), "zombie_vending_tombstone_on", ( 0, -90, 0 ), "custom", "mus_perks_doubletap_sting", "Dying Wish", 5000, "tombstone_light", "Dying_Wish" );
	perk_system( "script_model", ( 559, -1364, 120.125  ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 2500, "tombstone_light", "Ammo_Regen" );
}

play_fx( fx )
{
	playfxontag( level._effect[ fx ], self, "tag_origin" );
}

defaulth_vending_precaching()
{
	level._effect[ "sleight_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "tombstone_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "revive_light" ] = loadfx( "misc/fx_zombie_cola_revive_on" );
	level._effect[ "marathon_light" ] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
	level._effect[ "jugger_light" ] = loadfx( "misc/fx_zombie_cola_jugg_on" );
	level._effect[ "doubletap_light" ] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect[ "deadshot_light" ] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect[ "additionalprimaryweapon_light" ] = loadfx( "misc/fx_zombie_cola_arsenal_on" );
	level._effect[ "packapunch_fx" ] = loadfx( "maps/zombie/fx_zombie_packapunch" );
	level._effect[ "wall_m16" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_m16" );
	level._effect[ "wall_claymore" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_claymore" );
	level._effect[ "wall_taseknuck" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_taseknuck" );
}

init_wall_fx()
{
    self thread playchalkfx("wall_m16", ( 2274.641, 168, 140.125 ), ( 0, 180, 0 ));
    self thread playchalkfx("wall_claymore", ( 629.01, 441.01, 10.902 ), ( 0, -90, 0 ));
}

playchalkfx(effect, origin, angles)
{
    fx = SpawnFX(level._effect[ effect ], origin,AnglesToForward(angles),AnglesToUp(angles));
    TriggerFX(fx);
    level waittill("connected", player);
    fx Delete();
}

shootable(origin, angles)
{
	shotable = spawn( "script_model", origin );
	shotable setmodel( "zombie_teddybear" );
	shotable.angles = ( angles );
	shotable.health = 5;
	shotable setcandamage( 1 );
	shotable thread teddys();
}

teddys()
{
	self endon( "shot" );
	teddysNeeded = 6;
	teddysCollected = 0;
	while( 1 )
	{
		self waittill( "damage", idamage, attacker, idflags, vpoint, type, victim, vdir, shitloc, psoffsettime, sweapon );
		if( self.health <= 0 )
		{
			teddysCollected++;
			iprintlnbold("Teddys shot [" + teddysCollected + "/6]");
			self delete();
			if (teddysCollected >= teddysNeeded)
			{
				self thread maps/mp/zombies/_zm_audio_announcer::leaderdialog( "boxmove" );
				wait 2;
				foreach(player in level.players)
				{
					player thread Perkaholic();
				}
			}
			self notify( "shot" );
		}
		wait 0.1;
	}
}

perk_system( script, pos, model, angles, type, sound, name, cost, fx, perk)
{
	col = spawn( script, pos);
	col setmodel( model );
	col.angles = angles;
	x = spawn( script, pos );
	x setmodel( "zm_collision_perks1" );
	x.angles = angles;
    col thread buy_system( perk, sound, name, cost, type );
    col thread play_fx( fx );
}

buy_system( perk, sound, name, cost, type )
{
    self endon( "game_ended" );
    while( 1 )
    {
        foreach( player in level.players )
        {
            if(!player.machine_is_in_use)
			{
                if( distance( self.origin, player.origin ) <= 70 )
                {
				    player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + name + " [Cost: " + cost + "]" );
                    if(player usebuttonpressed() && !player hasperk(perk) && !player hascustomperk(perk) && player.score >= cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                    {
                        player.machine_is_in_use = 1;
                        player playsound( "zmb_cha_ching" );
                        player.score -= cost;
                        player playsound( sound );
			    	    player thread drawshader_and_shadermove( perk, 1, 1 );
						wait 4;
                    	player.machine_is_in_use = 0;
					}
					else
                    {
                        if( player usebuttonpressed() && player.score < cost )
                        {
                            player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
                        }
                    }
                }
            }
        }
        wait 0.1;
    }
}

hascustomperk(perk)
{
	for(i = 0; i < self.perkarray.size; i++)
	{
		if(self.perkarray[i].name == perk)
		{
			return 1;
		}
	}
	return 0;
}

removeperkshader()
{
    for(;;)
    {
        self waittill_any_return( "fake_death", "player_downed", "player_revived", "spawned_player", "disconnect", "death" );
        self.num_perks = 0;
        self.perk_reminder = 0;
        self.perk_count = 0;
		self.dying_wish_on_cooldown = 0;
		self removeallcustomshader();
		self.perkarray = [];
        self notify( "stopcustomperk" );
        self.bleedout_time = 30;
	    self.ignore_lava_damage = 0;
        self setclientfieldtoplayer( "deadshot_perk", 0 );
    }
}

removeallcustomshader()
{
	for(i = 0; i < self.perkarray.size; i++)
	{
		self.perkarray[i] destroy();
	}
}

drawshader( shader, x, y, width, height, color, alpha, sort )
{
	hud = newclienthudelem( self );
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
    hud.hidewheninmenu = 1;
	hud setparent( level.uiparent );
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
	return hud;
}

perkboughtcheck()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        self.perk_reminder = self.num_perks;
        self waittill("perk_acquired");
		n = 1;
        if(!(self.num_perks > self.perk_reminder))
        {
			n = (self.num_perks - self.perk_reminder);
            self.num_perks = (self.perk_reminder + n);
        }
        self.perk_reminder = self.num_perks;
        self.perk_count += n;
        self drawshader_and_shadermove("none", 0, 0);
    }
}

drawshader_and_shadermove(perk, custom, print)
{
    if(custom)
	{
        self allowProne(false);
        self allowSprint(false);
        self disableoffhandweapons();
        self disableweaponcycling();
        weapona = self getcurrentweapon();
        weaponb = "zombie_perk_bottle_tombstone";
        self giveweapon( weaponb );
        self switchtoweapon( weaponb );
        self waittill( "weapon_change_complete" );
        self enableoffhandweapons();
        self enableweaponcycling();
        self takeweapon( weaponb );
        self switchtoweapon( weapona );
        self maps/mp/zombies/_zm_audio::playerexert( "burp" );
        self setblur( 4, 0.1 );
        wait 0.1;
        self setblur( 0, 0.1 );
        self allowProne(true);
        self allowSprint(true);
    }
    x = -408 + (self.perk_count * 30);
    for(i = 0; i < self.perkarray.size; i++)
	{
    	self.perkarray[i].x = self.perkarray[i].x + 30;
	}
        if(perk == "Downers_Delight")
        {
            self.perk1back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );  
            self.perk1front = self drawshader( "waypoint_revive", x, 350, 23, 23, ( 0, 1, 1 ), 100, 0 ); 
            self.perk1front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1front;
			self.perk1back.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1back;
			self.num_perks++;
			self thread DDown();
			if(print)
			{
				self iprintln("^9Downer's Delight");
				wait 0.2;
				self iprintln("This Perk will increase players bleedout time by 10 seconds and current weapons is used in laststand.");
			}
		}
        if(perk == "MULE")
        {   
            self.perk2back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk2front = self drawshader( "menu_mp_weapons_1911", x, 350, 22, 22, ( 0, 1, 0 ), 100, 0 );
            self.perk2front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk2front;
			self.perk2back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk2back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Mule Kick");
				wait 0.2;
				self iprintln("This Perk enables additional primary weapon slot for player. ");
			}
		}
        if(perk == "PHD_FLOPPER")
        {    
            self.perk3back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk3front = self drawshader( "hud_icon_sticky_grenade", x, 350, 23, 23, (1, 0, 1 ), 100, 0 );
            self.perk3front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk3front;
			self.perk3back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk3back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9PhD Flopper");
				wait 0.2;
				self iprintln("This Perk removes explosion and fall damage also player creates explosion when dive to prone.");
			}
		}
        if(perk == "Victorious_Tortoise")
        {    
            self.perk4back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 200, 0 ), 100, 0 );
            self.perk4front = self drawshader( "zombies_rank_2", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk4front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk4front;
			self.perk4back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk4back;
			self.num_perks++;
			self thread start_vt();
			if(print)
			{
				self iprintln("^9Victorious Tortoise");
				wait 0.2;
				self iprintln("This Perk allows shield block damage from all directions when in use.");
        	}
		}
        if(perk == "ELECTRIC_CHERRY")
        {    
            self.perk5back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 200 ), 100, 0 );
            self.perk5front = self drawshader( "zombies_rank_5", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk5front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk5front;
			self.perk5back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk5back;
			self.num_perks++;
			self thread start_ec();
			if(print)
			{
				self iprintln("^9Electric Cherry");
				wait 0.2;
				self iprintln("This Perk creates an electric shockwave around the player whenever they reload.");
        	}
		}	
        if(perk == "WIDOWS_WINE")
        {    
            self.perk6back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk6front = self drawshader( "zombies_rank_3", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk6front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk6front;
			self.perk6back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk6back;
			self.num_perks++;
			self takeweapon( self get_player_lethal_grenade() );
			self set_player_lethal_grenade( "sticky_grenade_zm" );
			self giveweapon("sticky_grenade_zm");
        	self thread ww_nades();
			if(print)
			{
				self iprintln("^9Widow's Wine");
				wait 0.2;
				self iprintln("This Perk damages zombies around the player when player is hit and grenades are upgraded.");
        	}
		}
        if(perk == "Ethereal_Razor")
        {    
            self.perk7back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk7front = self drawshader( "zombies_rank_4", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
			self.perk7front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk7front;
			self.perk7back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk7back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Ethereal Razor");
				wait 0.2;
				self iprintln("This Perk deals extra damage when player using melee attacks and restores a small amount of health.");
        	}
		}
		if(perk == "Ammo_Regen")
        {
            self.perk8back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk8front = self drawshader( "menu_mp_lobby_icon_customgamemode", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk8front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk8front;
			self.perk8back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk8back;
			self.num_perks++;
			self thread ammoregen();
            self thread grenadesregen();
			if(print)
			{
				self iprintln("^9Ammo Regen");
				wait 0.2;
				self iprintln("This Perk will slowly regenerades players ammonation and grenades.");			
			}
		}
        if(perk == "Burn_Heart")
        {
            self.perk9back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk9front = self drawshader( "faction_cdc", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk9front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk9front;
			self.perk9back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk9back;
			self.num_perks++;
            self.ignore_lava_damage = 1;
			if(print)
			{
				self iprintln("^9Burn Heart");
				wait 0.2;
				self iprintln("This Perk removes lava damage.");
			}
		}
        if(perk == "Dying_Wish")
        {
            self.perk10back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk10front = self drawshader( "zombies_rank_5", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk10front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk10front;
			self.perk10back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk10back;
			self.num_perks++;
            self thread dying_wish_checker();
			if(print)
			{
				self iprintln("^9Dying Wish");
				wait 0.2;
				self iprintln("This Perk allow player to go berserker mode for 9 seconds instead of laststand.");
				wait 0.1;
				self iprintln(" (cooldown 5mins and it's increased 30sec every time perk is used. - max 10mins) ");
			}
		}
        if(perk == "deadshot")
        {
            self.perk11back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk11front = self drawshader( "killiconheadshot", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk11front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk11front;
			self.perk11back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk11back;
			self.num_perks++;
			self setclientfieldtoplayer( "deadshot_perk", 1 );
			if(print)
			{
				self iprintln("^9Deadshot");
				wait 0.2;
				self iprintln("This Perk aims automatically enemys head instead of body.");
        	}
		}
}

custom_get_player_weapon_limit( player )
{
    weapon_limit = 2;
    if ( player hascustomperk("MULE") )
    {
        weapon_limit = 3;
    } 
	else 
	{
        weapons = self getWeaponsListPrimaries();
        if(weapons.size > 2)
		{
            self takeWeapon(weapons[2]);
        }
    }
    return weapon_limit;
}

ammoregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		if(!self GetCurrentWeapon() == "claymore_zm" && !is_grenade_launcher( self GetCurrentWeapon()) )
		{
			stockcount = self getweaponammostock( self GetCurrentWeapon() );
			self setWeaponAmmostock( self GetCurrentWeapon(), stockcount + 1 );
			wait 2;
		}
		wait 0.1;
	}
}

grenadesregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		grenades = self get_player_lethal_grenade();
        grenade_count = self getweaponammoclip(grenades);
        if(grenade_count < 4)
		{
        	self setweaponammoclip(grenades, (grenade_count + 1));
		}
		tactical_grenades = self get_player_tactical_grenade();
        tactical_grenade_count = self getweaponammoclip(tactical_grenades);
        if(tactical_grenade_count < 3 )
		{
        	self setweaponammoclip(tactical_grenades, (tactical_grenade_count + 1));
		}
		wait 300;
	}
}

start_ec()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
	{
		self waittill( "reload_start" );
    	playfxontag( level._effect[ "poltergeist"], self, "J_SpineUpper" );
		self EnableInvulnerability();
		RadiusDamage(self.origin, 120, 200, 100, self);
		self DisableInvulnerability();
		self playsound( "zmb_turbine_explo" );
		wait 1;
	}
}

start_vt()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
	{
		if(self getcurrentweapon() == "riotshield_zm" )
		{
			self enableInvulnerability();
			self.shielddamagetaken += 100;
			wait 0.9;
		}
		else
		{
			self disableInvulnerability();
		}
		wait 0.1;
	}
}

start_er()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;)
    {
        if (self hascustomperk("Ethereal_Razor") && self ismeleeing())
        {
            foreach(zombie in getAiArray(level.zombie_team))
			{
                if( distance( self.origin, zombie.origin ) <= 100 )
				{
					if(self is_insta_kill_active())
					{
						zombie doDamage(zombie.maxhealth + 666, (0, 0, 0));
					}
                    zombie dodamage(500, (0, 0, 0));
                    if(zombie.health <= 0)
					{
                        self maps/mp/zombies/_zm_score::add_to_player_score( 100 );
						self.kills++;
					} 
					else 
					{
                        self maps/mp/zombies/_zm_score::add_to_player_score( 10 );
                    }
                } 
            }
            self.health += 20;
            if(self.health > self.maxhealth)
			{
                self.health = self.maxhealth;
            }
            while(self ismeleeing())
			{
                wait 0.1;
            }
        }
        wait 0.05;
    }
}

LastStand()
{
    if(self hascustomperk("Downers_Delight"))
	{
        self.customlaststandweapon = self getcurrentweapon();
		self switchtoweapon( self.customlaststandweapon );
		self setweaponammoclip( self.customlaststandweapon, 150 );
		self.bleedout_time = 40;
    } 
	else 
	{
        self maps/mp/zombies/_zm::last_stand_pistol_swap();
    }
}

DDown() 
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		self waittill("player_downed");
		self playsound( "zmb_phdflop_explo" );
		playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) ); 
		RadiusDamage(self.origin, 150, 600, 400, self);
		wait 0.1;
	}
}

doGivePerk(perk)
{
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    self endon("perk_abort_drinking");
    if (!(self hasperk(perk) || (self maps/mp/zombies/_zm_perks::has_perk_paused(perk))))
    {
        gun = self maps/mp/zombies/_zm_perks::perk_give_bottle_begin(perk);
        evt = self waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
        if (evt == "weapon_change_complete")
            self thread maps/mp/zombies/_zm_perks::wait_give_perk(perk, 1);
        self maps/mp/zombies/_zm_perks::perk_give_bottle_end(gun, perk);
        if (self maps/mp/zombies/_zm_laststand::player_is_in_laststand() || isDefined(self.intermission) && self.intermission)
            return;
        self notify("burp");
    }
}

wallweapons( weapon, origin, angles, cost, ammo )
{
	wallweap = spawnentity( "script_model", getweaponmodel( weapon ), origin, angles + ( 0, 50, 0 ) );
	wallweap thread wallweaponmonitor( weapon, cost, ammo );
}

pile_of_emp( weapon, origin, angles, cost )
{
	wallweap = spawnentity( "script_model", getweaponmodel( weapon ), origin, angles + ( 0, 50, 0 ) );
}

spawnentity( class, model, origin, angle )
{
	entity = spawn( class, origin );
	entity.angles = angle;
	entity setmodel( model );
	return entity;
}

wallweaponmonitor( weapon, cost, ammo ) 
{
	self endon( "game_ended" );
	weap = get_weapon_display_name( weapon );
	upgradedammocost = 4500;
	self.in_use_weap = 0;
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( distance( self.origin, player.origin ) <= 70 )
			{
				if(weapon == "m16_zm")
				{
                	player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold &&1 For Buy " + weap + " [Cost: " + cost + "] Ammo [Cost: 600] Upgraded Ammo [Cost: 4500]" );				
				}
				else
				{
                	player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold &&1 For Buy " + weap + " [Cost: " + cost + "]" );
				}
				if( player usebuttonpressed() && weapon != "m16_zm" && !(player hasWeapon(weapon)) && !(self.in_use_weap) && player.score >= cost  && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
				{
					player playsound( "zmb_cha_ching" );
					self.in_use_weap = 1;
					player.score -= cost;
					player thread weapon_give( weapon, 0, 1 );
					player iprintln( "^2" + ( weap + " Buy" ) );
                    wait 3;
			        self.in_use_weap = 0;
				}
				if(weapon == "m16_zm") 
				{
					if( player usebuttonpressed() && !(player hasWeapon("m16_gl_upgraded_zm")) && !(player hasWeapon(weapon)) && !(self.in_use_weap) && player.score >= cost  && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						player playsound( "zmb_cha_ching" );
						self.in_use_weap = 1;
						player.score -= cost;
						player thread weapon_give( weapon, 0, 1 );
						player iprintln( "^2" + ( weap + " Buy" ) );
                   	 	wait 3;
			       	 	self.in_use_weap = 0;
					}
					if( player usebuttonpressed() && (player hasWeapon(weapon)) && weapon != "riotshield_zm" && weapon != "claymore_zm" && weapon != "emp_grenade_zm" && !(self.in_use_weap) && player.score >= ammocost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						player playsound( "zmb_cha_ching" );
						self.in_use_weap = 1;
						player.score -= ammocost;
						player setweaponammoclip(weapon, 150);
						player setWeaponAmmostock(weapon, 900 );
						player iprintln( "^2" + ( weap + " Ammo Buy" ) );
                    	wait 3;
			        	self.in_use_weap = 0;
					}	
					if( player usebuttonpressed() && (player hasWeapon("m16_gl_upgraded_zm")) && weapon != "riotshield_zm" && weapon != "claymore_zm" && weapon != "emp_grenade_zm" && !(self.in_use_weap) && player.score >= upgradedammocost  && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						player playsound( "zmb_cha_ching" );
						self.in_use_weap = 1;
						player.score -= upgradedammocost;
						player setweaponammoclip("m16_gl_upgraded_zm", 150);
						player setWeaponAmmostock("m16_gl_upgraded_zm", 900 );
						player iprintln( "^2" + ( weap + " Upgraded Ammo Buy" ) );
                   		wait 3;
			       		self.in_use_weap = 0;
					}
				}
				else
				{
					if( player usebuttonpressed() && player.score < cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "no_money_weapon" );
					}
				}
			}
		}
		wait 0.1;
	}
}

start_fire_sale()
{
	if ( level.zombie_vars[ "zombie_powerup_fire_sale_time" ] > 0 && is_true( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] ) )
	{
		level.zombie_vars[ "zombie_powerup_fire_sale_time" ] += 30;
		return;
	}
	level notify( "powerup fire sale" );
	level endon( "powerup fire sale" );
	level thread maps/mp/zombies/_zm_audio_announcer::leaderdialog( "fire_sale" );
    level.zombie_vars[ "zombie_powerup_fire_sale_on" ] = 1;
	level thread toggle_fire_sale_on();
	level.zombie_vars[ "zombie_powerup_fire_sale_time" ] = 30;
	while ( level.zombie_vars[ "zombie_powerup_fire_sale_time" ] > 0 )
	{
		wait 0.05;
		level.zombie_vars[ "zombie_powerup_fire_sale_time" ] -= 0.05;
	}
	level.zombie_vars[ "zombie_powerup_fire_sale_on" ] = 0;
	level notify( "fire_sale_off" );
}

custom_powerup_grab(s_powerup, e_player)
{
	if (s_powerup.powerup_name == "fire_sale") 
	{
        foreach( player in level.players )
	   	{
    		player thread power_up_hud( 0, 0, "Fire Sale!" );
        }
        level thread start_fire_sale();
	}
	if (s_powerup.powerup_name == "zombie_cash")
	{
        e_player thread power_up_hud( 0, 0, "Zombie Cash!" );
        e_player.score += (100 * randomIntRange(-6, 21));
    }
	if (s_powerup.powerup_name == "unlimited_ammo")
	{	
		foreach(player in level.players)
	    {
		    player notify("end_unlimited_ammo");
		    player playsound("zmb_cha_ching");
		    player thread startammo();
		    player thread power_up_hud( "hud_icon_colt", 0, "Infinite Ammo!" );
		    player thread endammo();
	    }
	}
	if (s_powerup.powerup_name == "random_perk")
	{
	    foreach(player in level.players)
	    {
		    player thread give_random_perk();
		    player.score += 500;
	    }
	}
    if (s_powerup.powerup_name == "death_machine") 
	{
		e_player notify("Death_Machine");
		e_player thread Death_Machine();
	}
	else if (isDefined(level.original_zombiemode_powerup_grab))
		level thread [[level.original_zombiemode_powerup_grab]](s_powerup, e_player);
}

Death_Machine()
{
    self endon("Death_Machine");
    self thread No_Overheat();
    weap = "jetgun_zm";
    self giveweapon( weap, 0, self get_pack_a_punch_weapon_options( weap ) );
    self switchtoweapon( weap );
    self thread power_up_hud(0, "menu_mp_weapons_xm8", "Death Machine!" );
    wait 31;
    self notify("Death_Machine_Stop");
    self takeweapon("jetgun_zm");
}

No_Overheat()
{
    self endon("Death_Machine_Stop");
    for(;;)
	{
        self setweaponoverheating( 0, 0 );
        wait 0.1;
    }
}

SpawnHint( origin, width, height, cursorhint, string )
{
	hint = spawn( "trigger_radius", origin, 1, width, height );
	hint setcursorhint( cursorhint, hint );
	hint sethintstring( string );
	hint setvisibletoall();
	wait 0.2;
	hint delete();
}

power_up_hud(shader, shader2, text)
{
	self endon("disconnect");
	power_up_hud_string = newclienthudelem(self);
	power_up_hud_string.elemtype = "font";
	power_up_hud_string.font = "objective";
	power_up_hud_string.fontscale = 2;
	power_up_hud_string.x = 0;
	power_up_hud_string.y = 0;
	power_up_hud_string.width = 0;
	power_up_hud_string.height = int( level.fontheight * 2 );
	power_up_hud_string.xoffset = 0;
	power_up_hud_string.yoffset = 0;
	power_up_hud_string.children = [];
	power_up_hud_string setparent(level.uiparent);
	power_up_hud_string.hidden = 0;
	power_up_hud_string maps/mp/gametypes_zm/_hud_util::setpoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	power_up_hud_string.sort = .5;
	power_up_hud_string.alpha = 0;
	power_up_hud_string fadeovertime(.5);
	power_up_hud_string.alpha = 1;
	power_up_hud_string setText(text);
	power_up_hud_string thread string_move();
	if(shader)
	{
		power_up_hud_icon = newclienthudelem(self);
		power_up_hud_icon.horzalign = "center";
		power_up_hud_icon.vertalign = "bottom";
		power_up_hud_icon.x = -75;
		power_up_hud_icon.y = 0;
		power_up_hud_icon.alpha = 1;
		power_up_hud_icon.hidewheninmenu = true;   
		power_up_hud_icon setshader( shader, 30, 30);
		self thread power_up_hud_icon_blink(power_up_hud_icon);
		self thread destroy_power_up_icon_hud(power_up_hud_icon, 0);
	}
	if(shader2)
	{
		power_up_hud2_icon = newclienthudelem(self);
		power_up_hud2_icon.horzalign = "center";
		power_up_hud2_icon.vertalign = "bottom";
		power_up_hud2_icon.x = -110;
		power_up_hud2_icon.y = 0;
		power_up_hud2_icon.alpha = 1;
		power_up_hud2_icon.hidewheninmenu = true;   
		power_up_hud2_icon setshader( shader2, 30, 30);
		self thread power_up_hud_icon_blink(power_up_hud2_icon);
		self thread destroy_power_up_icon_hud(0, power_up_hud2_icon);
	}
}

string_move()
{
	wait .5;
	self fadeovertime(1.5);
	self moveovertime(1.5);
	self.y = 270;
	self.alpha = 0;
	wait 1.5;
	self destroy();
}

power_up_hud_icon_blink(elem)
{
	level endon("disconnect");
	self endon("disconnect");
	time_left = 30;
	for(;;)
	{
		if(time_left <= 5)
			time = .1;
		else if(time_left <= 10)
			time = .2;
		else
		{
			wait .05;
			time_left -= .05;
			continue;
		}
		elem fadeovertime(time);
		elem.alpha = 0;
		wait time;
		elem fadeovertime(time);
		elem.alpha = 1;
		wait time;
		time_left -= time * 2;
	}
}

destroy_power_up_icon_hud(elem, elem2)
{
	level endon("game_ended");
	if (s_powerup.powerup_name == "unlimited_ammo")
	{
		self waittill_any_timeout( "disconnect", "end_unlimited_ammo");
		elem destroy();
	}
	if (s_powerup.powerup_name == "death_machine")
	{
		self waittill_any_timeout( "disconnect", "Death_Machine_Stop");
		elem2 destroy();
	}
}

endammo()
{
	level endon("game_ended");
	self endon("disonnect");
	self endon("end_unlimited_ammo");
	wait level.power_up_duration;
	self playsound("zmb_insta_kill");
	self notify("end_unlimited_ammo");
}

startammo()
{
	level endon("game_ended");
	self endon("disonnect");
	self endon("end_unlimited_ammo");
	for(;;)
	{
		wait 0.1;
		weapon = self getcurrentweapon();
		if( weapon != "none"  && weapon != "claymore_zm" )
		{
			max = weaponmaxammo( weapon );
			if( IsDefined( max ) )
			{
				self setweaponammoclip( weapon, 150 );
				wait 0.02;
			}
		}
	}

}

ww_points( player )
{
    for(i = 0; i < 3; i++)
    {
		self maps/mp/zombies/_zm_utility::set_zombie_run_cycle("walk");
        player maps/mp/zombies/_zm_score::add_to_player_score( 10 );
        PlayFXOnTag(level.effect_WebFX,self,"j_spineupper");
        self doDamage(150, (0, 0, 0));
        wait 1;
    }
}

ww_nade_explosion()
{
    wait 2;
    if( self maps/mp/zm_transit_lava::object_touching_lava())
	{
        self delete();
        return 0;
    }
	foreach(zombie in getAiArray(level.zombie_team))
	{
        if( distance( zombie.origin, self.origin ) < 210 )
		{
            zombie thread ww_points( self );
        }
    }
    self delete();
}

ww_nades()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;)
	{
        self waittill( "grenade_fire", grenade, weapname );
        if( weapname == "sticky_grenade_zm" )
		{
            ww_nade = spawnsm( grenade.origin, "zombie_bomb" );
            ww_nade hide();
            ww_nade linkto( grenade );
            ww_nade thread ww_nade_explosion();
        }
    }
}

spawnsm( origin, model, angles )
{
    ent = spawn( "script_model", origin );
    ent setmodel( model );
    if( IsDefined( angles ) )
    {
        ent.angles = angles;
    }
    return ent;
}

damage_callback( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
    if( isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie && self hascustomperk("WIDOWS_WINE") )
	{
		zombies = getaiarray(level.zombie_team);
        foreach(zombie in zombies)
    	{
	   		if(distance(self.origin, zombie.origin) < 150)
        	{
				grenades = self get_player_lethal_grenade();
            	grenade_count = self getweaponammoclip(grenades);
            	if(grenade_count > 0)
				{
					self PlaySound("zmb_elec_jib_zombie");
                	self setweaponammoclip(grenades, (grenade_count - 1));
					zombie thread ww_points( self );
				}
            }
		}
    }
	if(self hascustomperk("PHD_FLOPPER"))
	{
        if( smeansofdeath == "MOD_FALLING" )
		{
            if(isDefined( self.divetoprone ) && self.divetoprone == 1 )
			{
                radiusdamage( self.origin, 300, 5000, 1000, self, "MOD_GRENADE_SPLASH" );
                playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) ); 
                self playsound( "zmb_phdflop_explo" );
            }
            return 0;
        }
        if( smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH" && eattacker == self)
		{
            return 0;
        }
    }
    if(idamage > self.health && !self.dying_wish_on_cooldown && self hascustomperk("Dying_Wish") )
	{
        self notify("dying_wish_charge");
        self thread dying_wish_effect();
        return 0;
	}
	else
	{
        return idamage;
    }
}

dying_wish_checker()
{
    level endon("end_game");
    self endon("disconnect");
    self endon( "stopcustomperk" );
    self.dying_wish_uses = 0;
    for(;;)
	{
        self.dying_wish_on_cooldown = 0;
        self.perk10back.alpha = 1;
        self.perk10front.alpha = 1;
        self waittill("dying_wish_charge");
        self.perk10back.alpha = 0.3;
        self.perk10front.alpha = 0.4;
        self.dying_wish_uses++;
        self.dying_wish_on_cooldown = 1;
        delay = 300 + (self.dying_wish_uses * 30);
        if(delay >= 600)
        delay = 600;
        wait delay;
    }
}

dying_wish_effect()
{
    self enableInvulnerability();
    self.ignoreme = 1;
    self useServerVisionSet(true);
    self setvisionsetforplayer( "zombie_death", 0 );
    self freezeControls(1);
    wait 1;
    self freezeControls(0);
    wait 8;
	self.health = 1;
    self disableInvulnerability();
    self.ignoreme = 0;
    self useServerVisionSet(false);
    self setvisionsetforplayer("remote_mortar_enhanced", 0);
}

give_random_perk()
{
    perks = array();
	if(!self hascustomperk("Downers_Delight"))
	{
    	perks[perks.size] = "Downers_Delight";
    }
    if(!self hascustomperk("PHD_FLOPPER"))
	{
        perks[perks.size] = "PHD_FLOPPER";
    }
    if(!self hascustomperk("Victorious_Tortoise"))
	{
        perks[perks.size] = "Victorious_Tortoise";
    }
    if(!self hascustomperk("MULE"))
	{
        perks[perks.size] = "MULE";
    }
    if(!self hascustomperk("ELECTRIC_CHERRY"))
	{
        perks[perks.size] = "ELECTRIC_CHERRY";
    }
    if(!self hascustomperk("WIDOWS_WINE"))
	{
        perks[perks.size] = "WIDOWS_WINE";
    }
    if(!self hascustomperk("Ethereal_Razor"))
	{
        perks[perks.size] = "Ethereal_Razor";
    }
	if(!self hascustomperk("Ammo_Regen"))
	{
        perks[perks.size] = "Ammo_Regen";
    }
	if(!self hascustomperk("Burn_Heart"))
	{
		perks[perks.size] = "Burn_Heart";
	}
	if(!self hascustomperk("Dying_Wish"))
	{
        perks[perks.size] = "Dying_Wish";
    }
	if(!self hascustomperk("deadshot"))
	{
        perks[perks.size] = "deadshot";
    }
    if(!self hasPerk("specialty_armorvest"))
	{
        perks[perks.size] = "specialty_armorvest";
    }
    if(!self hasPerk("specialty_rof"))
	{
        perks[perks.size] = "specialty_rof";
    }
    if(!self hasPerk("specialty_fastreload"))
	{
        perks[perks.size] = "specialty_fastreload";
    }
    if(!self hasPerk("specialty_longersprint"))
	{
        perks[perks.size] = "specialty_longersprint";
    }
    if(!self hasPerk("specialty_quickrevive"))
	{
        perks[perks.size] = "specialty_quickrevive";
    }
    if(!perks.size > 0)
	{
        self playSoundToPlayer( level.zmb_laugh_alias, self );
        return 0;
    }
    n = array_randomize(perks);
    perk = n[0];
    if(perk == "specialty_armorvest" || perk == "specialty_rof" || perk == "specialty_fastreload" || perk == "specialty_longersprint" || perk == "specialty_quickrevive")
	{
        self maps/mp/zombies/_zm_perks::give_perk(perk, 0);
    } 
    else 
    {
        self drawshader_and_shadermove(perk, 0, 1);
    }
}

OnGameEndedHint( player )
{
	level waittill("end_game");
	hud = player createFontString("objective", 2);
    hud setText("Thank you for playing.");
    hud.x = 0;
	hud.y = 0;
	bar.alignx = "center";
	bar.aligny = "center";
	bar.horzalign = "fullscreen";
	bar.vertalign = "fullscreen";
	hud.color = (1,1,1);
	hud.alpha = 1;
	hud.glowColor = (1,1,1);
	hud.glowAlpha = 0;
	hud.sort = 5;
	hud.archived = false;
	hud.foreground = true;
}

boss_round_monitor()
{
	self endon("disconnect");
	self endon("game_ended");
    power_up = [];
	power_up[0] = "nuke";
	power_up[1] = "insta_kill";
	power_up[2] = "double_points";
	power_up[3] = "full_ammo";
	power_up[4] = "fire_sale";
	power_up[5] = "random_perk";
	power_up[6] = "death_machine";
	power_up[7] = "zombie_cash";
    power_up[8] = "carpenter";
	power_up[9] = "unlimited_ammo";	
	level.bossround = level.round_number + randomintrange( 3, 6 );
	for(;;)
	{
		level waittill( "between_round_over" );
		flag_wait( "start_zombie_round_logic" );
		player = level.players;
		if(player[0] == self)
		{
			if( level.round_number == level.bossround ) 
			{
				if( level.dog_rounds == level.round_number ) 
				{
					level.bossround = level.round_number + 1;
				}
				else
				{
					self thread flame_boss();
					wait 2;
				}
			}
		}
		while(level.boss_is_alive)
		{
       		if(level.inferno.health > 0 && level.boss_is_alive)
       		{
       		   	wait 1;
       		}
			if(level.inferno.health <= 0)
			{
        		level.boss_is_alive = 0;
        		self notify("boss_dead");
				self notify("stop_flame_sounds");
        		playfx(loadfx("explosions/fx_default_explosion"), level.inferno.origin, anglestoforward( ( 0, 45, 55  ) ) ); 
        		RadiusDamage(level.inferno.origin, 200, 3000, 2999, self);
                if(player[0] == self)
                {
			        player[0] specific_powerup_drop(power_up[ randomintrange( 0, 10 )], level.inferno.origin );
                }
                level waittill("end_of_round");
				level.bossround = level.round_number + randomintrange( 3, 6 );
			}
		wait 1;
		}
	wait 1;
	}
}

flame_boss() 
{
	self endon("death");
	self endon("boss_dead");
	level endon("end_of_round");
    inferno_spawn = [];
	inferno_spawn[0] = ( 1615.65, 272.551, -61.875 );
	inferno_spawn[1] = ( 1479.65, -1430.551, -54.075 );
    inferno_spawn[2] = ( 1544.65, 794.551, -61.875 );
	inferno_spawn[3] = ( 1110.65, -588.551, -61.875 );
	spawner = random( level.zombie_spawners );
	inferno = spawn_zombie( spawner );
	level.boss_is_alive = 1;
	level.zombie_health = level.zombie_vars["zombie_health_start"];  
	level.zombie_health = 20000;
	inferno forceteleport( inferno_spawn[ randomintrange( 0, 4 )]);
	inferno.start_inert = 1;
	inferno.ignore_nuke = 1;
	inferno.ignore_enemyoverride = 1;
	level.inferno = inferno;
	wait 2;
	self.waiting_explosion = 0;
	self.waiting_time = 3;
    for(;;)
	{
		inferno thread burning_boss_fx();
		wait 1;
		inferno maps/mp/zombies/_zm_utility::set_zombie_run_cycle( "walk" );
		self.waiting_explosion = 0;
        while(distance(self.origin, inferno.origin) < 300 && level.boss_is_alive)
		{
			inferno thread burning_boss_fx();
			maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_transit_burn", self, 1, 1);
			self thread player_burning_audio();
			wait 1;
			self.waiting_explosion = 0;
			while(distance(self.origin, inferno.origin) < 200 && level.boss_is_alive)
			{
				inferno thread burning_boss_fx();
				maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_transit_burn", self, 1, 1);
				inferno maps/mp/zombies/_zm_utility::set_zombie_run_cycle( "sprint" );
				self thread player_burning_audio();
				self dodamage( 15, self.origin);
				wait 1;
				self.waiting_explosion = 0;
				while(distance(self.origin, inferno.origin) < 150 && level.boss_is_alive)
				{
					inferno thread burning_boss_fx();
					maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_transit_burn", self, 1, 1);
					inferno maps/mp/zombies/_zm_utility::set_zombie_run_cycle( "sprint" );
					self thread player_burning_audio();
					self.waiting_explosion++;
					self dodamage( 20, self.origin);
					wait 1;
					if( self.waiting_explosion >= self.waiting_time )
					{
						inferno dodamage( 50001, inferno.origin);
						playfx(loadfx("explosions/fx_default_explosion"), level.inferno.origin, anglestoforward( ( 0, 45, 55 ) ) ); 
						break;
					}
				}
			}
		}
	self notify("stop_flame_sounds");
    wait 0.1;
    }
}

burning_boss_fx()
{
	flameFX=loadfx("env/fire/fx_fire_zombie_torso");
	PlayFXOnTag(flameFX,self, "j_spinelower");
	flameFX2=loadfx("env/fire/fx_fire_zombie_md");
    PlayFXOnTag(flameFX2,self,"j_spineupper");
}

player_burning_audio()
{
	fire_ent = spawn( "script_model", self.origin );
	wait_network_frame();
	fire_ent linkto( self );
	fire_ent playloopsound( "evt_plr_fire_loop" );
	self waittill_any( "stop_flame_damage", "stop_flame_sounds", "death", "disconnect" );
	fire_ent delete();
}

Perkaholic()
{
	self.num_perks = 0;
	if(!self hasperk("specialty_armorvest"))
	{
    	self give_perk( "specialty_armorvest" );
		wait 0.1;
	}
	else
	{
		self.num_perks++;
	}
	if(!self hasperk("specialty_fastreload"))
	{
		self give_perk( "specialty_fastreload" );
		wait 0.1;
	}
	else
	{
		self.num_perks++;
	}
	if(!self hasperk("specialty_rof"))
	{
    	self give_perk( "specialty_rof" );
		wait 0.1;
	}
	else
	{
		self.num_perks++;
	}
	if( getdvar( "mapname" ) == "zm_transit")
	{
		if(!self hasperk("specialty_quickrevive"))
		{
			self give_perk( "specialty_quickrevive" );
			wait 0.1;
		}
		else
		{
			self.num_perks++;
		}
		/*if(!self hasperk("specialty_scavenger"))
    	{
			self give_perk( "specialty_scavenger" );
			wait 0.1;
		}
		else
		{
			self.num_perks++;
		}*/
		if(!self hasperk("specialty_longersprint"))
		{
			self give_perk( "specialty_longersprint" );
			wait 0.1;
		}
		else
		{
			self.num_perks++;
		}
	}
	if( getdvar( "mapname" ) == "zm_prison" )
	{
		if(!self hasperk("specialty_grenadepulldeath"))
		{
        	self give_perk("specialty_grenadepulldeath");
		}
		if(!self hasperk("specialty_deadshot"))
        {
			self give_perk("specialty_deadshot");
		}
	}
	if( getdvar( "mapname" ) == "zm_nuked" )
	{
		if(!self hasperk("specialty_quickrevive"))
		{
			self give_perk("specialty_quickrevive");
		}
	}
	if( getdvar( "mapname" ) == "zm_tomb")
	{
		if(!self hasperk("specialty_deadshot"))
		{
			self give_perk( "specialty_deadshot" );
		}
		if(!self hasperk("specialty_grenadepulldeath"))
		{
    		self give_perk( "specialty_grenadepulldeath" );
		}
		if(!self hasperk("specialty_flakjacket"))
    	{
			self give_perk( "specialty_flakjacket" );
		}
		if(!self hasperk("specialty_quickrevive"))
        {
			self give_perk( "specialty_quickrevive" );
		}
		if(!self hasperk("specialty_additionalprimaryweapon"))
		{
			self give_perk( "specialty_additionalprimaryweapon" );
		}
		if(!self hasperk("specialty_longersprint"))
		{
			self give_perk( "specialty_longersprint" );
		}
	}
	if( getdvar( "mapname" ) == "zm_buried")
	{
		if(!self hasperk("specialty_nomotionsensor"))
    	{
			self give_perk("specialty_nomotionsensor");
		}
		if(!self hasperk("specialty_additionalprimaryweapon"))
		{
			self give_perk( "specialty_additionalprimaryweapon" );
		}
		if(!self hasperk("specialty_quickrevive"))
    	{
			self give_perk( "specialty_quickrevive" );
		}
		if(!self hasperk("specialty_longersprint"))
		{
			self give_perk( "specialty_longersprint" );
		}
	}
	if( getdvar( "mapname" ) == "zm_highrise" )
	{
		if(!self hasperk("specialty_quickrevive"))
		{
			self give_perk("specialty_quickrevive");
		}
		if(!self hasperk("specialty_finalstand"))
    	{
			self give_perk( "specialty_finalstand" );
		}
		if(!self hasperk("specialty_additionalprimaryweapon"))
	    {
			self give_perk("specialty_additionalprimaryweapon");
		}
	}
    self.perk_reminder = self.num_perks;
    self.perk_count = self.num_perks;
	wait 0.2;
	if(level.town)
	{
		if(!self hascustomperk("Downers_Delight"))
		{
			self drawshader_and_shadermove( "Downers_Delight", 0, 0 );
			wait 0.15;
		}
    	if(!self hascustomperk("MULE"))
		{
			self drawshader_and_shadermove( "MULE", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("PHD_FLOPPER"))
		{
			self drawshader_and_shadermove( "PHD_FLOPPER", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("Victorious_Tortoise"))
		{
			self drawshader_and_shadermove( "Victorious_Tortoise", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("ELECTRIC_CHERRY"))
		{
			self drawshader_and_shadermove( "ELECTRIC_CHERRY", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("WIDOWS_WINE"))
		{
			self drawshader_and_shadermove( "WIDOWS_WINE", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("Ethereal_Razor"))
		{
			self drawshader_and_shadermove( "Ethereal_Razor", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("Ammo_Regen"))
		{
			self drawshader_and_shadermove( "Ammo_Regen", 0, 0 );
			wait 0.15;
    	}
		if(!self hascustomperk("Burn_Heart"))
		{
			self drawshader_and_shadermove( "Burn_Heart", 0, 0 );
			wait 0.15;
    	}
		if(!self hascustomperk("Dying_Wish"))
		{
			self drawshader_and_shadermove( "Dying_Wish", 0, 0 );
			wait 0.15;
    	}
		if(!self hascustomperk("deadshot"))
		{
			self drawshader_and_shadermove( "deadshot", 0, 0 );
			wait 0.15;
    	}
	}
	if(level.diner)
	{
		if(!self hascustomperk("Downers_Delight"))
		{
			self thread drawshader_and_shadermove( "Downers_Delight", 0, 0 );
    	}
    	if(!self hascustomperk("MULE"))
		{
			self thread drawshader_and_shadermove( "MULE", 0, 0 );
    	}
    	if(!self hascustomperk("PHD_FLOPPER"))
		{
			self thread drawshader_and_shadermove( "PHD_FLOPPER", 0, 0 );
    	}
    	if(!self hascustomperk("Victorious_Tortoise"))
		{
			self thread drawshader_and_shadermove( "Victorious_Tortoise", 0, 0 );
    	}
    	if(!self hascustomperk("ELECTRIC_CHERRY"))
		{
			self thread drawshader_and_shadermove( "ELECTRIC_CHERRY", 0, 0 );
    	}
    	if(!self hascustomperk("WIDOWS_WINE"))
		{
			self thread drawshader_and_shadermove( "WIDOWS_WINE", 0, 0 );
    	}
    	if(!self hascustomperk("Ethereal_Razor"))
		{
			self thread drawshader_and_shadermove( "Ethereal_Razor", 0, 0 );
    	}	
	}
}

custom_spawning() 
{
	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
	if ( level.intermission )
	{
		return;
	}
	if ( level.zombie_spawn_locations.size < 1 )
	{
		return;
	}
	ai_calculate_health( level.round_number );
	count = 0;
	players = get_players();
	for ( i = 0; i < players.size; i++ )
	{
		players[ i ].zombification_time = 0;
	}
	max = level.zombie_vars[ "zombie_max_ai" ];
	multiplier = level.round_number / 5;
	if ( multiplier < 1 )
	{
		multiplier = 1;
	}
	if ( level.round_number >= 10 )
	{
		multiplier *= level.round_number * 0.15;
	}
	player_num = get_players().size;
	if ( player_num == 1 )
	{
		max += int( 0.5 * level.zombie_vars[ "zombie_ai_per_player" ] * multiplier );
	}
	else
	{
		max += int( ( player_num - 1 ) * level.zombie_vars[ "zombie_ai_per_player" ] * multiplier );
	}
	if ( !isDefined( level.max_zombie_func ) )
	{
		level.max_zombie_func = ::default_max_zombie_func;
	}
	level.zombie_total = [[ level.max_zombie_func ]]( max );
	if ( isDefined( level.zombie_total_set_func ) )
	{
		level thread [[ level.zombie_total_set_func ]]();
	}
	if ( level.round_number < 10 || level.speed_change_max > 0 )
	{
		level thread zombie_speed_up();
	}
	mixed_spawns = 0;
	old_spawn = undefined;
	while(level.dog_rounds != level.round_number)
	{
		while ( get_current_zombie_count() >= level.zombie_ai_limit || level.zombie_total <= 0 )
		{
			wait 0.1;
		}
		while ( get_current_actor_count() >= level.zombie_actor_limit )
		{
			clear_all_corpses();
			wait 0.1;
		}
		flag_wait( "spawn_zombies" );
		while ( level.zombie_spawn_locations.size <= 0 )
		{
			wait 0.1;
		}
		spawner = random( level.zombie_spawners );
		zombie = spawn_zombie( spawner );
		level.zombie_total--;
		wait level.zombie_vars[ "zombie_spawn_delay" ];
		wait_network_frame();
	}
	if( level.dog_rounds == level.round_number ) 
	{
		level.music_round_override = 1;
		level thread maps/mp/zombies/_zm_audio::change_zombie_music( "dog_start" );
		level.dog_health += 400;
		if ( level.dog_health > 1600 )
		{
			level.dog_health = 1600;
		}
        level thread dog_round_aftermath();
		foreach(player in level.players)
		{
			player thread power_up_hud(0, "Fetch me their souls!");
			player playleaderdialogonplayer( "dogstart", self.team, 5 );
		}
		while( level.dog_rounds == level.round_number )
		{
			if(level.zombie_total > 100 )
			{
				level.zombie_total = 100;
			}
			while ( get_current_zombie_count() >= level.zombie_ai_limit || level.zombie_total <= 0 )
			{
				wait 0.1;
			}
			clear_all_corpses();
			maps\mp\zombies\_zm_ai_dogs::special_dog_spawn( undefined, 1 );
			level.zombie_total--;
			wait 0.2;
			wait_network_frame();
		}
	}
}

dog_round_aftermath()
{
	level waittill( "last_dog_down" );
	level thread maps/mp/zombies/_zm_audio::change_zombie_music( "dog_end" );
	level.music_round_override = 0;
	power_up_origin = level.last_dog_origin;
	if ( isDefined( power_up_origin ) )
	{
		level thread maps/mp/zombies/_zm_powerups::specific_powerup_drop( "full_ammo", power_up_origin );
	}
	wait 2;
	clientnotify( "dog_stop" );
	wait 10;
    level.dog_rounds = level.round_number + randomintrange( 4, 7 );
}

default_max_zombie_func( max_num )
{
	max = max_num;
	if ( level.round_number < 2 )
	{
		max = int( max_num * 0.25 );
	}
	else if ( level.round_number < 3 )
	{
		max = int( max_num * 0.3 );
	}
	else if ( level.round_number < 4 )
	{
		max = int( max_num * 0.5 );
	}
	else if ( level.round_number < 5 )
	{
		max = int( max_num * 0.7 );
	}
	else
	{
		if ( level.round_number < 6 )
		{
			max = int( max_num * 0.9 );
		}
	}
	level.zombie_total = max;
	return max;
}