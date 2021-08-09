//forest plutonium

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
#include codescripts/character;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zm_transit_buildables;
#include maps/mp/zm_transit;
init()
{
	if( getdvar( "mapname" ) == "zm_transit" && getdvar ( "g_gametype")  == "zclassic" )
	{
		include_zombie_powerup("death_machine");
		add_zombie_powerup("death_machine", "zombie_teddybear", &"ZOMBIE_POWERUP_DEATH_MACHINE", ::func_should_always_drop, 1, 0, 0);
		powerup_set_can_pick_up_in_last_stand("death_machine", 1);

		include_zombie_powerup("unlimited_ammo");
		add_zombie_powerup("unlimited_ammo", "T6_WPN_AR_GALIL_WORLD", &"ZOMBIE_POWERUP_UNLIMITED_AMMO", ::func_should_always_drop, 0, 0, 0);
		powerup_set_can_pick_up_in_last_stand("unlimited_ammo", 1);

		include_zombie_powerup("zombie_cash");
		add_zombie_powerup("zombie_cash", "zombie_z_money_icon", &"ZOMBIE_POWERUP_ZOMBIE_CASH", ::func_should_always_drop, 1, 0, 0); 
		powerup_set_can_pick_up_in_last_stand("zombie_cash", 1);

		include_zombie_powerup("random_perk");
   	    add_zombie_powerup("random_perk", "t6_wpn_zmb_perk_bottle_sleight_world", &"ZOMBIE_POWERUP_RANDOM_PERK", ::func_should_always_drop, 0, 0, 0); 
	    powerup_set_can_pick_up_in_last_stand("random_perk", 0);

		precachemodel( "p_cub_door01_wood_fullsize" );
		precachemodel( "p_rus_door_white_window_plain_left" );
		precachemodel( "zombie_vending_tombstone_on" );
		precacheshader( "zombies_rank_1" );
		precacheshader( "zombies_rank_3" );
		precacheshader( "zombies_rank_2" );
		precacheshader( "zombies_rank_4" );
		precacheshader( "menu_mp_weapons_xm8" );
		precacheshader( "killiconheadshot" );
		precacheshader( "zombies_rank_5" );
		precacheshader( "hud_icon_sticky_grenade" );
		precacheshader( "menu_mp_weapons_1911" );
		precacheshader( "hud_icon_colt" );
	    precacheshader( "waypoint_revive" );
	    precacheshader( "hud_grenadeicon" ); 
	    precacheshader( "damage_feedback" ); 
	    precacheshader( "faction_cdc" );
	    precacheshader( "menu_mp_lobby_icon_customgamemode" );
		precachemodel( "zm_collision_perks1" );
		precachemodel( "p6_anim_zm_buildable_pap_on" );
		precachemodel( "collision_player_wall_512x512x10" );
		precachemodel( "collision_physics_512x512x10" );
		precachemodel( "collision_player_wall_256x256x10" );
		precachemodel( "t5_foliage_tree_burnt03" );
		precachemodel( "collision_geo_256x256x10_standard" );
		precachemodel( "zombie_teddybear" );
		precachemodel( "veh_t6_civ_bus_zombie" );
		precachemodel( "zombie_z_money_icon" );
		precachemodel( "veh_t6_civ_movingtrk_cab_dead" );
        precachemodel("p6_zm_buildable_sq_meteor");

        box_init();
		init_custom_map();
		level setdvars();
		level.get_player_weapon_limit = ::custom_get_player_weapon_limit;
		level.zombie_last_stand = ::LastStand;
		level.custom_vending_precaching = ::default_vending_precaching;
		register_player_damage_callback( ::playerdamagelastcheck );
		register_zombie_death_event_callback( ::Custom_death_callback );

		if(isDefined(level._zombiemode_powerup_grab))
		{
			level.original_zombiemode_powerup_grab = level._zombiemode_powerup_grab;
		}
		level._zombiemode_powerup_grab = ::custom_powerup_grab;

		level.effect_WebFX = loadfx("misc/fx_zombie_powerup_solo_grab");
		level.player_out_of_playable_area_monitor = 0;
		level.perk_purchase_limit = 20;
		level thread move_spawn_locations();
		level thread stopbus(); 
		level thread drawZombiesCounter();
		level thread onPlayerConnect();
		level thread custom_round_monitor();
		level thread teleport_zombies();
        //level thread night_mode(); ENABLE NIGHT MODE || Dying Wish Red Effect not working while enabled
		level.pers_upgrades_keys = [];
	    level.pers_upgrades = [];

	}
	else
	{
        level waittill( "connected", player );
    	player waittill("spawned_player");
        flag_wait( "initial_blackscreen_passed" );
        player iprintln( "^1Error! Please play in Green Run - Tranzit Normal Mode." );
		setdvar( "ui_errorMessage", "^9Please use Green Run - Tranzit Normal Mode");
	    setdvar( "ui_errorTitle", "^1Error" );
	}
}

move_spawn_locations()
{
	flag_wait( "initial_blackscreen_passed" );
	level.zombie_spawn_locations[2].origin = (3848, 5520, -63);
	level.zombie_spawn_locations[14].origin = (4667, 6280, -72);
	level.zombie_spawn_locations[15].origin = (3708, 6098, -63);
	level.zombie_spawn_locations[16].origin = (4766, 5421, -86);
	level.zombie_spawn_locations[17].origin = (3848, 5520, -63);
	level.zombie_spawn_locations[18].origin = (4766, 5421, -86);
	level.zombie_spawn_locations[19].origin = (3848, 5520, -63);
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
	setdvar( "ui_errorTitle", "^1Forest" );
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
	self waittill( "spawned_player" );
	self.perkarray = [];
	self.dying_wish_on_cooldown = 0;
    self.perk_reminder = 0;
    self.perk_count = 0;
    self.num_perks = 0;
	self.boss_is_alive = 0;
	self.is_boss_round = 0;
	self thread removeperkshader();
	self thread damagehitmarker();
	level thread OnGameEndedHint(self);
	self thread perkboughtcheck();
	self SpawnPoint();
	self takeweapon( "m1911_zm" );
	self giveweapon( "kard_zm" );
	self switchtoweapon( "kard_zm" );
	flag_wait( "start_zombie_round_logic" );
	wait 3;
	self iprintln( "forest - Survival" );
	self thread boss_round_monitor();
	for(;;)
	{
		self waittill( "spawned_player" );
		self SpawnPoint();
		self takeweapon( "m1911_zm" );
		self giveweapon( "kard_zm" );
		self switchtoweapon( "kard_zm" );
		if(self.score < 2500)
		{
			self.score = 2500;
		}
	}
}

stopbus()
{
	flag_wait( "initial_blackscreen_passed" );
	level endon("end_game");
	while( 1 )
	{
		bus = getent( "the_bus", "targetname" );
		if( IsDefined( level.the_bus.ismoving ) && IsDefined( bus ) )
		{
			bus.disabled_by_emp = 1;
			bus notify( "power_off" );
			bus.pre_disabled_by_emp = 1;
			bus notify( "pre_power_off" );
			bus.ismoving = 0;
			bus.isstopping = 0;
			bus.exceed_chase_speed = 0;
			bus notify( "stopping" );
			bus.targetspeed = 0;
		}
		wait 2;
	}

}

drawZombiesCounter()
{
	flag_wait( "initial_blackscreen_passed" );
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
		player[ 0] setorigin( ( 5250.08, 6876.83, -20.6077 ) );
	}
	if( player[ 1] == self )
	{
		player[ 1] setorigin( ( 5220.08, 6836.83, -20.6077 ) );
	}
	if( player[ 2] == self )
	{
		player[ 2] setorigin( ( 5210.08, 6856.83, -20.6077 ) );
	}
	if( player[ 3] == self )
	{
		player[ 3] setorigin( ( 5270.08, 6896.83, -20.6077 ) );
	}

}

init_custom_map()
{	
	noncollision( "script_model", ( 5116.05, 7088.78, -24.875 ), "p_cub_door01_wood_fullsize", ( 0, 0, 0 ), "wood_door" ); 
	noncollision( "script_model", ( 5456.65, 6313.14, -65.3518 ), "collision_player_wall_512x512x10", ( 0, 110, 0 ), "collisionwall1" );
	noncollision( "script_model", ( 5333.69, 4503.56, -70.0705 ), "collision_player_wall_512x512x10", ( 0, 90, 0 ), "collisionwall2" );
	noncollision( "script_model", ( 3735.79, 4160.7, -122.9 ), "collision_player_wall_512x512x10", ( 0, -45, 0 ), "collisionwall3" );
	noncollision( "script_model", ( 5400.65, 6513.14, -65.3518 ), "t5_foliage_tree_burnt03", ( -80, 110, 0 ), "tree" );
	noncollision( "script_model", ( 5415.69, 4395.56, -70.0705 ), "veh_t6_civ_bus_zombie", ( 0, 90, 0 ), "bus" );
	noncollision( "script_model", ( 3715.79, 4130.7, -122.9 ), "t5_foliage_tree_burnt03", ( -80, -45, 0 ), "tree2" );
	noncollision( "script_model", ( 3800.79, 4040.7, -122.9 ), "veh_t6_civ_microbus_dead", ( 0, -45, 0 ), "minibus" );
	perk_system( "script_model", ( 5086.28, 7071, -24.875 ), "zombie_vending_revive_on", ( 0, 0, 0 ), "revive" );
	perk_system( "script_model", ( 4244.28, 6091, -63.875 ), "zombie_vending_jugg_on", ( 0, 45, 0 ), "original", "mus_perks_jugganog_sting", "Jugger-Nog", 2500, "jugger_light", "specialty_armorvest" );
	perk_system( "script_model", ( 3837, 4090, -122.52 ), "zombie_vending_marathon_on", ( 0, 135, 0 ), "original", "mus_perks_stamin_sting", "Stamin-Up", 2000, "marathon_light", "specialty_longersprint" );
	perk_system( "script_model", ( 4909, 5272, -75.5062 ), "zombie_vending_sleight_on", ( 0, -80, 0 ), "original", "mus_perks_speed_sting", "Speed Cola", 3000, "sleight_light", "specialty_fastreload" );
	perk_system( "script_model", ( 3252.1, 5349.29, -63.8062 ), "zombie_vending_doubletap2_on", ( 0, 90, 0 ), "original", "mus_perks_doubletap_sting", "Double Tap Root Beer", 2000, "doubletap_light", "specialty_rof" );
	perk_system( "script_model", ( 5340.8, 7060, -25.2195 ), "p6_anim_zm_buildable_pap_on", ( 0, 0, 0 ), "pap", "zmb_perks_packa_upgrade", "Pack-A-Punch", 5000 );
	perk_system( "script_model", ( 5022.8, 6592.9, -17.0379 ), "zombie_vending_tombstone_on", ( 0, 90, 0 ), "random", "mus_perks_speed_sting", "Random Perk", 1500, "sleight_light" );
	wallweapons( "riotshield_zm", ( 5220.69, 7060, 30.875 ), ( 0, 225, 0 ), 1000 ); 
	wallweapons( "cymbal_monkey_zm", ( 5390.69, 6946, 21.351 ), ( 0, 135, 0 ), 4000 );
	soul_box( "zombie_perk_bottle_tombstone" );
	door();
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
				    player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + name + " [Cost: " + cost + "]" );
                    if( type == "original" && player usebuttonpressed() && !player hasperk(perk) && player.score >= cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                    {
                        player.machine_is_in_use = 1;
                        player playsound( "zmb_cha_ching" );
                        player.score -= cost;
                        player playsound( sound );
                        player thread DoGivePerk(perk);
						wait 3;
                    	player.machine_is_in_use = 0;
					}
					if( type == "random" && !player.num_perks > 13 && player usebuttonpressed() && ( player.score >= cost ) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						level.machine_is_in_use = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= cost;
						player playsound ( "mus_perks_doubletap_sting" ); 
						player drink();
						player thread give_random_perk();
						wait 1;
						player.machine_is_in_use = 0;
					}
					if(type == "random" && player.num_perks > 13 && player usebuttonpressed() && ( player.score >= cost ) )
					{
						player iprintln("you have all perks.");
						wait 3;
					}
					currgun = player getcurrentweapon();
                    if(type == "pap" && player usebuttonpressed() && !is_weapon_upgraded( currgun ) && can_upgrade_weapon(currgun) && player.score >= cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                    {
						player.machine_is_in_use = 1;
                        player playsound( "zmb_cha_ching" );
                        player.score -= cost;
                        player playsound( sound );
                        player takeweapon(currgun);
                        gun = player maps/mp/zombies/_zm_weapons::get_upgrade_weapon( currgun, 0 );
                        player giveweapon(player maps/mp/zombies/_zm_weapons::get_upgrade_weapon( currgun, 0 ), 0, player custom_get_pack_a_punch_weapon_options(gun));
                        player switchToWeapon(gun);
						playfx(loadfx( "maps/zombie/fx_zombie_packapunch"), ( 12865.8, -661, -175.5195 ), anglestoforward( ( 0, 180, 55  ) ) ); 
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
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
                    if(players.size > 1)
                    {
						player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for Revive [Cost: 1500]" );
                    }
                    else
                    {
					    player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for Revive [Cost: 500]" );
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

noncollision( script, pos, model, angles, type )
{
	noncol = spawn( "script_model", pos );
	noncol setmodel( model );
	noncol.angles = angles;
}

door()
{
	level.doorcost = 1000;
	door_model = spawn( "script_model", ( 5240.03, 6658.05, -24.875 ) );
	door_model setmodel( "p_rus_door_white_window_plain_left" );
	door_model.angles = (0, 0, 0);
    door_col = spawn( "script_model", ( 5239.03, 6658.05, -24.875 ) );
    door_col setmodel( "collision_player_wall_512x512x10" );
    door_col.angles = (0, 0, 0);
    door_model thread open_door( door_model, door_col );
}

open_door( model, door_col )
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(level.in_use) && !level.openeddoor )
			{
				if( distance(self.origin, player.origin ) <= 65 ) 
				{
					player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 to Open Door [Cost: 1000]." );
					if( player usebuttonpressed()  && !level.openeddoor && player.score >= 1000)
					{
						level.in_use = 1;
						level.openeddoor = 1;
                        player playsound( "zmb_cha_ching" );
						player.score -= 1000;
						playfx( level._effect[ "poltergeist"], ( 5180.03, 6618.05, 10 ), anglesToForward( 0, 90, 60 ) ); 
                        self rotateto( self.angles - ( 0, -90, 0 ), 1 );
					    door_col rotateto( door2.angles - ( 0, -90, 0 ), 1 );
						wait 0.5;
						self delete( model );
                        door_col delete();
						self playsound( "zmb_box_poof" );
						player playsound( "mus_zombie_splash_screen" );
						level.in_use = 0;
						break;
					}
					else
					{
						if(player usebuttonpressed() && player.score < 1000)
					    {
						    player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "door_deny", undefined, 0 );
					    }
                    }
				}
			}
		}
		wait 0.1;
	}

}

default_vending_precaching()
{
	level._effect[ "sleight_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "tombstone_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "revive_light" ] = loadfx( "misc/fx_zombie_cola_revive_on" );
	level._effect[ "marathon_light" ] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
	level._effect[ "jugger_light" ] = loadfx( "misc/fx_zombie_cola_jugg_on" );
	level._effect[ "doubletap_light" ] = loadfx( "misc/fx_zombie_cola_dtap_on" );
}

drink()
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

SpawnHint( origin, width, height, cursorhint, string )
{
    hint = spawn( "trigger_radius", origin, 1, width, height );
    hint setcursorhint( cursorhint, hint );
    hint sethintstring( string );
    hint setvisibletoall();
    wait 0.2;
    hint delete();
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

spawnentity( class, model, origin, angle )
{
	entity = spawn( class, origin );
	entity.angles = angle;
	entity setmodel( model );
	return entity;
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
	if(level.customround == level.round_number) 
	{
		if( isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie )
		{
			maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_ai_avogadro_electrified", self, 1, 1);
			self shellshock( "electrocution", 1 );
			self playsoundtoplayer( "zmb_avogadro_electrified", self );
			if(level.round_number > 6)
			{
				self dodamage( 10, self.origin);
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

custom_round_monitor()
{
	self endon("disconnect");
	self endon("game_ended");
	level.customround = level.round_number + randomintrange( 5, 8 );
	for(;;)
	{
		level waittill( "between_round_over" );
		if( level.round_number == level.customround ) 
		{
			foreach(player in level.players)
			{
				player thread power_up_hud(0, 0, "Fetch me their souls!");
				player playleaderdialogonplayer( "dogstart", self.team, 5 );
			}
			while(level.customround == level.round_number)
			{
				foreach( zombie in getAiArray(level.zombie_team) )
				{
					if(!isDefined(zombie.remodeled) && !zombie.is_avogadro)
					{
						zombie setModel( "c_zom_screecher_fb" );
						zombie detachAll();
						zombie maps/mp/zombies/_zm_utility::set_zombie_run_cycle( "super_sprint" ); 
                        zombie thread kill_crawler();
						zombie thread last_zombie();
					}
				}
				wait 0.05;
			}
			level.customround = level.round_number + randomintrange( 4, 6 );
            specific_powerup_drop("full_ammo", level.last_zombie_origin);
		}
	}
}

last_zombie()
{
	self waittill( "death" );
	if ( get_current_zombie_count() == 0 && level.zombie_total == 0 )
	{
		level.last_zombie_origin = self.origin;
	}
	clear_all_corpses();
}

kill_crawler()
{
	wait 5;
	while(isalive( self ))
	{
		if(!self.has_legs)
		{
			self doDamage(self.health + 666, (0, 0, 0));
		}
		wait 0.5;
	}
}

souls(box)
{
	source_pos = self gettagorigin( "j_spineupper" );
	target_pos = box;
	soul = spawn( "script_model", source_pos );
	soul setmodel( "tag_origin" );
	wait 0.1;
	fx = playfxontag( level._effect[ "avogadro_bolt" ], soul, "tag_origin" );
	soul moveto( target_pos, 0.2 );
	soul waittill( "movedone" );
	soul delete();
}

soul_box(model)
{
	level.soulbox_active = 1;
	level.soulbox1_active = 1;
	level.soulbox2_active = 1;
	level.souls_needed = 25;
	level.soulbox_souls = 0;
	level.soulbox1_souls = 0;
	level.soulbox2_souls = 0;
	level.soulbox = spawnentity( "script_model", getweaponmodel( model ), ( 5195.03, 6315.05, -19.875 ), ( 0, 0, 0 ));
	level.soulbox1 = spawnentity( "script_model", getweaponmodel( model ), ( 4690.65, 5533.551, -79.5 ), ( 0, 0, 0 ));
	level.soulbox2 = spawnentity( "script_model", getweaponmodel( model ), ( 3909, 5111.551, -55.875 ), ( 0, 0, 0 ));
}

Custom_death_callback( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex ) 
{
	if(level.soulbox_active)
	{

		if( distance( level.soulbox.origin, self.origin ) <= 350 )
		{
			self souls( level.soulbox.origin );
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

		if( distance( level.soulbox1.origin, self.origin ) <= 350 )
		{
			self souls( level.soulbox1.origin );
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
		if( distance( level.soulbox2.origin, self.origin ) <= 350 )
		{
			self souls( level.soulbox2.origin );
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
	return idamage;
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
	y = 350;
    x = -345 + (self.perk_count * 30);
    for(i = 0; i < self.perkarray.size; i++)
	{
    	self.perkarray[i].x = self.perkarray[i].x + 30;
	}
        if(perk == "Downers_Delight")
        {
            self.perk1back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );  
            self.perk1front = self drawshader( "waypoint_revive", x, y, 23, 23, ( 0, 1, 1 ), 100, 0 ); 
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
            self.perk2back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk2front = self drawshader( "menu_mp_weapons_1911", x, y, 22, 22, ( 0, 1, 0 ), 100, 0 );
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
            self.perk3back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk3front = self drawshader( "hud_icon_sticky_grenade", x, y, 23, 23, (1, 0, 1 ), 100, 0 );
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
        if(perk == "ELECTRIC_CHERRY")
        {    
            self.perk5back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 200 ), 100, 0 );
            self.perk5front = self drawshader( "zombies_rank_5", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
            self.perk6back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk6front = self drawshader( "zombies_rank_3", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
            self.perk7back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk7front = self drawshader( "zombies_rank_4", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
            self.perk8back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk8front = self drawshader( "menu_mp_lobby_icon_customgamemode", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
        if(perk == "Dying_Wish")
        {
            self.perk10back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk10front = self drawshader( "zombies_rank_5", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
            self.perk11back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk11front = self drawshader( "killiconheadshot", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
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
    if(!self hascustomperk("PHD_FLOPPER"))
	{
        perks[perks.size] = "PHD_FLOPPER";
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

custom_powerup_grab(s_powerup, e_player)
{
	if (s_powerup.powerup_name == "zombie_cash")
	{
        foreach( player in level.players )
        {
    		player thread power_up_hud(0, 0, "Zombie Cash!" );
            player.score += (100 * randomIntRange(-6, 21));
            if(player.score < 0)
			{
                player.score = 0;
            }
        }
    }
	if (s_powerup.powerup_name == "unlimited_ammo")
	{
		level thread unlimited_ammo_powerup();
	}
	if (s_powerup.powerup_name == "death_machine")
	{
		e_player notify("Death_Machine");
		e_player thread Death_Machine();
	}
	if (s_powerup.powerup_name == "random_perk")
	{
	    foreach(player in level.players)
	    {
			player thread power_up_hud(0, 0, "Free Perk!" );
		    player thread give_random_perk();
		    player.score += 500;
	    }
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
    wait 30;
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

unlimited_ammo_powerup( origin, angles )
{
	foreach(player in level.players)
	{
		player notify("end_unlimited_ammo");
		player playsound("zmb_cha_ching");
		player thread startammo();
		player thread power_up_hud("hud_icon_colt", 0, "Infinite Ammo!");
		player thread endammo();
	}
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
		self thread destroy_power_up_icon_hud(power_up_hud_icon);
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
		self thread destroy_power_up_icon_hud2(power_up_hud2_icon);
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

destroy_power_up_icon_hud(elem)
{
	level endon("game_ended");
	self waittill_any_timeout( "disconnect", "end_unlimited_ammo");
	elem destroy();
}

destroy_power_up_icon_hud2(elem2)
{
    level endon("game_ended");
	self waittill_any_timeout( "disconnect", "Death_Machine_Stop");
	elem2 destroy();
}

endammo()
{
	level endon("game_ended");
	self endon("disonnect");
	self endon("end_unlimited_ammo");
	wait 30;
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
		wait 0.05;
		weapon = self getcurrentweapon();
		if( weapon != "none" && weapon != "claymore_zm" )
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


//--------BOX-------------------------------------------------------------------------------------------------------------------------------------------------------------------

box_init() 
{
	setdvar( "magic_chest_movable", "0" );
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
	start_chest.origin = ( 5387, 6594, -24 );
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
	foreach( weapon in level.zombie_weapons) //all weapons in box
	{
		weapon.is_in_box = 1;
	}
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
	self.chest_box.origin = ( 5387, 6594, -24 );
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


boss_round_monitor()
{
	self endon("disconnect");
	self endon("game_ended");
	level.bossround = level.round_number +  randomintrange( 3, 5 );
	for(;;)
	{
		level waittill( "between_round_over" );
		flag_wait( "start_zombie_round_logic" );
		player = level.players;
        if(player[0] == self)
        {
		    if( level.round_number == level.bossround ) 
		    {
			    if( level.customround == level.round_number ) 
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
        		playfx(loadfx("explosions/fx_default_explosion"), level.inferno.origin, anglestoforward( ( 0, 45, 55 ) ) ); 
        		RadiusDamage(level.inferno.origin, 200, 3000, 2999, level.inferno);
                player = level.players;
				player[0] specific_powerup_drop("random_perk", level.inferno.origin );
				level waittill("end_of_round");
				level.bossround = level.round_number + 4;
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
	spawner = random( level.zombie_spawners );
	inferno = spawn_zombie( spawner );
	level.boss_is_alive = 1;
	level.zombie_health = level.zombie_vars["zombie_health_start"];  
	level.zombie_health = 20000;
	inferno.ignore_nuke = 1;
	inferno.ignore_enemyoverride = 1;
	inferno setmodel("c_zom_avagadro_fb");
	inferno detachAll();
	level.inferno = inferno;
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

wallweapons( weapon, origin, angles, cost )
{
	wallweaponx = spawnentity( "script_model", getweaponmodel( weapon ), origin, angles + ( 0, 50, 0 ) );
	wallweaponx thread wallweaponmonitorbox( weapon, cost );

}

wallweaponmonitorbox( weapon, cost )
{
    self endon( "game_ended" );
    weapx = get_weapon_display_name( weapon );
    while( 1 )
    {
        foreach( player in level.players )
        {
            if( distance( self.origin, player.origin ) <= 70 )
            {
				player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + weapx + " [Cost: " + cost + "]" );
                if( player usebuttonpressed() && !(player hasWeapon(weapon)) && player.score >= cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                {
                    player playsound( "zmb_cha_ching" );
                    player.score -= cost;
                    player thread weapon_give( weapon, 0, 1 );
                    player iprintln( "^2" + ( weapx + " Bought" ) );
                    wait 4;
                }
                else
                {
                    if( player usebuttonpressed() && player.score < cost )
                    {
                        player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "no_money_weapon" );
                    }
                }
            }
        }
        wait 0.1;
    }
}
