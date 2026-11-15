Effect = {
	{--дымогенератор
		Type = "smokeTrail",
		Texture = "smoke6_nm.dds",
		Tech = "Main",
		LODdistance0 = 10000, -- m
		LODdistance1 = 50000,

		ScaleBase = 2, -- meters

		Lighting = 1,
		
		DetailFactorMax = 5.0, -- max particles in segment = 2^(1+detailFactor). 5 - maximum

		Flame = false,
		Nozzle	= false,
		NozzleDir = -1,
		NozzleSpeedMin = 0,
		NozzleSpeedMax = 0,

		FadeInRange = 0, -- 0 - not used, or fadeInOpacity = saturate( (curHeight - startHeight) / FadeInRange )
		FadeOutHeight = 99999, --  0 - not used

		DissipationFactor = 20.0,

		Length = 7000, -- m
		SegmentLength = 60,	-- m
		FadeIn = 0,	-- m
	}
}

Presets = {}
Presets.contrail = deepcopy(Effect)
Presets.contrail[1].Spectrum = "visible"
Presets.contrail[1].LODdistance0 = 35000 -- m
Presets.contrail[1].LODdistance1 = 360000
Presets.contrail[1].ScaleBase = 1.35
Presets.contrail[1].Lighting = 0.24
Presets.contrail[1].Opacity = 0.48
Presets.contrail[1].DetailFactorMax = 4.5
Presets.contrail[1].Nozzle	= true
Presets.contrail[1].NozzleSpeedMin = 200
Presets.contrail[1].NozzleSpeedMax = 400
Presets.contrail[1].FadeInRange = 700
Presets.contrail[1].FadeOutHeight = 14500
Presets.contrail[1].DissipationFactor = 10.5
Presets.contrail[1].Length = 16500	-- m
Presets.contrail[1].SegmentLength = 80 -- m
Presets.contrail[1].FadeIn = 140 -- m
Presets.contrail[1].ColorFadingFactor = 0.25
Presets.contrail[1].LifeScaleFactor = 1.12
Presets.contrail[1].LifeScalePow = 0.95

Presets.blacktail = deepcopy(Effect)
Presets.blacktail[1].LODdistance0 = 5000	-- m
Presets.blacktail[1].LODdistance1 = 50000
Presets.blacktail[1].ScaleBase = 2.4
Presets.blacktail[1].Length = 1000	-- m
Presets.blacktail[1].ColorFadingFactor = 0.5

Presets.chair = deepcopy(Effect)
Presets.chair[1].Flame = true
Presets.chair[1].Nozzle = true
Presets.chair[1].NozzleSpeedMin = 300
Presets.chair[1].NozzleSpeedMax = 300
Presets.chair[1].Lighting = 0.5
Presets.chair[1].ScaleBase = 3
Presets.chair[1].DissipationFactor = 7.0
Presets.chair[1].LODdistance0 = 5000	-- m
Presets.chair[1].LODdistance1 = 50000
Presets.chair[1].Length = 100 -- m
Presets.chair[1].SegmentLength = 10	-- m
Presets.chair[1].FadeIn = 1.0 -- m

Presets.A2Amissile10000 = deepcopy(Effect)
Presets.A2Amissile10000[1].Tech = "Missile"
Presets.A2Amissile10000[1].Nozzle = true
Presets.A2Amissile10000[1].Flame = true
Presets.A2Amissile10000[1].NozzleSpeedMin = 300
Presets.A2Amissile10000[1].NozzleSpeedMax = 300
Presets.A2Amissile10000[1].Lighting = 0.6
Presets.A2Amissile10000[1].DetailFactorMax = 4.0
Presets.A2Amissile10000[1].ScaleBase = 3.7
Presets.A2Amissile10000[1].DissipationFactor = 20.0
Presets.A2Amissile10000[1].LODdistance0 = 14000 -- m
Presets.A2Amissile10000[1].LODdistance1 = 60000
Presets.A2Amissile10000[1].Length = 15500	-- m
Presets.A2Amissile10000[1].SegmentLength = 44	-- m
Presets.A2Amissile10000[1].FadeIn = 0.2 -- m
Presets.A2Amissile10000[1].ColorFadingFactor = 0.0
Presets.A2Amissile10000[1].MissileColor = {0.78, 0.76, 0.70}
Presets.A2Amissile10000[1].MissileAlpha = 0.16
Presets.A2Amissile10000[1].LifeScaleFactor = 1.80
Presets.A2Amissile10000[1].LifeScalePow = 0.68

Presets.A2Amissile5000 = deepcopy(Effect)
Presets.A2Amissile5000[1].Tech = "Missile"
Presets.A2Amissile5000[1].Nozzle = true
Presets.A2Amissile5000[1].Flame = true
Presets.A2Amissile5000[1].NozzleSpeedMin = 300
Presets.A2Amissile5000[1].NozzleSpeedMax = 300
Presets.A2Amissile5000[1].Lighting = 0.6
Presets.A2Amissile5000[1].DetailFactorMax = 4.0
Presets.A2Amissile5000[1].ScaleBase = 3.6
Presets.A2Amissile5000[1].DissipationFactor = 15.5
Presets.A2Amissile5000[1].LODdistance0 = 13000 -- m
Presets.A2Amissile5000[1].LODdistance1 = 55000
Presets.A2Amissile5000[1].Length = 8200	-- m
Presets.A2Amissile5000[1].SegmentLength = 40	-- m
Presets.A2Amissile5000[1].FadeIn = 0.2 -- m
Presets.A2Amissile5000[1].ColorFadingFactor = 0.0
Presets.A2Amissile5000[1].MissileColor = {0.78, 0.76, 0.70}
Presets.A2Amissile5000[1].MissileAlpha = 0.145
Presets.A2Amissile5000[1].LifeScaleFactor = 1.76
Presets.A2Amissile5000[1].LifeScalePow = 0.68

Presets.A2Amissile2500 = deepcopy(Effect)
Presets.A2Amissile2500[1].Tech = "Missile"
Presets.A2Amissile2500[1].Nozzle = true
Presets.A2Amissile2500[1].Flame = true
Presets.A2Amissile2500[1].NozzleSpeedMin = 300
Presets.A2Amissile2500[1].NozzleSpeedMax = 300
Presets.A2Amissile2500[1].Lighting = 0.6
Presets.A2Amissile2500[1].DetailFactorMax = 4.0
Presets.A2Amissile2500[1].ScaleBase = 3.35
Presets.A2Amissile2500[1].DissipationFactor = 11.0
Presets.A2Amissile2500[1].LODdistance0 = 10000 -- m
Presets.A2Amissile2500[1].LODdistance1 = 50000
Presets.A2Amissile2500[1].Length = 4600	-- m
Presets.A2Amissile2500[1].SegmentLength = 36	-- m
Presets.A2Amissile2500[1].FadeIn = 0.2 -- m
Presets.A2Amissile2500[1].ColorFadingFactor = 0.0
Presets.A2Amissile2500[1].MissileColor = {0.78, 0.76, 0.70}
Presets.A2Amissile2500[1].MissileAlpha = 0.135
Presets.A2Amissile2500[1].LifeScaleFactor = 1.68
Presets.A2Amissile2500[1].LifeScalePow = 0.70

Presets.A2Amissile1000 = deepcopy(Effect)
Presets.A2Amissile1000[1].Tech = "Missile"
Presets.A2Amissile1000[1].Nozzle = true
Presets.A2Amissile1000[1].Flame = true
Presets.A2Amissile1000[1].NozzleSpeedMin = 300
Presets.A2Amissile1000[1].NozzleSpeedMax = 300
Presets.A2Amissile1000[1].Lighting = 0.6
Presets.A2Amissile1000[1].DetailFactorMax = 4.0
Presets.A2Amissile1000[1].ScaleBase = 3.1
Presets.A2Amissile1000[1].DissipationFactor = 6.8
Presets.A2Amissile1000[1].LODdistance0 = 8000 -- m
Presets.A2Amissile1000[1].LODdistance1 = 42000
Presets.A2Amissile1000[1].Length = 2200	-- m
Presets.A2Amissile1000[1].SegmentLength = 32	-- m
Presets.A2Amissile1000[1].FadeIn = 0.2 -- m
Presets.A2Amissile1000[1].ColorFadingFactor = 0.0
Presets.A2Amissile1000[1].MissileColor = {0.78, 0.76, 0.70}
Presets.A2Amissile1000[1].MissileAlpha = 0.12
Presets.A2Amissile1000[1].LifeScaleFactor = 1.56
Presets.A2Amissile1000[1].LifeScalePow = 0.72

Presets.A2Amissile10000Afterburner = deepcopy(Effect)
Presets.A2Amissile10000Afterburner[1].Tech = "Missile"
Presets.A2Amissile10000Afterburner[1].Nozzle = true
Presets.A2Amissile10000Afterburner[1].Flame = true
Presets.A2Amissile10000Afterburner[1].NozzleSpeedMin = 300
Presets.A2Amissile10000Afterburner[1].NozzleSpeedMax = 300
Presets.A2Amissile10000Afterburner[1].Lighting = 0.18
Presets.A2Amissile10000Afterburner[1].DetailFactorMax = 4.0
Presets.A2Amissile10000Afterburner[1].ScaleBase = 2.5
Presets.A2Amissile10000Afterburner[1].DissipationFactor = 17.5
Presets.A2Amissile10000Afterburner[1].LODdistance0 = 14000 -- m
Presets.A2Amissile10000Afterburner[1].LODdistance1 = 60000
Presets.A2Amissile10000Afterburner[1].Length = 14500	-- m
Presets.A2Amissile10000Afterburner[1].SegmentLength = 44	-- m
Presets.A2Amissile10000Afterburner[1].FadeIn = 0.35 -- m
Presets.A2Amissile10000Afterburner[1].MissileColor = {1.0, 0.67*1.25, 0.45*1.25}
Presets.A2Amissile10000Afterburner[1].MissileAlpha = 0.10
Presets.A2Amissile10000Afterburner[1].ColorFadingFactor = 0.0
Presets.A2Amissile10000Afterburner[1].LifeScaleFactor = 1.62
Presets.A2Amissile10000Afterburner[1].LifeScalePow = 0.72
Presets.A2Amissile10000Afterburner[2] = 
{
	Type = "afterburner",
	Texture = "afterburner.dds",
	TextureCircle = "afterburner_circle.dds",
	TextureGlow = "flareGlow.dds",
	StuttPower = 5,
	TrailLength = 4,
	TrailScale = 0.25,
	LODdistance0 = 1500,
	LODdistance1 = 8000,
	CircleBrightness = 2,
	WindInfluence = 0.0,
	VolumeBrightness = 11,
	Offset = {0.38, 0.00, 0.0},
}

Presets.A2Amissile5000Afterburner = deepcopy(Presets.A2Amissile10000Afterburner)
Presets.A2Amissile5000Afterburner[1].NozzleSpeedMin = 300
Presets.A2Amissile5000Afterburner[1].NozzleSpeedMax = 300
Presets.A2Amissile5000Afterburner[1].Lighting = 0.6
Presets.A2Amissile5000Afterburner[1].ScaleBase = 3.1
Presets.A2Amissile5000Afterburner[1].DissipationFactor = 12.0
Presets.A2Amissile5000Afterburner[1].LODdistance0 = 13000 -- m
Presets.A2Amissile5000Afterburner[1].LODdistance1 = 55000
Presets.A2Amissile5000Afterburner[1].Length = 7800	-- m
Presets.A2Amissile5000Afterburner[1].SegmentLength = 40	-- m
Presets.A2Amissile5000Afterburner[1].FadeIn = 0.35 -- m
Presets.A2Amissile5000Afterburner[1].MissileColor = {1.0, 0.67*1.25, 0.45*1.25}
Presets.A2Amissile5000Afterburner[1].MissileAlpha = 0.11
Presets.A2Amissile5000Afterburner[1].LifeScaleFactor = 1.58
Presets.A2Amissile5000Afterburner[1].LifeScalePow = 0.72

Presets.A2Amissile5000Afterburner[2].StuttPower = 5
Presets.A2Amissile5000Afterburner[2].TrailLength = 9
Presets.A2Amissile5000Afterburner[2].TrailScale = 0.5
Presets.A2Amissile5000Afterburner[2].LODdistance0 = 1500
Presets.A2Amissile5000Afterburner[2].LODdistance1 = 8000
Presets.A2Amissile5000Afterburner[2].CircleBrightness = 5
Presets.A2Amissile5000Afterburner[2].VolumeBrightness = 3
Presets.A2Amissile5000Afterburner[2].Offset = {0.07, 0.08, 0.0}


Presets.A2Amissile2500Afterburner = deepcopy(Presets.A2Amissile10000Afterburner)
Presets.A2Amissile2500Afterburner[1].NozzleSpeedMin = 300
Presets.A2Amissile2500Afterburner[1].NozzleSpeedMax = 300
Presets.A2Amissile2500Afterburner[1].Lighting = 0.6
Presets.A2Amissile2500Afterburner[1].ScaleBase = 3.0
Presets.A2Amissile2500Afterburner[1].DissipationFactor = 8.5
Presets.A2Amissile2500Afterburner[1].LODdistance0 = 10000 -- m
Presets.A2Amissile2500Afterburner[1].LODdistance1 = 50000
Presets.A2Amissile2500Afterburner[1].Length = 4500	-- m
Presets.A2Amissile2500Afterburner[1].SegmentLength = 36	-- m
Presets.A2Amissile2500Afterburner[1].FadeIn = 0.35 -- m
Presets.A2Amissile2500Afterburner[1].MissileColor = {1.0, 0.67*1.25, 0.45*1.25}
Presets.A2Amissile2500Afterburner[1].MissileAlpha = 0.11
Presets.A2Amissile2500Afterburner[1].LifeScaleFactor = 1.52
Presets.A2Amissile2500Afterburner[1].LifeScalePow = 0.74

Presets.A2Amissile2500Afterburner[2].StuttPower = 5
Presets.A2Amissile2500Afterburner[2].TrailLength = 9
Presets.A2Amissile2500Afterburner[2].TrailScale = 0.5
Presets.A2Amissile2500Afterburner[2].CircleBrightness = 5
Presets.A2Amissile2500Afterburner[2].VolumeBrightness = 3
Presets.A2Amissile2500Afterburner[2].LODdistance0 = 1500
Presets.A2Amissile2500Afterburner[2].LODdistance1 = 8000
Presets.A2Amissile2500Afterburner[2].Offset = {0.07, 0.08, 0.0}


Presets.A2Amissile1000Afterburner = deepcopy(Presets.A2Amissile10000Afterburner)
Presets.A2Amissile1000Afterburner[1].NozzleSpeedMin = 300
Presets.A2Amissile1000Afterburner[1].NozzleSpeedMax = 300
Presets.A2Amissile1000Afterburner[1].Lighting = 0.6	
Presets.A2Amissile1000Afterburner[1].ScaleBase = 2.8
Presets.A2Amissile1000Afterburner[1].DissipationFactor = 4.8
Presets.A2Amissile1000Afterburner[1].LODdistance0 = 8000 -- m
Presets.A2Amissile1000Afterburner[1].LODdistance1 = 42000
Presets.A2Amissile1000Afterburner[1].Length = 2100	-- m
Presets.A2Amissile1000Afterburner[1].SegmentLength = 32	-- m
Presets.A2Amissile1000Afterburner[1].FadeIn = 0.35 -- m
Presets.A2Amissile1000Afterburner[1].MissileColor = {1.0, 0.67*1.25, 0.45*1.25}
Presets.A2Amissile1000Afterburner[1].MissileAlpha = 0.095
Presets.A2Amissile1000Afterburner[1].LifeScaleFactor = 1.44
Presets.A2Amissile1000Afterburner[1].LifeScalePow = 0.76

Presets.A2Amissile1000Afterburner[2].StuttPower = 5
Presets.A2Amissile1000Afterburner[2].TrailLength = 5
Presets.A2Amissile1000Afterburner[2].TrailScale = 0.1
Presets.A2Amissile1000Afterburner[2].CircleBrightness = 5
Presets.A2Amissile1000Afterburner[2].VolumeBrightness = 3
Presets.A2Amissile1000Afterburner[2].LODdistance0 = 1500
Presets.A2Amissile1000Afterburner[2].LODdistance1 = 8000
Presets.A2Amissile1000Afterburner[2].Offset = {0.07, 0.02, 0.0}


Presets.MissileNoCircleAfterburner = deepcopy(Presets.A2Amissile10000Afterburner)
Presets.MissileNoCircleAfterburner[1].NozzleSpeedMin = 300
Presets.MissileNoCircleAfterburner[1].NozzleSpeedMax = 300
Presets.MissileNoCircleAfterburner[1].Lighting = 0.2
Presets.MissileNoCircleAfterburner[1].ScaleBase = 2.1
Presets.MissileNoCircleAfterburner[1].DissipationFactor = 8.0
Presets.MissileNoCircleAfterburner[1].LODdistance0 = 14000 -- m
Presets.MissileNoCircleAfterburner[1].LODdistance1 = 60000
Presets.MissileNoCircleAfterburner[1].Length = 14000	-- m
Presets.MissileNoCircleAfterburner[1].SegmentLength = 60	-- m
Presets.MissileNoCircleAfterburner[1].FadeIn = 0.35 -- m
Presets.MissileNoCircleAfterburner[1].MissileColor = {1.0, 0.67*1.25, 0.45*1.25}
Presets.MissileNoCircleAfterburner[1].MissileAlpha = 0.13
Presets.MissileNoCircleAfterburner[1].ColorFadingFactor = 0
Presets.MissileNoCircleAfterburner[1].LifeScaleFactor = 1.52
Presets.MissileNoCircleAfterburner[1].LifeScalePow = 0.74

Presets.MissileNoCircleAfterburner[2].StuttPower = 5
Presets.MissileNoCircleAfterburner[2].TrailLength = 2.5
Presets.MissileNoCircleAfterburner[2].TrailScale = 0.1
Presets.MissileNoCircleAfterburner[2].CircleBrightness = 0.4
Presets.MissileNoCircleAfterburner[2].VolumeBrightness = 8
Presets.MissileNoCircleAfterburner[2].LODdistance0 = 1500
Presets.MissileNoCircleAfterburner[2].LODdistance1 = 8000
Presets.MissileNoCircleAfterburner[2].CircleNumber = 0
Presets.MissileNoCircleAfterburner[2].Offset = {0.38, 0.00, 0.0}


Presets.markerSmoke = deepcopy(Effect)
Presets.markerSmoke[1].LODdistance0 = 20000 -- m
Presets.markerSmoke[1].LODdistance1 = 50000
Presets.markerSmoke[1].ScaleBase = 3
Presets.markerSmoke[1].Lighting = 0.5
Presets.markerSmoke[1].DetailFactorMax = 5.0
Presets.markerSmoke[1].Nozzle	= true
Presets.markerSmoke[1].NozzleSpeedMin = 200
Presets.markerSmoke[1].NozzleSpeedMax = 400
Presets.markerSmoke[1].FadeInRange = 350
Presets.markerSmoke[1].FadeOutHeight = 12000
Presets.markerSmoke[1].Length = 12000	-- m
Presets.markerSmoke[1].SegmentLength = 60 -- m
Presets.markerSmoke[1].FadeIn = 30 -- m
Presets.markerSmoke[1].ColorFadingFactor = 0.0

Presets.Torpedo = deepcopy(Effect)
Presets.Torpedo[1].Nozzle = true
Presets.Torpedo[1].Flame = false
Presets.Torpedo[1].UnderWater = true
Presets.Torpedo[1].NozzleSpeedMin = 300
Presets.Torpedo[1].NozzleSpeedMax = 300
Presets.Torpedo[1].DetailFactorMax = 5.0
Presets.Torpedo[1].Lighting = 0.5
Presets.Torpedo[1].ScaleBase = 0.25
Presets.Torpedo[1].DissipationFactor = 5.0
Presets.Torpedo[1].LODdistance0 = 15000 -- m
Presets.Torpedo[1].LODdistance1 = 50000
Presets.Torpedo[1].Length = 1200	-- m
Presets.Torpedo[1].SegmentLength = 20	-- m
Presets.Torpedo[1].FadeIn = 100 -- m
Presets.Torpedo[1].Target = "refraction"
Presets.Torpedo[1].ColorFadingFactor = 0.0

Presets.podSmoke = deepcopy(Effect)
Presets.podSmoke[1].LODdistance0 = 10000 -- m
Presets.podSmoke[1].LODdistance1 = 50000
Presets.podSmoke[1].ScaleBase = 2 -- meters
Presets.podSmoke[1].Lighting = 1
Presets.podSmoke[1].DetailFactorMax = 5.0 
Presets.podSmoke[1].Flame = false
Presets.podSmoke[1].Nozzle	= false
Presets.podSmoke[1].NozzleDir = -1
Presets.podSmoke[1].NozzleSpeedMin = 0
Presets.podSmoke[1].NozzleSpeedMax = 0
Presets.podSmoke[1].FadeInRange = 0 
Presets.podSmoke[1].FadeOutHeight = 99999
Presets.podSmoke[1].DissipationFactor = 20.0
Presets.podSmoke[1].Length = 7000 -- m
Presets.podSmoke[1].SegmentLength = 60	-- m
Presets.podSmoke[1].FadeIn = 0	-- m
Presets.podSmoke[1].PodSmoke = true
