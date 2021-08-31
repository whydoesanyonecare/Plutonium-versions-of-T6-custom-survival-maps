//bus ride beta 

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
#include maps/mp/zm_transit_bus;
#include maps/mp/zm_transit_utility;
init()
{
	if( getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype")  == "zclassic" )
	{
		level.precachemodels = array("collision_wall_256x256x10_standard","collision_clip_32x32x32","collision_clip_64x64x64","p6_window_frame_wood_white_diner","p6_zm_buildable_sq_meteor","p_rus_bathroom_papertowel","p_glo_bathroom_sink","bathroom_urinal","p_glo_bathroom_toilet","veh_t6_civ_bus_zombie","zombie_vending_tombstone_on","collision_wall_512x512x10_standard","collision_clip_32x32x128","p6_anim_zm_buildable_pap_on");
		foreach(model in level.precachemodels)
		{
			precachemodel(model);
		}
        precacheshaders = array("specialty_marathon_zombies","killiconheadshot","hud_icon_sticky_grenade","menu_mp_lobby_icon_customgamemode","specialty_divetonuke_zombies","zombies_rank_1","zombies_rank_3","zombies_rank_2","zombies_rank_4","zombies_rank_5","menu_lobby_icon_facebook","menu_mp_weapons_1911","hud_icon_colt","waypoint_revive","hud_grenadeicon","damage_feedback","menu_lobby_icon_twitter","specialty_doubletap_zombies");
		foreach(shader in precacheshaders)
		{
			precacheshader(shader);
		}
        level.player_out_of_playable_area_monitor = 0;
        level.perk_purchase_limit = 20;
        level.custom_vending_precaching = ::default_vending_precaching;
        level.get_player_weapon_limit = ::custom_get_player_weapon_limit;
        level.zombie_last_stand = ::LastStand;
        register_player_damage_callback( ::playerdamagelastcheck );
        level.effect_WebFX = loadfx("misc/fx_zombie_powerup_solo_grab");
        level._effect[ "screecher_vortex" ] = loadfx( "maps/zombie/fx_zmb_screecher_vortex" );
        safe_area();
		level thread onPlayerConnect();
		level thread drawZombiesCounter();
        level thread teleport_avogadro();
        level maps\mp\zombies\_zm_game_module::turn_power_on_and_open_doors();
        box_init();
        remove();
        setdvar("r_fog", "0");
        setDvar( "scr_screecher_ignore_player", 1 );
        level.pers_upgrades_keys = [];
	    level.pers_upgrades = [];
        //level.the_bus.skip_next_destination = 1; //nonstop bus ride
        level thread bus_tele();
        level.power_up = [];
		level.power_up[0] = "nuke";
		level.power_up[1] = "insta_kill";
		level.power_up[2] = "double_points";
		level.power_up[3] = "full_ammo";
	}
	else
	{
        level waittill( "connected", player );
    	player waittill("spawned_player");
        flag_wait( "initial_blackscreen_passed" );
        player iprintln( "^1Error! Please play in Transit Normal Mode." );
		setdvar( "ui_errorMessage", "^9Please use Transit Normal Mode.");
	    setdvar( "ui_errorTitle", "^1Error" );
	}
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onplayerspawned()
{
    self waittill("spawned_player");
    self.perkarray = [];
	self.dying_wish_on_cooldown = 0;
    self.perk_reminder = 0;
    self.perk_count = 0;
    self.num_perks = 0;
    self.teleported = 0;
    self thread removeperkshader();
	self thread damagehitmarker();
	level thread OnGameEndedHint(self);
	self thread perkboughtcheck();
	self.score = 5000;
    self spawnpoint();
    self thread timer();
	self thread lag_failsafe();
    flag_wait( "initial_blackscreen_passed" );
	playfx(loadfx( "maps/zombie/fx_zmb_screecher_vortex" ), ( 10100, 8525, 1010 ), anglestoforward( ( 90, -90, 0 ) ) );
    wait 3;
    self iprintln("The ^1Bus ^7Ride - Survival");
    for(;;)
    {
        self waittill("spawned_player");
        self spawnpoint();
        self thread timer();
        if(self.score < 5000)
        {
            self.score = 5000;
        }
    }
}

lag_failsafe()
{
	flag_wait( "initial_blackscreen_passed" );
	x = randomfloatrange(10, 40);
    y = randomfloatrange(10, 40);
	for(;;)
	{
		if(distance((10180, 8716, 970), self.origin) > 400 && distance((level.the_bus.origin), self.origin) > 400 && distance((-6814, 5176, -55), self.origin) > 400)
		{
			self setorigin((level.the_bus.origin + (x,y,20)));
			iprintln("teleported");
		}
		wait .1;
	}
}

teleport_avogadro()
{
	self endon("disconnect");
	flag_wait( "initial_blackscreen_passed" );
	for(;;)
	{	
		foreach(zombie in getAiArray(level.zombie_team))
		{
			if( isDefined( zombie.is_avogadro ) && zombie.is_avogadro )
			{
				zombie forceteleport(( 1588.01, 62.551, 1000.875 ));
			}
		}
		wait 0.3;
	}
}

portal()
{
    x = randomfloatrange(10, 40);
    y = randomfloatrange(10, 40);
	while(1)
	{
		foreach(player in level.players)
		{
            player.cooldowntime = 0;
			if(distance(( 10100, 8525, 960 ), player.origin) <= 40 && !player.cooldowntime)
			{
				player.cooldowntime = 1;
				wait .1;
				player setorigin((level.the_bus.origin + (x,y,20)));
                player.teleported = 1;
				wait .1;
				player.cooldowntime = 0;
			}
			wait .1;
		}
        wait .1;
	}
}

drawZombiesCounter()
{
	flag_wait( "initial_blackscreen_passed" );
    thread spawn_infinite_powerup_drop( (10350, 8580, 965), level.power_up[ randomintrange( 0, 4 )] );
    level.zombiesCounter = createServerFontString("hudsmall" , 1.9);
    level.zombiesCounter setPoint("RIGHT", "TOP", 315, "RIGHT");
    while(true)
    {
        enemies = get_round_enemy_array().size + level.zombie_total;
        level.zombiesCounter.label = &"Zombies: ^1";
        level.zombiesCounter setValue( enemies );
        wait 0.05;
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

SpawnPoint()
{
	player = level.players;
	if( player[ 0] == self )
	{
		player[ 0] setorigin( (10180, 8716, 970) );
	}
	if( player[ 1] == self )
	{
		player[ 1] setorigin( (10130, 8770, 970) );
	}
	if( player[ 2] == self )
	{
		player[ 2] setorigin( (10150, 8720, 970) );
	}
	if( player[ 3] == self )
	{
		player[ 3] setorigin( (10140, 8690, 970));
	}
	if( player[ 4] == self )
	{
		player[ 4] setorigin( (10130, 8770, 970) );
	}
	if( player[ 5] == self )
	{
		player[ 5] setorigin( (10110, 8690, 970) );
	}
	if( player[ 6] == self )
	{
		player[ 6] setorigin( (10160, 8710, 970) );
	}
	if( player[ 7] == self )
	{
		player[ 7] setorigin( (10170, 8680, 970));
	}
}

remove()
{
    flag_wait( "initial_blackscreen_passed" );
    doorstrigger = getentarray( "bus_door_trigger", "targetname" );
	doorstrigger[0] delete();
	doorstrigger[1] delete();
    driver = getent( "bus_driver_head", "targetname" );
	if ( isDefined( driver ) )
	{
		driver delete();
	}
}

timer()
{
    flag_wait( "initial_blackscreen_passed" );
    self.timer = createFontString("hudsmall" , 1.8);
    self.timer setPoint("MIDDLE", "TOP");
    for(i=60;i>-1;i--)
    {
		self.timer.label = &"You will be teleported out of safe area in ^1";
        self.timer setValue( i );
        if(i == 0)
        {
            x = randomfloatrange(10, 20);
            y = randomfloatrange(10, 20);
		    self setorigin((level.the_bus.origin + (x,y,20)));
        }
        if(self.teleported)
        {
            self.teleported = 0;
            break;
        }
        wait 1;
    }
	self.timer destroy();
}

safe_area()
{
        collision( "script_model", (10100, 8550, 960.125), "", ( 0, 0, 0 ), "teleport" ); //teleport portal

        collision( "script_model", (10406, 8516, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 90, 0 ) ); 
	    collision( "script_model", (10271, 8515, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 90, 0 ) ); 
	    collision( "script_model", (10136, 8513, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 90, 0 ) ); 
	    collision( "script_model", (10005, 8512, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 90, 0 ) ); 
		collision( "script_model", (10120, 8535, 1045), "collision_wall_512x512x10_standard", ( 0, 0, 0 ) ); 
		//box wall
	    collision( "script_model", (10404, 8641, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 180, 0 ) ); 
	    collision( "script_model", (10403, 8776, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 180, 0 ) ); 
	    collision( "script_model", (10402, 8911, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 180, 0 ) ); 
	    collision( "script_model", (10401, 9046, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 180, 0 ) ); 
		collision( "script_model", (10370, 8780, 1045), "collision_wall_512x512x10_standard", ( 0, 90, 0 ) ); 
	    collision( "script_model", (10267, 9047, 970), "p6_zm_bank_vault_floor_hatch", ( 90, -90, 0 ) ); 
	    collision( "script_model", (10131, 9046, 970), "p6_zm_bank_vault_floor_hatch", ( 90, -90, 0 ) ); 
	    collision( "script_model", (9997, 9045, 970), "p6_zm_bank_vault_floor_hatch", ( 90, -90, 0 ) ); 
	    collision( "script_model", (9868, 9044, 970), "p6_zm_bank_vault_floor_hatch", ( 90, -90, 0 ) ); 
	    collision( "script_model", (9732, 9043, 970), "p6_zm_bank_vault_floor_hatch", ( 90, -90, 0 ) ); 
	    collision( "script_model", (9597, 9042, 970), "p6_zm_bank_vault_floor_hatch", ( 90, -90, 0 ) ); 
	    collision( "script_model", (9462, 9041, 970), "p6_zm_bank_vault_floor_hatch", ( 90, -90, 0 ) ); 
	    collision( "script_model", (9327, 9040, 970), "p6_zm_bank_vault_floor_hatch", ( 90, -90, 0 ) ); 
		collision( "script_model", (10130, 9035, 1045), "collision_wall_512x512x10_standard", ( 0, 0, 0 ) ); 
		collision( "script_model", (9880, 9035, 1045), "collision_wall_512x512x10_standard", ( 0, 0, 0 ) ); 
		collision( "script_model", (9680, 9035, 1045), "collision_wall_512x512x10_standard", ( 0, 0, 0 ) ); 
		collision( "script_model", (9600, 9035, 1045), "collision_wall_512x512x10_standard", ( 0, 0, 0 ) ); 
	    collision( "script_model", (9810, 8911, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 0, 0 ) ); 
	    collision( "script_model", (9811, 8776, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 0, 0 ) ); 
	    collision( "script_model", (9812, 8641, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 0, 0 ) ); 
		collision( "script_model", (9813, 8776, 1045), "collision_wall_512x512x10_standard", ( 0, 90, 0 ) ); 
	    collision( "script_model", (9462, 8641, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 90, 0 ) ); 
	    collision( "script_model", (9597, 8642, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 90, 0 ) ); 
	    collision( "script_model", (9733, 8643, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 90, 0 ) ); 
	    collision( "script_model", (9768, 8645, 1070), "p6_zm_bank_vault_floor_hatch", ( 0, 180, 90 ) ); 
	    collision( "script_model", (9768, 8644, 935), "p6_zm_bank_vault_floor_hatch", ( 0, 180, 90 ) ); 
		collision( "script_model", (9533, 8655, 1045), "collision_wall_512x512x10_standard", ( 0, 0, 0 ) ); 
		collision( "script_model", (9633, 8655, 1045), "collision_wall_512x512x10_standard", ( 0, 0, 0 ) ); 
	    collision( "script_model", (9869, 8520, 970), "p6_zm_bank_vault_floor_hatch", ( 90, 0, 0 ) ); 
		collision( "script_model", (9890, 8592, 1045), "collision_wall_128x128x10_standard", ( 0, 90, 0 ) ); 

		//floor 
	    collision( "script_model", (10280, 8516, 950), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
	    collision( "script_model", (10280, 8641, 949), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
	    collision( "script_model", (10280, 8776, 948), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
	    collision( "script_model", (10280, 8911, 947), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
		collision( "script_model", (10045, 8516, 950), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
		collision( "script_model", (10045, 8641, 949), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
		collision( "script_model", (10045, 8776, 948), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
		collision( "script_model", (10045, 8911, 947), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
		collision( "script_model", (9810, 8516, 950), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
		collision( "script_model", (9810, 8641, 949), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
		collision( "script_model", (9810, 8776, 948), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
		collision( "script_model", (9810, 8911, 947), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 0 ) ); 
		collision( "script_model", (10130, 8780, 955), "collision_wall_512x512x10_standard", ( 0, 0, 90 ) ); 
		collision( "script_model", (9630, 8780, 955), "collision_wall_512x512x10_standard", ( 0, 0, 90 ) ); 

		//roof 
	    collision( "script_model", (10280, 9047, 1100), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
	    collision( "script_model", (10280, 8911, 1101), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
	    collision( "script_model", (10280, 8776, 1102), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
	    collision( "script_model", (10280, 8641, 1103), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
		collision( "script_model", (10045, 9047, 1100), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
		collision( "script_model", (10045, 8911, 1101), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
		collision( "script_model", (10045, 8776, 1102), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
		collision( "script_model", (10045, 8641, 1103), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
		collision( "script_model", (9810, 9047, 1100), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
		collision( "script_model", (9810, 8641, 1103), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
		collision( "script_model", (9810, 8776, 1102), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
		collision( "script_model", (9810, 8911, 1101), "p6_zm_bank_vault_floor_hatch", ( 0, 0, 180 ) ); 
		
		perk_system( "script_model", (9885, 8592, 965), "zombie_vending_tombstone_on", ( 0, 90, 0 ), "random", "mus_perks_speed_sting", "Random Perk", 1500, "jugger_light" );
		perk_system( "script_model", ( 10250, 8552, 965 ), "p6_anim_zm_buildable_pap_on", ( 0, 180, 0 ), "pap", "zmb_perks_packa_upgrade", "Pack-A-Punch", 5000 );
        perk_system( "script_model", (9840, 8705, 965), "zombie_vending_revive_on", ( 0, 90, 0 ), "revive" );
	    perk_system( "script_model", (9840, 8765, 965), "zombie_vending_jugg_on", ( 0, 90, 0 ), "original", "mus_perks_jugganog_sting", "Jugger-Nog", 2500, "jugger_light", "specialty_armorvest" );
	    perk_system( "script_model", (9840, 8825, 965), "zombie_vending_marathon_on", ( 0, 90, 0 ), "original", "mus_perks_stamin_sting", "Stamin-Up", 2000, "marathon_light", "specialty_longersprint" );
	    perk_system( "script_model", (9840, 8895, 965), "zombie_vending_sleight_on", ( 0, 90, 0 ), "original", "mus_perks_speed_sting", "Speed Cola", 3000, "sleight_light", "specialty_fastreload" );
	    perk_system( "script_model", (9830, 8970, 965), "zombie_vending_doubletap2_on", ( 0, 90, 0 ), "original", "mus_perks_doubletap_sting", "Double Tap Root Beer", 2000, "doubletap_light", "specialty_rof" );
        perk_system( "script_model", ( 9915, 9030, 965 ), "zombie_vending_tombstone_on", ( 0, 0, 0 ), "custom", "mus_perks_deadshot_sting", "Widow's Wine", 4000, "tombstone_light", "WIDOWS_WINE" );
        perk_system( "script_model", ( 9985, 9030, 965 ), "zombie_vending_tombstone_on", ( 0, 0, 0 ), "custom", "mus_perks_packa_sting", "Electric Cherry", 2000, "tombstone_light", "ELECTRIC_CHERRY" );
        perk_system( "script_model", ( 10055, 9030, 965 ), "zombie_vending_tombstone_on", ( 0, 0, 0 ), "custom", "mus_perks_doubletap_sting", "Ethereal Razor", 4000, "tombstone_light", "Ethereal_Razor" );
        perk_system( "script_model", ( 10125, 9030, 965 ), "zombie_vending_tombstone_on", ( 0, 0, 0 ), "custom", "mus_perks_doubletap_sting", "Mule Kick", 4000, "tombstone_light", "MULE" );
		perk_system( "script_model", ( 10195, 9030, 965 ), "zombie_vending_tombstone_on", ( 0, 0, 0 ), "custom", "mus_perks_packa_sting", "PhD Flopper", 2000, "tombstone_light", "PHD_FLOPPER" );
		perk_system( "script_model", ( 10265, 9030, 965 ), "zombie_vending_tombstone_on", ( 0, 0, 0 ), "custom", "mus_perks_doubletap_sting", "Downer's Delight", 2500, "tombstone_light", "Downers_Delight" );
	    perk_system( "script_model", ( 10335, 9030, 965  ), "zombie_vending_tombstone_on", ( 0, 0, 0 ), "custom", "mus_perks_doubletap_sting", "Dying Wish", 5000, "tombstone_light", "Dying_Wish" );
        perk_system( "script_model", ( 10380, 8740, 965  ), "zombie_vending_tombstone_on", ( 0, -90, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 2500, "marathon_light", "Ammo_Regen" );
	    perk_system( "script_model", ( 10380, 8670, 965  ), "zombie_vending_tombstone_on", ( 0, -90, 0 ), "custom", "mus_perks_deadshot_sting", "Deadshot", 2000, "revive_light", "deadshot" );
        
}

collision( script, pos, model, angles, type )
{
	col = spawn( script, pos );
	col setmodel( model );
	col.angles = angles;
    if(type == "teleport")
    {
        col thread portal();
    }
}

//--------BOX-------------------------------------------------------------------------------------------------------------------------------------------------------------------

box_init() 
{
	setdvar( "magic_chest_movable", "0" );
    level.zombie_weapons[ "emp_grenade_zm" ].is_in_box = 0;
	if ( !isDefined( level.magic_box_zbarrier_state_func ) )
	{
		level.magic_box_zbarrier_state_func = ::process_magic_box_zbarrier_state;
	}
	if ( isDefined( level.using_locked_magicbox ) && level.using_locked_magicbox )
	{
		maps/mp/zombies/_zm_magicbox_lock::init();
	}
	level.chests = getstructarray( "treasure_chest_use", "targetname" );
	level.chests = [];
	start_chest = spawnstruct();
	start_chest.origin = (10370, 8850, 965);
	start_chest.angles = ( 0, 90, 0 );
	start_chest.script_noteworthy = "start_chest";
	start_chest.zombie_cost = 950;
	level.chests[ 0 ] = start_chest;
	treasure_chest_init( "start_chest" );
	if ( level.createfx_enabled )
	{
		return;
	}
	if ( !isDefined( level.magic_box_check_equipment ) )
	{
		level.magic_box_check_equipment = ::default_magic_box_check_equipment;
	}
	level thread magicbox_host_migration();
}

treasure_chest_init( start_chest_name )
{
	flag_init( "moving_chest_enabled" );
	flag_init( "moving_chest_now" );
	flag_init( "chest_has_been_used" );
	level.chest_moves = 0;
	level.chest_level = 0;
	if ( level.chests.size == 0 )
	{
		return;
	}
	for ( i = 0; i < level.chests.size; i++ )
	{
		level.chests[ i ].box_hacks = [];
		level.chests[ i ].orig_origin = level.chests[ i ].origin;
		level.chests[ i ] get_chest_pieces();
		if ( isDefined( level.chests[ i ].zombie_cost ) )
		{
			level.chests[ i ].old_cost = level.chests[ i ].zombie_cost;
		}
		else
		{
			level.chests[ i ].old_cost = 950;
		}
	}
	level.chest_accessed = 0;
	init_starting_chest_location( start_chest_name );
	array_thread( level.chests, ::treasure_chest_think );
}

get_chest_pieces()
{
	self.chest_box = getent( self.script_noteworthy + "_zbarrier", "script_noteworthy" );
	self.chest_box.origin = (10370, 8850, 965);
	self.chest_box.angles = ( 0, 90, 0 );
	collision = spawn( "script_model", self.chest_box.origin );
	collision.angles = self.chest_box.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	collision = spawn( "script_model", self.chest_box.origin - ( 0, 32, 0 ) );
	collision.angles = self.chest_box.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	collision = spawn( "script_model", self.chest_box.origin + ( 0, 32, 0 ) );
	collision.angles = self.chest_box.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	self.chest_rubble = [];
	rubble = getentarray( self.script_noteworthy + "_rubble", "script_noteworthy" );
	for ( i = 0; i < rubble.size; i++ )
	{
		if ( distancesquared( self.origin, rubble[ i ].origin ) < 10000 )
		{
			self.chest_rubble[ self.chest_rubble.size ] = rubble[ i ];
		}
	}
	self.zbarrier = getent( self.script_noteworthy + "_zbarrier", "script_noteworthy" );
	if ( isDefined( self.zbarrier ) )
	{
		self.zbarrier zbarrierpieceuseboxriselogic( 3 );
		self.zbarrier zbarrierpieceuseboxriselogic( 4 );
	}
	self.unitrigger_stub = spawnstruct();
	self.unitrigger_stub.origin = self.origin + anglesToRight( self.angles * -22.5 );
	self.unitrigger_stub.angles = self.angles;
	self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	self.unitrigger_stub.script_width = 104;
	self.unitrigger_stub.script_height = 50;
	self.unitrigger_stub.script_length = 60;
	self.unitrigger_stub.trigger_target = self;
	unitrigger_force_per_player_triggers( self.unitrigger_stub, 1 );
	self.unitrigger_stub.prompt_and_visibility_func = ::boxtrigger_update_prompt;
	self.zbarrier.owner = self;
}

//--------BOX-------------------------------------------------------------------------------------------------------------------------------------------------------------------

//---------------------PERKS-----------------------------------------------------------------------------------------------------------------------------------------------

default_vending_precaching()
{
	level._effect[ "sleight_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "tombstone_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "revive_light" ] = loadfx( "misc/fx_zombie_cola_revive_on" );
	level._effect[ "marathon_light" ] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
	level._effect[ "jugger_light" ] = loadfx( "misc/fx_zombie_cola_jugg_on" );
	level._effect[ "doubletap_light" ] = loadfx( "misc/fx_zombie_cola_dtap_on" ); 
	level._effect[ "Pack_a_Punch" ] = loadfx( "maps/zombie/fx_zombie_packapunch" ); 
}

perk_system( script, pos, model, angles, type, sound, name, cost, fx, perk)
{
	col = spawn( script, pos);
	col setmodel( model );
	col.angles = angles;
	x = spawn( script, pos );
	x setmodel( "zm_collision_perks1" );
	x.angles = angles;
	if(type != "revive")
	{
    	col thread buy_system( perk, sound, name, cost, type );
	}
	if(type != "pap" && type != "revive" )
    {
        col thread play_fx( fx );
    }
	if(type == "revive" )
	{
		col thread perksquickr();
		col thread play_fx( "revive_light" );
	}
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
			    	player thread SpawnHint( self.origin, 45, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + name + " [Cost: " + cost + "]" );
                    
					if(type != "random" && type != "pap" && player usebuttonpressed() && !player hascustomperk(perk) && !player hasperk(perk) && player.score >= cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                    {
                        player.machine_is_in_use = 1;
                        player playsound( "zmb_cha_ching" );
                        player.score -= cost;
                        player playsound( sound );
                        if(type == "custom")
                        {
				    	    player thread drawshader_and_shadermove( perk, 1, 0 );
                        }
                        else
                        {
                            player thread DoGivePerk(perk);
                        }
						wait 4;
                    	player.machine_is_in_use = 0;
					}
                    if( type == "random" && !player.num_perks > 12 && player usebuttonpressed() && player can_buy_weapon() && ( player.score >= cost ) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						level.machine_is_in_use = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= cost;
						player playsound ( "mus_perks_doubletap_sting" ); 
						player thread give_random_perk();
						wait 4;
						player.machine_is_in_use = 0;
					}
					if(type == "random" && player.num_perks > 12 && player usebuttonpressed() && ( player.score >= cost ) )
					{
						player iprintln("you have all perks.");
						wait 3;
					}
					currgun = player getcurrentweapon();
					if(type == "pap" && player usebuttonpressed() && !is_weapon_upgraded(currgun) && can_upgrade_weapon(currgun) && player.score >= cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                    {
						player.machine_is_in_use = 1;
                        player playsound( "zmb_cha_ching" );
                        player.score -= cost;
                        player playsound( sound );
                        player takeweapon(currgun);
                        gun = player maps/mp/zombies/_zm_weapons::get_upgrade_weapon( currgun, 0 );
                        player giveweapon(player maps/mp/zombies/_zm_weapons::get_upgrade_weapon( currgun, 0 ), 0, player custom_get_pack_a_punch_weapon_options(gun));
                        player switchToWeapon(gun);
						playfx(loadfx( "maps/zombie/fx_zombie_packapunch"), ( 10250, 8552, 976  ), anglestoforward( ( 0, 270, 55  ) ) ); 
						wait 3;
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

perksquickr()
{
    level.solo_revives = 0;
    level.max_solo_revives = 3;
	while( 1 )
	{
        players = get_players();
		foreach( player in level.players )
		{
			if(!player.machine_is_in_use)
			{
				if( distance( self.origin, player.origin ) <= 70 ) 
				{
                    if(players.size > 1)
                    {
						player thread SpawnHint( self.origin, 45, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for Revive [Cost: 1500]" );
                    }
                    else
                    {
					    player thread SpawnHint( self.origin, 45, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for Revive [Cost: 500]" );
                    }
					if((players.size > 1) && player usebuttonpressed() && !(player hasperk( "specialty_quickrevive" )) && (player.score >= 1500) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
						player.machine_is_in_use = 1;
						self.lock = 1;
                        level.solo_revives = 0;
						player playsound( "zmb_cha_ching" );
						player.score -= 1500;
						player playsound ( "mus_perks_revive_sting" );
						player thread DoGivePerk("specialty_quickrevive");
						wait 1;
						weapona = self getcurrentweapon();
						self switchToWeapon(weapona);
						wait 3;
						self.lock = 0;
						player.machine_is_in_use = 0;
					}
                    if(!level.max_revives && (players.size <= 1) && player usebuttonpressed() && !(player hasperk( "specialty_quickrevive" )) && (player.score >= 500) && !(self.lock ) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
						player.machine_is_in_use = 1;
						self.lock = 1;
                        level.solo_revives++;
						player playsound( "zmb_cha_ching" );
						player.score -= 500;
						player playsound ( "mus_perks_revive_sting" );
						player thread DoGivePerk("specialty_quickrevive");
						wait 1;
						weapona = self getcurrentweapon();
						self switchToWeapon(weapona);
						wait 3;
						self.lock = 0;
						player.machine_is_in_use = 0;
					}
                    if(level.max_revives && (players.size <= 1) && player usebuttonpressed() && (player.score >= 500) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
                        player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "oh_shit" );
                        wait 3;
                    }
                    if(level.solo_revives >= level.max_solo_revives)
                    {
                        level.max_revives = 1;
                    }
					else 
                    {
                        if((players.size == 1) && player usebuttonpressed() && player.score < 500)
					    {
						    player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					    }
                        if((players.size > 1) && player usebuttonpressed() && player.score < 1500)
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

play_fx( fx )
{
	playfxontag( level._effect[ fx ], self, "tag_origin" );
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
            //self.perk1back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );  
            self.perk1front = self drawshader( "waypoint_revive", x, 350, 23, 23, ( 0, 1, 1 ), 100, 0 ); 
            self.perk1front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1front;
            //self.perk1back.name = perk;
			//self.perkarray[self.perkarray.size] = self.perk1back;
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
            //self.perk2back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk2front = self drawshader( "menu_mp_weapons_1911", x, 350, 22, 22, ( 0, 1, 0 ), 100, 0 );
            self.perk2front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk2front;
			//self.perk2back.name = perk;
            //self.perkarray[self.perkarray.size] = self.perk2back;
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
            //self.perk3back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk3front = self drawshader( "hud_icon_sticky_grenade", x, 350, 23, 23, (1, 0, 1 ), 100, 0 );
            self.perk3front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk3front;
			//self.perk3back.name = perk;
            //self.perkarray[self.perkarray.size] = self.perk3back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9PhD Flopper");
				wait 0.2;
				self iprintln("This Perk removes explosion and fall damage also player creates explosion when dive to prone.");
			}
		}
        if(perk == "ELECTRIC_CHERRY")
        {    
            //self.perk4back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 200 ), 100, 0 );
            self.perk4front = self drawshader( "zombies_rank_5", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk4front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk4front;
			//self.perk4back.name = perk;
            //self.perkarray[self.perkarray.size] = self.perk4back;
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
            //self.perk5back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk5front = self drawshader( "zombies_rank_3", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk5front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk5front;
			//self.perk5back.name = perk;
            //self.perkarray[self.perkarray.size] = self.perk5back;
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
            //self.perk6back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk6front = self drawshader( "zombies_rank_4", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
			self.perk6front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk6front;
			//self.perk6back.name = perk;
            //self.perkarray[self.perkarray.size] = self.perk6back;
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
            //self.perk7back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk7front = self drawshader( "menu_mp_lobby_icon_customgamemode", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk7front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk7front;
			//self.perk7back.name = perk;
            //self.perkarray[self.perkarray.size] = self.perk7back;
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
        if(perk == "Dying_Wish")
        {
            //self.perk8back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk8front = self drawshader( "zombies_rank_5", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk8front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk8front;
			//self.perk8back.name = perk;
            //self.perkarray[self.perkarray.size] = self.perk8back;
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
            //self.perk9back = self drawshader( "specialty_marathon_zombies", x, 350, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk9front = self drawshader( "killiconheadshot", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk9front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk9front;
			//self.perk9back.name = perk;
            //self.perkarray[self.perkarray.size] = self.perk9back;
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
		RadiusDamage(self.origin, 100, 200, 100, self);
		wait 0.1;
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
        self playsound( "zmb_turbine_explo" );
		self EnableInvulnerability();
		RadiusDamage(self.origin, 90, 220, 120, self);
		self DisableInvulnerability();
		wait 1;
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
						zombie doDamage(zombie.health + 666, (0, 0, 0));
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
            self.health += 10;
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

dying_wish_checker()
{
    level endon("end_game");
    self endon("disconnect");
    self endon( "stopcustomperk" );
    self.dying_wish_uses = 0;
    for(;;)
	{
        self.dying_wish_on_cooldown = 0;
        self.perk8back.alpha = 1;
        self.perk8front.alpha = 1;
        self waittill("dying_wish_charge");
        self.perk8back.alpha = 0.3;
        self.perk8front.alpha = 0.4;
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
    self useServerVisionSet(1);
    self setvisionsetforplayer( "zombie_death", 0 );
    self freezeControls(1);
    wait 1;
    self freezeControls(0);
    wait 8;
	self.health = 1;
    self disableInvulnerability();
    self.ignoreme = 0;
    self useServerVisionSet(0);
    self setvisionsetforplayer("remote_mortar_enhanced", 0);
}

ammoregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		if(!self GetCurrentWeapon() == "claymore_zm" ) 
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

give_random_perk()
{
    perks = array();
    if(!self hascustomperk("Downers_Delight"))
	{
        perks[perks.size] = "Downers_Delight";
    }
    if(!self hascustomperk("ELECTRIC_CHERRY"))
	{
        perks[perks.size] = "ELECTRIC_CHERRY";
    }
    if(!self hascustomperk("PHD_FLOPPER"))
	{
        perks[perks.size] = "PHD_FLOPPER";
    }
    if(!self hascustomperk("MULE"))
	{
        perks[perks.size] = "MULE";
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
    if(!perks.size > 0)
	{
        self playSoundToPlayer( level.zmb_laugh_alias, self );
        return 0;
    }
    n = array_randomize(perks);
    perk = n[0];
    if(perk == "specialty_armorvest" || perk == "specialty_rof" || perk == "specialty_fastreload" || perk == "specialty_longersprint" )
	{
        self DoGivePerk(perk);
    } 
    else 
    {
        self drawshader_and_shadermove(perk, 1, 1);
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

SpawnHint( origin, width, height, cursorhint, string )
{
    hint = spawn( "trigger_radius", origin, 1, width, height );
    hint setcursorhint( cursorhint, hint );
    hint sethintstring( string );
    hint setvisibletoall();
    wait 0.2;
    hint delete();
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

playerdamagelastcheck( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
    if(self hascustomperk("WIDOWS_WINE"))
	{
          if(isDefined( eAttacker.is_zombie ) && eattacker.is_zombie )
		  {
            grenades = self get_player_lethal_grenade();
            grenade_count = self getweaponammoclip(grenades);
            if(grenade_count > 0)
			{
                self setweaponammoclip(grenades, (grenade_count - 1));
                foreach(zombie in getAiArray(level.zombie_team))
				{
                    if(distance(zombie.origin, self.origin) < 150)
					{
                        zombie thread ww_points( self );
                        self PlaySound("zmb_elec_jib_zombie");
                    }
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

ww_points( player )
{
    for(i = 0; i < 3; i++)
    {
		self maps/mp/zombies/_zm_utility::set_zombie_run_cycle("walk");
        player maps/mp/zombies/_zm_score::add_to_player_score( 10 );
        PlayFXOnTag(level.effect_WebFX,self,"j_spineupper");
        self doDamage(250, (0, 0, 0));
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
	zombies = getAiArray(level.zombie_team);
	foreach(zombie in zombies)
	{
        if( distance( zombie.origin, self.origin ) < 250 )
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

custom_get_pack_a_punch_weapon_options( weapon )
{
	if( !(IsDefined( self.pack_a_punch_weapon_options )) )
	{
		self.pack_a_punch_weapon_options = [];
	}
	if( !(is_weapon_upgraded( weapon )) )
	{
		return self calcweaponoptions( 0, 0, 0, 0, 0 );
	}
	if( IsDefined( self.pack_a_punch_weapon_options[ weapon] ) )
	{
		return self.pack_a_punch_weapon_options[ weapon];
	}
	smiley_face_reticle_index = 1;
	base = get_base_name( weapon );
	if( base == "m16_zm" || weapon == "m16_upgraded_zm" || base == "qcw05_upgraded_zm" || weapon == "qcw05_zm" || base == "fivesevendw_upgraded_zm" || weapon == "fivesevendw_zm" || base == "fiveseven_upgraded_zm" || weapon == "fiveseven_zm" || base == "m32_upgraded_zm" || weapon == "m32_zm" || base == "ray_gun_upgraded_zm" || weapon == "ray_gun_zm" || base == "raygun_mark2_upgraded_zm" || weapon == "raygun_mark2_zm" || base == "m1911_upgraded_zm" || weapon == "m1911_zm" || base == "knife_ballistic_upgraded_zm" || weapon == "knife_ballistic_zm")
	{
		camo_index = 39;
	}
	else
	{
		camo_index = 44;
	}
	lens_index = randomintrange( 0, 6 );
	reticle_index = randomintrange( 0, 16 );
	reticle_color_index = randomintrange( 0, 6 );
	plain_reticle_index = 16;
	r = randomint( 10 );
	use_plain = r < 3;
	if( base == "saritch_upgraded_zm" )
	{
		reticle_index = smiley_face_reticle_index;
	}
	else
	{
		if( use_plain )
		{
			reticle_index = plain_reticle_index;
		}
	}
	scary_eyes_reticle_index = 8;
	purple_reticle_color_index = 3;
	if( reticle_index == scary_eyes_reticle_index )
	{
		reticle_color_index = purple_reticle_color_index;
	}
	letter_a_reticle_index = 2;
	pink_reticle_color_index = 6;
	if( reticle_index == letter_a_reticle_index )
	{
		reticle_color_index = pink_reticle_color_index;
	}
	letter_e_reticle_index = 7;
	green_reticle_color_index = 1;
	if( reticle_index == letter_e_reticle_index )
	{
		reticle_color_index = green_reticle_color_index;
	}
	self.pack_a_punch_weapon_options[weapon] = self calcweaponoptions( camo_index, lens_index, reticle_index, reticle_color_index );
	return self.pack_a_punch_weapon_options[ weapon];

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

//------------------------TELE-----------------------------------------------------------------------------------------------------------------------------------

bus_tele()
{
    flag_wait( "initial_blackscreen_passed" );
    wait 5;
    tele = spawn("trigger_radius", level.the_bus.origin, 0, 35, 40);
    tele enablelinkto();
    tele linkto( level.the_bus );
	tele.targetname = "teleport_to_safe_area_trigger";
	tele SetCursorHint("HINT_NOICON");
	tele SetHintString("Press ^3&&1^7 to teleport safe area for 60 seconds [Cost: 5000]");
	for(;;)
	{
		tele waittill("trigger", player);
		if(player UseButtonPressed() && player.score >= 5000)
		{
            player.score -= 5000;
            player enableinvulnerability();
            player thread teleport_effect();
            player tele();
            wait 2;
            player spawnpoint();
            player thread timer();
            player disableinvulnerability();
        }
        wait .1;
    }
}

teleport_effect()
{
	self.teleport_effect = drawshader( "black", 0, -400, 2000, 2000, ( 0, 0, 0 ), 2, 999 );
	self.teleport_effect.alpha = 2;
	self.teleport_effect fadeovertime( 3 );
    wait 2.5;
	self.teleport_effect.alpha = 0;
	self.teleport_effect destroy();
}

tele()
{
	player = level.players;
	if( player[ 0] == self )
	{
		player[ 0] setorigin( (-6814, 5176, -55));
	}
	if( player[ 1] == self )
	{
		player[ 1] setorigin( (-6814, 5206, -57));
	}
	if( player[ 2] == self )
	{
		player[ 2] setorigin((-6814, 5256, -57));
	}
	if( player[ 3] == self )
	{
		player[ 3] setorigin((-6804, 5146, -57));
	}
    if( player[ 4] == self )
	{
		player[ 4] setorigin((-6816, 5136, -55));
    }
	if( player[ 5] == self )
	{
		player[ 5] setorigin((-6674, 5206, -57));
	}
	if( player[ 6] == self )
	{
		player[ 6] setorigin((-6800, 5246, -57));
	}
	if( player[ 7] == self )
	{
		player[ 7] setorigin((-6824, 5126, -57));
	}
}

spawn_infinite_powerup_drop( v_origin, str_type )
{
	level._powerup_timeout_override = ::infinite;
	if ( isDefined( str_type ) )
	{
		intro_powerup = maps/mp/zombies/_zm_powerups::specific_powerup_drop( str_type, v_origin );
	}
	else
	{
		intro_powerup = maps/mp/zombies/_zm_powerups::powerup_drop( v_origin );
	}
	level._powerup_timeout_override = undefined;
    wait 60;
    intro_powerup delete();
    thread spawn_infinite_powerup_drop( (10350, 8580, 965), level.power_up[ randomintrange( 0, 4 )] );
}

infinite()
{
}
