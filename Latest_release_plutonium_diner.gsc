//PLUTONIUM - Diner

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
   	    add_zombie_powerup("random_perk", "t6_wpn_zmb_perk_bottle_sleight_world", &"ZOMBIE_POWERUP_RANDOM_PERK", ::func_should_never_drop, 0, 0, 0); 
	    powerup_set_can_pick_up_in_last_stand("random_perk", 1);

		include_zombie_powerup("pap_weapon");
   	    add_zombie_powerup("pap_weapon", "t6_wpn_zmb_raygun2_world", &"ZOMBIE_POWERUP_PAP_WEAPON", ::func_should_always_drop, 1, 0, 0); 
	    powerup_set_can_pick_up_in_last_stand("pap_weapon", 1);

		include_zombie_powerup("zombie_blood");
   	    add_zombie_powerup("zombie_blood", "c_zom_zombie_head_a", &"ZOMBIE_POWERUP_ZOMBIE_BLOOD", ::func_should_always_drop, 1, 0, 0); 
	    powerup_set_can_pick_up_in_last_stand("zombie_blood", 1);

		precachemodel( "c_zom_zombie_head_a" );
		precachemodel( "p_cub_door01_wood_fullsize" );
		precachemodel( "p_rus_door_white_window_plain_left" );
		precachemodel( "zombie_vending_jugg_on" );
		precachemodel( "zombie_vending_revive_on" );
		precachemodel( "zombie_vending_sleight_on" );
		precachemodel( "zombie_vending_tombstone_on" );
		precachemodel( "zombie_vending_three_gun_on" );
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
		precachemodel( "zombie_vending_marathon_on" );
		precachemodel( "zombie_vending_doubletap2_on" );
		precachemodel( "zombie_pickup_perk_bottle" );
		precachemodel( "zm_collision_perks1" );
		precachemodel( "p6_anim_zm_buildable_pap_on" );
		precachemodel( "collision_player_wall_512x512x10" );
		precachemodel( "collision_physics_512x512x10" );
		precachemodel( "collision_player_wall_256x256x10" );
		precacheshader( "damage_feedback" );
		precachemodel( "t5_foliage_tree_burnt03" );
		precachemodel( "collision_geo_256x256x10_standard" );
		precachemodel( "zombie_teddybear" );
		precachemodel( "veh_t6_civ_bus_zombie" );
		precachemodel( "veh_t6_civ_bus_zombie_roof_hatch" );
		precachemodel( "zombie_z_money_icon" );
		precachemodel( "veh_t6_civ_movingtrk_cab_dead" );
		precachemodel( "t6_wpn_zmb_raygun2_world" );
        level turnonpower();
		isTown();
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
		level._effect[ "wall_m16" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_m16" );
    	level._effect[ "wall_claymore" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_claymore" );
    	level._effect[ "wall_taseknuck" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_taseknuck" );
   		level._effect[ "wall_bowie" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_bowie" );
		level.player_out_of_playable_area_monitor = 0;
		level.perk_purchase_limit = 20;
		level.rooftop_open = 0;
		level thread entityremover();
		level thread stopbus(); 
		level thread drawZombiesCounter();
		level thread onPlayerConnect();
		level thread custom_round_monitor();
		level thread teleport_avogadro();
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

setdvars()
{
	setdvar( "magic_chest_movable", "0" );
	setDvar( "scr_screecher_ignore_player", 1 );
	setdvar( "ui_errorMessage", "^9Thank you for playing this Custom Survival Map");
	setdvar( "ui_errorTitle", "^1Diner" );
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
	self endon( "disconnect" );
	level endon( "game_ended" );
	self waittill( "spawned_player" );
	self.perkarray = [];
	self.last_death_perks = [];
	self.machine_is_in_use = 0;
	self.tombstone_save = 0;
	self.perk_reminder = 0;
	self.perk_count = 0;
	self.num_perks = 0;
	self thread removeperkshader();
	self thread damagehitmarker();
	level thread OnGameEndedHint(self);
	self thread displayScore();
	self thread perkboughtcheck();
	self thread enable_aim_assist();
	self init_wall_fx();
	self SpawnPoint();
	self takeweapon( "m1911_zm" );
	self giveweapon( "kard_zm" );
	self switchtoweapon( "kard_zm" );
	flag_wait( "start_zombie_round_logic" );
	wait 3;
	self iprintln( "Diner - Survival" );
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

init_wall_fx()
{
    self thread playchalkfx("wall_claymore", (-5150.28, -7808, -24.892 ), (0, 0, 0 ));
    self thread playchalkfx("wall_claymore", (-4762, -7782.5, -30.062), (0, -45, 0 ));
    self thread playchalkfx("wall_claymore", (-4755.28, -7860, -31.162), (0, -90, 0 ));
    self thread playchalkfx("wall_bowie", (-5439.01, -7781, -40.5062), (0, 270, 0 ));
}

playchalkfx(effect, origin, angles)
{
    fx = SpawnFX(level._effect[ effect ], origin,AnglesToForward(angles),AnglesToUp(angles));
    TriggerFX(fx);
    level waittill("connected", player);
    fx Delete();
}

displayScore()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    self.scoreText = CreateFontString("Objective", 1.5);
    self.scoretext setPoint("CENTER", "RIGHT", "CENTER", "RIGHT");
    self.scoreText.label = &"^2Score: ^7";
    self.scoretext.alpha = 0;
    while(true)
    {
        self.scoretext SetValue(self.score);
        if(getplayers().size >= 5 && self.scoretext.alpha == 0)
        {
            self.scoretext FadeOverTime( 1 );
            self.scoretext.alpha = 1;
        }
        else if(getplayers().size < 5 && self.scoretext.alpha >= 0)
        {
            self.scoretext FadeOverTime( 1 );
            self.scoretext.alpha = 0;
        }
        wait 0.1;
    }
}

ww_points( player )
{
    for(i = 0; i < 3; i++)
    {
		self maps/mp/zombies/_zm_utility::set_zombie_run_cycle("walk");
        player maps/mp/zombies/_zm_score::add_to_player_score( 10 );
        PlayFXOnTag(level.effect_WebFX,self,"j_spineupper");
		if(player is_insta_kill_active())
		{
			self doDamage(self.health + 666, (0, 0, 0));
		}
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
          if(isDefined( eAttacker.is_zombie ) && eattacker.is_zombie)
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
				if(self is_insta_kill_active())
				{
					radiusdamage( self.origin, 300, level.zombie_health, level.zombie_health, self, "MOD_GRENADE_SPLASH" );
				}
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
	return idamage;
}

//----------CUSTOM_ROUNDS-------------------------------------------------------------------------------------------------------------------------------------------------

custom_round_monitor()
{
	self endon("disconnect");
	self endon("game_ended");
	level.customround = randomintrange( 5, 8 );
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
						clear_all_corpses();
						zombie setModel( "c_zom_screecher_fb" );
						zombie detachAll();
						zombie maps/mp/zombies/_zm_utility::set_zombie_run_cycle( "super_sprint" ); 
						zombie thread kill_crawler();
						zombie thread last_zombie();
					}
					if(distance( zombie.origin, (-4400, -8000, -62.875)) < 120)
					{
						zombie forceteleport(( -3980, -6958, -66.44 ));
						zombie thread find_flesh();
					}
					if(distance( zombie.origin, (-5030, -8000, -62.875)) < 120)
					{
						zombie forceteleport(( -3980, -6958, -66.44 ));
						zombie thread find_flesh();
					}
					if(distance( zombie.origin, (-5569, -8000, 0.125) ) < 120)
					{
						zombie forceteleport(( -3980, -6958, -66.44 ));
						zombie thread find_flesh();
					}
					if(distance( zombie.origin, (-6430, -8000, 0.125) ) < 120)
					{
						zombie forceteleport(( -3980, -6958, -66.44 ));
						zombie thread find_flesh();
					}
				}
				wait 0.05;
			}
			specific_powerup_drop("full_ammo", level.last_zombie_origin);
			level.customround = level.round_number + randomintrange( 5, 7 );
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

//--END-----CUSTOM_ROUNDS-------------------------------------------------------------------------------------------------------------------------------------------------

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
		player[ 0] setorigin( ( -4963.28, -7402, -62.5062 ) );
	}
	if( player[ 1] == self )
	{
		player[ 1] setorigin( ( -4993.28, -7402, -62.5062 ) );
	}
	if( player[ 2] == self )
	{
		player[ 2] setorigin( ( -4933.28, -7402, -62.5062 ) );
	}
	if( player[ 3] == self )
	{
		player[ 3] setorigin( ( -4903.28, -7402, -62.5062 ) );
	}
	if( player[ 4] == self )
	{
		player[ 4] setorigin( ( -4973.28, -7402, -62.5062 ) );
	}
	if( player[ 5] == self )
	{
		player[ 5] setorigin( ( -5024.28, -7402, -62.5062 ) );
	}
	if( player[ 6] == self )
	{
		player[ 6] setorigin( ( -5044.28, -7402, -62.5062 ) );
	}
	if( player[ 7] == self )
	{
		player[ 7] setorigin( ( -4950.28, -7402, -62.5062 ) );
	}
}

turnonpower()
{
	level maps\mp\zombies\_zm_game_module::turn_power_on_and_open_doors();
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

entityremover()
{
    flag_wait( "start_zombie_round_logic" );
    wait 5;
    removebuildable( "dinerhatch" );
    removebuildable( "cattlecatcher" );
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
	level.teddysNeeded = 10;
	level.teddysCollected = 0;
	while( 1 )
	{
		self waittill( "damage", idamage, attacker, idflags, vpoint, type, victim, vdir, shitloc, psoffsettime, sweapon );
		if( self.health <= 0 )
		{
			level.teddysCollected++;
			iprintlnbold("Teddys Shot [" + level.teddysCollected + "/10]");
			self delete();
			if (level.teddysCollected >= level.teddysNeeded)
			{
				self thread maps/mp/zombies/_zm_audio_announcer::leaderdialog( "boxmove" );
				wait 2;
				iprintlnbold("^2Rooftop Opened");
                buildbuildable( "dinerhatch", 1 );
				level.rooftop_open = 1;

				perk_system( "script_model", ( -5825.36, -7894.4, 224.628 ), "zombie_vending_tombstone_on", ( 0, 90, 0 ), "custom", "mus_perks_packa_sting", "PhD Flopper", 2000, "tombstone_light", "PHD_FLOPPER", "Explosion and fall damage ignored also player creates explosion when dive to prone" );
				perk_system( "script_model", ( -6156.36, -7852.4, 224.628  ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_doubletap_sting", "Downer's Delight", 2500, "tombstone_light", "Downers_Delight", "Players bleedout time increased 10 seconds and current weapons used in laststand" );
				perk_system( "script_model", ( -6354.36, -7800.4, 227.628 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_doubletap_sting", "Victorious Tortoise", 2500, "tombstone_light", "Victorious_Tortoise", "Players shield block damage from all directions when in use" );
			}
			self notify( "shot" );

		}
		wait 0.1;
	}
}

init_custom_map()
{
	noncollision( "script_model", (-3890.1, -6650, -59.5062), "collision_player_wall_512x512x10", ( 0, 270, 0 ), "wall" ); 
	noncollision( "script_model", (-6315.28, -7000, -50.5062 ), "collision_player_wall_512x512x10", ( 0, 270, 0 ), "wall2" ); 
	noncollision( "script_model", ( -6415.28, -6850, 5.5062 ), "veh_t6_civ_movingtrk_cab_dead", ( 0, 280, 0 ), "truck" );
	noncollision( "script_model", (-3870.1, -7050, -50.5062), "t5_foliage_tree_burnt03", (-75, 270, 0), "tree" ); 
	noncollision( "script_model", (-3885.1, -6900, -50.5062), "collision_player_wall_512x512x10", (0, 270, 0), "wall3" ); 
	wallweapons( "emp_grenade_zm", ( -4758.28, -7782, -16.162 ), ( 0, 45, 0 ), 1000 );
	wallweapons( "cymbal_monkey_zm", ( -4760.28, -7860, -20.162 ), ( 0, 290, 0 ), 4000 );
	wallweapons( "claymore_zm", ( -5150.28, -7808, -20.162 ), ( 90, 45, 0 ), 1000 );
    wallweapons( "bowie_knife_zm", ( -5439.01, -7773, -40.002 ), ( 0, 225, 0 ), 3000 );
    shootable( ( -4690.28, -7282, -63.5062 ), (0, 180, 0) );
    shootable( ( -5305.28, -6550, -35.5062 ), (0, -35, 0) ); 
    shootable( ( -5371.28, -7379, 300 ), (0, 80, 0) );
    shootable( ( -4180.28, -7904, -12), (0, 180, 0) );
    shootable( ( -6248.28, -7748, 148 ), (0, 0, 0) );
    shootable( ( -5582.28, -5334, 79.125 ), (0, 20, 0) );
    shootable( ( -4268.28, -6250, -41.1398 ), (0, 90, 0) );
    shootable( ( -3732.28, -7473, -58.875 ), (0, 60, 0) );
    shootable( ( -6338.28, -7590, 221.915 ), (0, 60, 0) );
    shootable( ( -3810.28, -7443, 98.915 ), (0, 180, 0) );
	soul_box( "zombie_perk_bottle_tombstone" );
	perk_system( "script_model", ( -3810.1, -7220, -59.5062 ), "zombie_vending_tombstone_on", ( 0, 270, 0 ), "original", "mus_perks_tombstone_sting", "Tombstone", 2000, "tombstone_light", "specialty_scavenger" );
	perk_system( "script_model", ( -4590.28, -7539, -62.5062 ), "zombie_vending_jugg_on", ( 0, 270, 0 ), "original", "mus_perks_jugganog_sting", "Jugger-Nog", 2500, "jugger_light", "specialty_armorvest" );
	perk_system( "script_model", ( -4173.1, -7750.29, -62.5062 ), "zombie_vending_doubletap2_on", ( 0, 270, 0 ), "original", "mus_perks_doubletap_sting", "Double Tap Root Beer", 2000, "doubletap_light", "specialty_rof" );
	perk_system( "script_model", ( -6500.28, -7930, 0.5062 ), "zombie_vending_marathon_on", ( 0, 90, 0 ), "original", "mus_perks_stamin_sting", "Stamin-Up", 2000, "marathon_light", "specialty_longersprint" );
	perk_system( "script_model", ( -5440.1, -7884, -59.875 ), "zombie_vending_tombstone_on", ( 0, 90, 0 ), "custom", "mus_perks_deadshot_sting", "Widow's Wine", 4000, "tombstone_light", "WIDOWS_WINE", "Damages zombies around player when touched and grenades are upgraded" );
	perk_system( "script_model", ( -5151.1, -5410, -63.875 ), "zombie_vending_tombstone_on", ( 0, -45, 0 ), "custom", "mus_perks_packa_sting", "Electric Cherry", 2000, "tombstone_light", "ELECTRIC_CHERRY", "It creates an electric shockwave around the player whenever they reload" );
	perk_system( "script_model", ( -5912.1, -7355, -63.875 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_doubletap_sting", "Ethereal Razor", 4000, "tombstone_light", "Ethereal_Razor", "Players melee attacks does extra damage and restore a small amount of health" );
	perk_system( "script_model", ( -4204.1, -5885, -69.34 ), "zombie_vending_tombstone_on", ( 0, -35, 0 ), "custom", "mus_perks_doubletap_sting", "Mule Kick", 4000, "tombstone_light", "MULE", "Enables additional primary weapon slot for player " );
    perk_system( "script_model", (-3545.1, -7220, -59.5062 ), "p6_anim_zm_buildable_pap_on", ( 0,  315, 0 ), "pap", "zmb_perks_packa_upgrade", "Pack-A-Punch", 5000 );
	perk_system( "script_model", ( -5050.28, -7788, -62.5062 ), "zombie_vending_revive_on", ( 0, 180, 0 ), "revive" );
}

perk_system( script, pos, model, angles, type, sound, name, cost, fx, perk, hint)
{
	col = spawn( script, pos);
	col setmodel( model );
	col.angles = angles;
	x = spawn( script, pos );
	x setmodel( "zm_collision_perks1" );
	x.angles = angles;
	if(type != "revive")
	{
    	col thread buy_system( perk, sound, name, cost, type, hint );
	}
	if(type != "pap" && type != "revive" )
    {
        col thread play_fx( fx );
    }
	if(type == "revive")
	{
		col thread perksquickr();
		col thread play_fx( "revive_light" );

	}
}

drawshader(shader, align, relative, x, y, width, height, color, alpha, sort)
{
    element = newclienthudelem(self);
    element.elemtype = "bar";
    element.hidewheninmenu = true;
    element.shader = shader;
    element.width = width;
    element.height = height;
    element.align = align;
    element.relative = relative;
    element.xoffset = 0;
    element.yoffset = 0;
    element.children = [];
    element.sort = sort;
    element.color = color;
    element.alpha = alpha;
    element setparent(level.uiparent);
    element setshader(shader, width, height);
    element setpoint(align, relative, x, y);
    element.hidden = true;
	wait 0.20;
	element destroy();
}

lower_hint(hint)
{
	spawn = self createfontstring("default" , 1.3);
    spawn setPoint("CENTER", "TOP", 0, 284);
	spawn.hidewheninmenu = 1;
	spawn settext(hint);
	wait 0.20;
	spawn destroy();
}

background(name)
{
	if(name == "Mule Kick" || name == "Victorious Tortoise")	
	{
		width = 280;
	}
	else
	{
		width = 390;
	}
	self thread drawshader("black", "CENTER", "TOP", 0, 275, width, 40, (0,0,0), 0.3, 1);
}

buy_system( perk, sound, name, cost, type, hint )
{
    self endon( "game_ended" );
    while( 1 )
    {
        foreach( player in level.players )
        {
            if(!player.machine_is_in_use)
			{
                if( distance( self.origin, player.origin ) <= 60 )
                {
				    player thread SpawnHint( self.origin, 60, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + name + " [Cost: " + cost + "]" );
					if(type == "custom")
					{
						player thread lower_hint( hint );
						player thread background( name );
					}
					if( type != "pap" && player usebuttonpressed() && !player hasperk(perk) && !player hascustomperk(perk) && player.score >= cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                    {
                        player.machine_is_in_use = 1;
                        player playsound( "zmb_cha_ching" );
                        player.score -= cost;
                        player playsound( sound );
                        if(type == "custom")
                        {
				    	    player thread drawshader_and_shadermove( perk, 1, 0 );
                        }
                        if(type == "original")
                        {
                            player thread DoGivePerk(perk);
                        }
						wait 3;
                    	player.machine_is_in_use = 0;
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
					    playfx(loadfx( "maps/zombie/fx_zombie_packapunch"), ( -3545.1, -7220, -48.5062 ), anglestoforward( ( 0, 45, 55  ) ) ); 
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

default_vending_precaching()
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

play_fx( fx )
{
	playfxontag( level._effect[ fx ], self, "tag_origin" );
}

removebuildable( buildable )
{
    foreach ( stub in level.buildable_stubs )
    {
        if ( stub.equipname == buildable )
        {
            foreach ( piece in stub.buildablezone.pieces )
            {
                piece maps/mp/zombies/_zm_buildables::piece_unspawn();
            }
            return;
        }
    }
}

buildbuildable( buildable, craft )
{
	if ( !isDefined( craft ) )
	{
		craft = 0;
	}
	player = get_players()[ 0 ];
	foreach ( stub in level.buildable_stubs )
	{
		if ( !isDefined( buildable ) || stub.equipname == buildable )
		{
			if ( isDefined( buildable ) || stub.persistent != 3 )
			{
				if (craft)
				{
					stub maps/mp/zombies/_zm_buildables::buildablestub_finish_build( player );
					stub maps/mp/zombies/_zm_buildables::buildablestub_remove();
					stub.model notsolid();
					stub.model show();
				}
				i = 0;
				foreach ( piece in stub.buildablezone.pieces )
				{
					piece maps/mp/zombies/_zm_buildables::piece_unspawn();
					if ( !craft && i > 0 )
					{
						stub.buildablezone maps/mp/zombies/_zm_buildables::buildable_set_piece_built( piece );
					}
					i++;
				}
				return;
			}
		}
	}
}

noncollision( script, pos, model, angles, type )
{
	noncol = spawn( "script_model", pos );
	noncol setmodel( model );
	noncol.angles = angles;
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
					if((players.size > 1) && player usebuttonpressed() && !(player hasperk( "specialty_quickrevive" )) && (player.score >= 1500) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
						player.machine_is_in_use = 1;
                        level.solo_revives = 0;
						player playsound( "zmb_cha_ching" );
						player.score -= 1500;
						player playsound ( "mus_perks_revive_sting" );
						player thread DoGivePerk("specialty_quickrevive");
						wait 1;
						weapona = self getcurrentweapon();
						self switchToWeapon(weapona);
						wait 3;
						player.machine_is_in_use = 0;
					}
                    if(level.solo_revives < level.max_solo_revives && (players.size <= 1) && player usebuttonpressed() && !(player hasperk( "specialty_quickrevive" )) && player.score >= 500 && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
						player.machine_is_in_use = 1;
                        level.solo_revives++;
						player playsound( "zmb_cha_ching" );
						player.score -= 500;
						player playsound ( "mus_perks_revive_sting" );
						player thread DoGivePerk("specialty_quickrevive");
						wait 1;
						weapona = self getcurrentweapon();
						self switchToWeapon(weapona);
						wait 3;
						player.machine_is_in_use = 0;
					}
                    if(level.solo_revives >= level.max_solo_revives && (players.size <= 1) && player usebuttonpressed() && (player.score >= 500) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
                        player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "oh_shit" );
                        wait 3;
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

SpawnHint( origin, width, height, cursorhint, string )
{
    hint = spawn( "trigger_radius", origin, 1, width, height );
    hint setcursorhint( cursorhint, hint );
    hint sethintstring( string );
    hint setvisibletoall();
    wait 0.2;
    hint delete();
}

removeperkshader()
{
    for(;;)
    {
        self waittill_any_return( "fake_death", "player_downed", "player_revived", "spawned_player", "disconnect", "death" );
		if(isDefined(self.tombstone_save) && self.tombstone_save)
		{
			self.tomb = self.origin;
			for(i = 0; i < self.perkarray.size; i++)
			{
				self.last_death_perks[self.last_death_perks.size] = self.perkarray[i].name;
			}
		}
        self.num_perks = 0;
        self.perk_reminder = 0;
        self.perk_count = 0;
		self.tombstone_save = 0;
		self removeallcustomshader();
		self.perkarray = [];
        self notify( "stopcustomperk" );
        self.bleedout_time = 30;
        perk_array = maps/mp/zombies/_zm_perks::get_perk_array( 1 );
        for ( i = 0; i < perk_array.size; i++ )
        {
            perk = perk_array[ i ];
            self unsetperk( perk );
            self set_perk_clientfield( perk, 0 );
        }
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
        if(self hasPerk("specialty_scavenger"))
		{
			self.tombstone_save = 1;
            self thread custom_tombstone();
        }
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
	switch(perk)
	{
		case "Downers_Delight":
			self.perk1front = self drawshader( "waypoint_revive", x, 350, 23, 23, (  0, 1, 1 ), 100, 0 );
			self.perk1front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1front;
			self.num_perks++;
			self thread DDown();
			if(print)
			{
				self iprintln("^9Downer's Delight");
				wait 0.2;
				self iprintln("This Perk will increase players bleedout time by 10 seconds and current weapons is used in laststand.");
			}
			break;
		case "MULE":
			self.perk2front = self drawshader( "menu_mp_weapons_1911", x, 350, 22, 22, ( 0, 1, 0  ), 100, 0 );
			self.perk2front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk2front;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Mule Kick");
				wait 0.2;
				self iprintln("This Perk enables additional primary weapon slot for player. ");
			}
			break;
		case "PHD_FLOPPER":
			self.perk3front = self drawshader( "hud_icon_sticky_grenade", x, 350, 23, 23, (1, 0, 1 ), 100, 0 );
			self.perk3front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk3front;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9PhD Flopper");
				wait 0.2;
				self iprintln("This Perk removes explosion and fall damage also player creates explosion when dive to prone.");
			}
			break;
		case "Victorious_Tortoise":
			self.perk4front = self drawshader( "zombies_rank_2", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
			self.perk4front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk4front;
			self.num_perks++;
			self thread start_vt();
			if(print)
			{
				self iprintln("^9Victorious Tortoise");
				wait 0.2;
				self iprintln("This Perk allows shield block damage from all directions when in use.");
			}
			break;
		case "ELECTRIC_CHERRY":
			self.perk5front = self drawshader( "zombies_rank_5", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
			self.perk5front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk5front;
			self.num_perks++;
			self thread start_ec(); 
			if(print)
			{
				self iprintln("^9Electric Cherry");
				wait 0.2;
				self iprintln("This Perk creates an electric shockwave around the player whenever they reload.");
			}
			break;
		case "WIDOWS_WINE":
			self.perk6front = self drawshader( "zombies_rank_3", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
			self.perk6front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk6front;
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
			break;
		case "Ethereal_Razor":
			self.perk7front = self drawshader( "zombies_rank_4", x, 350, 23, 23, ( 1, 1, 1 ), 100, 0 );
			self.perk7front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk7front;
			self.num_perks++;
			self thread start_er();
			if(print)
			{
				self iprintln("^9Ethereal Razor");
				wait 0.2;
				self iprintln("This Perk deals extra damage when player using melee attacks and restores a small amount of health.");
			}
			break;
		default:
			break;
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

solo_tombstone_removal()
{
	notify( "tombstone_on" );
}

turn_tombstone_on()
{
	while ( 1 )
	{
		machine = getentarray( "vending_tombstone", "targetname" );
		machine_triggers = getentarray( "vending_tombstone", "target" );
		i = 0;
		while ( i < machine.size )
		{
			machine[ i ] setmodel( level.machine_assets[ "tombstone" ].off_model );
			i++;
		}
		level thread do_initial_power_off_callback( machine, "tombstone" );
		array_thread( machine_triggers, ::set_power_on, 0 );
		level waittill( "tombstone_on" );
		i = 0;
		while ( i < machine.size )
		{
			machine[ i ] setmodel( level.machine_assets[ "tombstone" ].on_model );
			machine[ i ] playsound( "zmb_perks_power_on" );
			machine[ i ] thread perk_fx( "tombstone_light" );
			machine[ i ] thread play_loop_on_machine();
			i++;
		}
		level notify( "specialty_scavenger_power_on" );
		array_thread( machine_triggers, ::set_power_on, 1 );
		if ( isDefined( level.machine_assets[ "tombstone" ].power_on_callback ) )
		{
			array_thread( machine, level.machine_assets[ "tombstone" ].power_on_callback );
		}
		level waittill( "tombstone_off" );
		if ( isDefined( level.machine_assets[ "tombstone" ].power_off_callback ) )
		{
			array_thread( machine, level.machine_assets[ "tombstone" ].power_off_callback );
		}
		array_thread( machine, ::turn_perk_off );
		players = get_players();
		_a1718 = players;
		_k1718 = getFirstArrayKey( _a1718 );
		while ( isDefined( _k1718 ) )
		{
			player = _a1718[ _k1718 ];
			player.hasperkspecialtytombstone = undefined;
			_k1718 = getNextArrayKey( _a1718, _k1718 );
		}
	}
}

perk_machine_spawn_init()
{
	match_string = "";
	location = level.scr_zm_map_start_location;
	if ( location != "default" && location == "" && isDefined( level.default_start_location ) )
	{
		location = level.default_start_location;
	}
	match_string = ( level.scr_zm_ui_gametype + "_perks_" ) + location;
	pos = [];
	if ( isDefined( level.override_perk_targetname ) )
	{
		structs = getstructarray( level.override_perk_targetname, "targetname" );
	}
	else
	{
		structs = getstructarray( "zm_perk_machine", "targetname" );
	}
	_a3578 = structs;
	_k3578 = getFirstArrayKey( _a3578 );
	while ( isDefined( _k3578 ) )
	{
		struct = _a3578[ _k3578 ];
		if ( isDefined( struct.script_string ) )
		{
			tokens = strtok( struct.script_string, " " );
			_a3583 = tokens;
			_k3583 = getFirstArrayKey( _a3583 );
			while ( isDefined( _k3583 ) )
			{
				token = _a3583[ _k3583 ];
				if ( token == match_string )
				{
					pos[ pos.size ] = struct;
				}
				_k3583 = getNextArrayKey( _a3583, _k3583 );
			}
		}
		else pos[ pos.size ] = struct;
		_k3578 = getNextArrayKey( _a3578, _k3578 );
	}
	if ( !isDefined( pos ) || pos.size == 0 )
	{
		return;
	}
	precachemodel( "zm_collision_perks1" );
	i = 0;
	while ( i < pos.size )
	{
		perk = pos[ i ].script_noteworthy;
		if ( isDefined( perk ) && isDefined( pos[ i ].model ) )
		{
			use_trigger = spawn( "trigger_radius_use", pos[ i ].origin + vectorScale( ( 0, -1, 0 ), 30 ), 0, 40, 70 );
			use_trigger.targetname = "zombie_vending";
			use_trigger.script_noteworthy = perk;
			use_trigger triggerignoreteam();
			perk_machine = spawn( "script_model", pos[ i ].origin );
			perk_machine.angles = pos[ i ].angles;
			perk_machine setmodel( pos[ i ].model );
			if ( isDefined( level._no_vending_machine_bump_trigs ) && level._no_vending_machine_bump_trigs )
			{
				bump_trigger = undefined;
			}
			else
			{
				bump_trigger = spawn( "trigger_radius", pos[ i ].origin, 0, 35, 64 );
				bump_trigger.script_activated = 1;
				bump_trigger.script_sound = "zmb_perks_bump_bottle";
				bump_trigger.targetname = "audio_bump_trigger";
				if ( perk != "specialty_weapupgrade" )
				{
					bump_trigger thread thread_bump_trigger();
				}
			}
			collision = spawn( "script_model", pos[ i ].origin, 1 );
			collision.angles = pos[ i ].angles;
			collision setmodel( "zm_collision_perks1" );
			collision.script_noteworthy = "clip";
			collision disconnectpaths();
			use_trigger.clip = collision;
			use_trigger.machine = perk_machine;
			use_trigger.bump = bump_trigger;
			if ( isDefined( pos[ i ].blocker_model ) )
			{
				use_trigger.blocker_model = pos[ i ].blocker_model;
			}
			if ( isDefined( pos[ i ].script_int ) )
			{
				perk_machine.script_int = pos[ i ].script_int;
			}
			if ( isDefined( pos[ i ].turn_on_notify ) )
			{
				perk_machine.turn_on_notify = pos[ i ].turn_on_notify;
			}
			if ( perk == "specialty_scavenger" || perk == "specialty_scavenger_upgrade" )
			{
				use_trigger.script_sound = "mus_perks_tombstone_jingle";
				use_trigger.script_string = "tombstone_perk";
				use_trigger.script_label = "mus_perks_tombstone_sting";
				use_trigger.target = "vending_tombstone";
				perk_machine.script_string = "tombstone_perk";
				perk_machine.targetname = "vending_tombstone";
				if ( isDefined( bump_trigger ) )
				{
					bump_trigger.script_string = "tombstone_perk";
				}
			}
			if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].perk_machine_set_kvps ) )
			{
				[[ level._custom_perks[ perk ].perk_machine_set_kvps ]]( use_trigger, perk_machine, bump_trigger, collision );
			}
		}
		i++;
	}
}

isTown()
{
	if (isDefined(level.zombiemode_using_tombstone_perk) && level.zombiemode_using_tombstone_perk)
	{
		level thread perk_machine_spawn_init();
		thread solo_tombstone_removal();
		thread turn_tombstone_on();
	}
}

custom_tombstone()
{
    self endon("player_revived");
    self endon("disconnect");
    self waittill( "spawned_player" );
    for(i = 1200; i > 0; i--)
	{
        if(distance(self.origin, self.tomb) < 40)
		{
            self tombstone_perkcheck_and_give();
            return 0;
        }
        wait 0.05;
    }
}

tombstone_perkcheck_and_give()
{
	wait 1;
	for(i = 0; i < self.last_death_perks.size; i++)
	{
		for(i = 0; i < self.perkarray.size; i++)
		{
			if(self.perkarray[i].name != self.last_death_perks[i])
			{
				self.last_death_perks[self.last_death_perks.size] = self.perkarray[i].name;
			}
		}
	}
	self removeallcustomshader();
	self notify( "stopcustomperk" );
	self.num_perks = 0;
	if(self hasPerk("specialty_armorvest"))
	{
		self.num_perks++;
	}
	if(self hasPerk("specialty_fastreload"))
	{
		self.num_perks++;
	}
	if(self hasPerk("specialty_rof"))
	{
		self.num_perks++;
	}
	if(self hasPerk("specialty_quickrevive"))
	{
		self.num_perks++;
	}
	if(self hasPerk("specialty_longersprint"))
	{
		self.num_perks++;
	}
	if(self hasPerk("specialty_scavenger"))
	{
		self.num_perks++;
	}
	self.perk_reminder = self.num_perks;
    self.perk_count = self.num_perks;
    for(i = 0; i < self.last_death_perks.size; i++)
	{
        self drawshader_and_shadermove(self.last_death_perks[i], 0, 0);
    }
	self.last_death_perks = [];
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
		if(self is_insta_kill_active())
		{
			Radiusdamage( self.origin, 300, 999999999, 999999999, self, "MOD_GRENADE_SPLASH" );
		} 
		RadiusDamage(self.origin, 100, 200, 100, self);
		wait 0.1;
	}
}

start_vt()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
	{
		if (self getcurrentweapon() == "riotshield_zm" )
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
		if(self is_insta_kill_active())
		{
			radiusdamage( self.origin, 300, 999999999, 999999999, self, "MOD_GRENADE_SPLASH" );
		}
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
                    zombie dodamage(400, (0, 0, 0));
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
	if(base == "m16_zm" || weapon == "m16_upgraded_zm" || base == "qcw05_upgraded_zm" || weapon == "qcw05_zm" || base == "fivesevendw_upgraded_zm" || weapon == "fivesevendw_zm" || base == "fiveseven_upgraded_zm" || weapon == "fiveseven_zm" || base == "m32_upgraded_zm" || weapon == "m32_zm" || base == "ray_gun_upgraded_zm" || weapon == "ray_gun_zm" || base == "raygun_mark2_upgraded_zm" || weapon == "raygun_mark2_zm" || base == "m1911_upgraded_zm" || weapon == "m1911_zm" || base == "knife_ballistic_upgraded_zm" || weapon == "knife_ballistic_zm")
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

wallweapons( weapon, origin, angles, cost )
{
	wallweaponx = spawnentity( "script_model", getweaponmodel( weapon ), origin, angles + ( 0, 50, 0 ) );
	wallweaponx thread wallweaponmonitorbox( weapon, cost );
	if(weapon == "emp_grenade_zm")
	{
		decoy = spawnentity( "script_model", getweaponmodel( weapon ), ( -4758.28, -7777.5, -18.062 ), ( 0, 15, 90 ) + ( 0, 50, 0 ) );
	}
}

spawnentity( class, model, origin, angle )
{
	entity = spawn( class, origin );
	entity.angles = angle;
	entity setmodel( model );
	return entity;
}

wallweaponmonitorbox( weapon, cost )
{
    self endon( "game_ended" );
    name = get_weapon_display_name( weapon );
    while( 1 )
    {
        foreach( player in level.players )
        {
            if( distance( self.origin, player.origin ) <= 70 )
            {
				player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + name + " [Cost: " + cost + "]" );
                if( player usebuttonpressed() && !(player hasWeapon(weapon)) && player.score >= cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                {
                    player playsound( "zmb_cha_ching" );
                    player.score -= cost;
                    player thread weapon_give( weapon, 0, 1 );
                    player iprintln( "^2" + ( name + " Bought" ) );
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

custom_powerup_grab(s_powerup, e_player)
{
	if (s_powerup.powerup_name == "zombie_cash")
	{
        foreach( player in level.players )
        {
    		player thread power_up_hud( 0, 0, "Zombie Cash!" );
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
			player thread power_up_hud( 0, 0, "Free Perk!" );
		    player thread give_random_perk();
		    player.score += 500;
	    }
	}
	if (s_powerup.powerup_name == "pap_weapon")
	{
		currgun = e_player getcurrentweapon();
        if(!is_weapon_upgraded(currgun) && can_upgrade_weapon( currgun ))
		{
            e_player takeweapon(currgun);
            gun = e_player maps/mp/zombies/_zm_weapons::get_upgrade_weapon( currgun, 0 );
            e_player giveweapon(e_player maps/mp/zombies/_zm_weapons::get_upgrade_weapon( currgun, 0 ), 0, e_player custom_get_pack_a_punch_weapon_options(gun));
            e_player switchToWeapon(gun);
		}
		else
		{
			e_player.score += 1000;
		}
	}
	if (s_powerup.powerup_name == "zombie_blood")
	{
		e_player notify("Zombie_Blood");
		e_player thread Blood();
	}
	else if (isDefined(level.original_zombiemode_powerup_grab))
		level thread [[level.original_zombiemode_powerup_grab]](s_powerup, e_player);
}

Blood()
{	
	self endon("Zombie_Blood");
	self thread power_up_hud( 0, 0, "Zombie Blood!" );
    self.ignoreme = 1;
    self useServerVisionSet(true);
    self setvisionsetforplayer( "zombie_death", 0 );
	wait 30;
    self.ignoreme = 0;
    self useServerVisionSet(false);
    self setvisionsetforplayer("remote_mortar_enhanced", 0);
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
	self waittill_any_timeout( 30, "disconnect", "end_unlimited_ammo");
	elem destroy();
}

destroy_power_up_icon_hud2(elem2)
{
	level endon("game_ended");
	self waittill_any_timeout( 30, "disconnect", "Death_Machine_Stop");
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

enable_aim_assist()
{
	self endon("disconnected");
	level endon("game_ended");
	flag_wait( "start_zombie_round_logic" );
	wait 15;
	self iprintln("^7press ^1[{+smoke}] ^7and ^1[{+frag}] ^7to Enable/Disable controller aim assist ");
	for(;;)
	{
		if(!self.aim_assist_on && self secondaryoffhandbuttonpressed() && self FragButtonPressed())
		{
			self.aim_assist_on = 1;
			self setclientfieldtoplayer( "deadshot_perk", 1 );
			x = 240;
        	self.aim_assist_back_icon = self drawshader( "specialty_marathon_zombies", x, 400, 25, 25, (0, 0, 0), 100, 0 );
			self.aim_assist_front_icon = self drawshader( "killiconheadshot", x, 400, 24, 24, (1, 1, 1), 100, 0 );
			self iprintln("Controller aim assist: ^2Enabled");
			wait 3;
		}
		if(self.aim_assist_on && self secondaryoffhandbuttonpressed() && self FragButtonPressed())
		{
			self setclientfieldtoplayer( "deadshot_perk", 0 );
			self.aim_assist_back_icon destroy();
			self.aim_assist_back_icon = undefined;
    		self.aim_assist_front_icon destroy();
			self.aim_assist_front_icon = undefined;
			self iprintln("Controller aim assist: ^1Disabled");
			self.aim_assist_on = 0;
			wait 3;
		}
	wait 0.1;
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

teleport_avogadro()
{
	self endon("disconnect");
	wait 10;
	for(;;)
	{	
		foreach(zombie in getAiArray(level.zombie_team))
		{
			if( isDefined( zombie.is_avogadro ) && zombie.is_avogadro )
			{
				zombie forceteleport(( 1588.01, 62.551, -61.875 ));
			}
		}
		wait 0.3;
	}
}

give_random_perk()
{
    perks = array();
    if(level.rooftop_open)
	{
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
	level.souls_needed = 40;
	level.soulbox_souls = 0;
	level.soulbox1_souls = 0;
	level.soulbox2_souls = 0;
	level.soulbox = spawnentity( "script_model", getweaponmodel( model ), ( -4286.28, -7096, -55.42 ), ( 0, 0, 0 ));
	level.soulbox1 = spawnentity( "script_model", getweaponmodel( model ), ( -5851.65, -6890.551, -49.875 ), ( 0, 0, 0 ));
	level.soulbox2 = spawnentity( "script_model", getweaponmodel( model ), ( -5342.65, -5726.551, -58.64 ), ( 0, 0, 0 ));
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

custom_tombstone()
{
    self endon("player_revived");
    self endon("disconnect");
    self waittill( "spawned_player" );
    for(i = 1200; i > 0; i--)
	{
        if(distance(self.origin, self.tomb) < 40)
		{
            self tombstone_perkcheck_and_give();
            return 0;
        }
        wait 0.05;
    }
}

tombstone_perkcheck_and_give()
{
	wait 1;
	for(i = 0; i < self.perkarray.size; i++)
	{
		self.perkarray[i] destroy();
	}
	self notify( "stopcustomperk" );
	self.num_perks = 0;
	if(self hasPerk("specialty_armorvest"))
	{
		self.num_perks++;
	}
	if(self hasPerk("specialty_fastreload"))
	{
		self.num_perks++;
	}
	if(self hasPerk("specialty_rof"))
	{
		self.num_perks++;
	}
	if(self hasPerk("specialty_quickrevive"))
	{
		self.num_perks++;
	}
	if(self hasPerk("specialty_longersprint"))
	{
		self.num_perks++;
	}
	if(self hasPerk("specialty_scavenger"))
	{
		self.num_perks++;
	}
	self.perk_reminder = self.num_perks;
    self.perk_count = self.num_perks;
    for(i = 0; i < self.last_death_perks.size; i++)
	{
        self drawshader_and_shadermove(self.last_death_perks[i], 0, 0);
    }
	self.last_death_perks = [];
}

