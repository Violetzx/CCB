--==========================================================================================================================
-- UNITS
--==========================================================================================================================
-- Edit text, and remove District Combat Bonus
----------------------------------------------------------------------------------------------------------------------------
	-- Units
	-------------------------------------
		UPDATE Units
			SET Description = 	'LOC_UNIT_GAUL_GAESATAE_REWORK_DESCRIPTION'
			WHERE UnitType = 'UNIT_GAUL_GAESATAE';
	-------------------------------------
	-- UnitAbilities
	-------------------------------------
		UPDATE UnitAbilities
			SET Description = 	'LOC_ABILITY_GAESATAE_REWORK_DESCRIPTION'
			WHERE UnitAbilityType = 'ABILITY_GAESATAE';
	-------------------------------------
	-- UnitAbilityModifiers
	-------------------------------------
		DELETE FROM UnitAbilityModifiers
			WHERE UnitAbilityType = 'ABILITY_GAESATAE'
			AND ModifierId = 'GAESATAE_STRONG_AGAINST_DISTRICTS';
----------------------------------------------------------------------------------------------------------------------------
-- Add Healing on Death ability
----------------------------------------------------------------------------------------------------------------------------
	-- Types
	-----------------------------------------------------------------------------------
		INSERT INTO Types
				(Type,										Kind)
		VALUES	('ABILITY_SUK_GAUL_GAESATAE_HEALING',		'KIND_ABILITY');
	-------------------------------------
	-- UnitAbilities
	-------------------------------------
		INSERT INTO UnitAbilities
			(
				UnitAbilityType,
				Name,
				Description
			)
		VALUES
			(
				'ABILITY_SUK_GAUL_GAESATAE_HEALING',
				'LOC_ABILITY_SUK_GAUL_GAESATAE_HEALING_NAME',
				'LOC_ABILITY_SUK_GAUL_GAESATAE_HEALING_DESCRIPTION'
			);
	-----------------------------------------------------------------------------------
	-- TypeTags
	-----------------------------------------------------------------------------------
		INSERT OR REPLACE INTO TypeTags
				(Type,									Tag)
		VALUES	('ABILITY_SUK_GAUL_GAESATAE_HEALING',	'CLASS_GAESATAE');
--==========================================================================================================================
--==========================================================================================================================