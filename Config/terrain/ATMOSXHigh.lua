-- ATMOSX High terrain profile
distance =
{
	distance10x10 = 132000;  -- Extended from 140k for ultra-long-range terrain detail
	distanceLevel0 = 132000;  -- Matches maximum LevelFormap2 effective range (120k * 2.0)
	uniqueSceneFarDistance = 30000;  -- Increased from 30k to render distant buildings longer
	smokesSceneFarDistance = 30000;  -- Increased from 30k for atmospheric effects reach
	minimalSquareOnScreen = 50;
	minimalSquareOnScreenFull = 100;
	
	mapLodDistance0 = 1200;  -- Closest map detail level
	mapLodDistance1 = 2400;  -- Mid-range map geometry
	mapLodDistance2 = 3600;  -- Distant map geometry
	mapLodDistance3 = 7200;  -- Extended from 8k for ultra-distant map features
	smallShitDimention = 3600;  -- Increased from 4k for better small object persistence
}
-- Extended terrain feature blending to support long-range ATMOSX visibility
distanceBlend = 
{
	townNearDistance  = 60000;  -- Near blend start for urban areas (increased from 80k)
	townFarDistance   = 132000;  -- Far blend end matches far_clip (increased from 120k)
	fieldNearDistance = 36000;  -- Near blend for fields (increased from 40k)
	fieldFarDistance  = 108000;  -- Far blend for fields (increased from 140k)
	waterNearDistance = 36000;  -- Near blend for water features (increased from 40k)
	waterFarDistance  = 84000;  -- Far blend for water (increased from 80k)
	townLightNearDistance  = 12000;  -- Near city lighting blend (increased from 10k)
	townLightFarDistance  = 72000;  -- Far city lighting blend (increased from 20k)
	subforest = {18000, 72000};  -- Forest blending extended (from {20k, 60k})
	beach = {18000, 72000};  -- Beach blending extended (from {30k, 60k})
	road = {18000, 72000};  -- Road blending extended (from {30k, 60k})
}

--Old Noise 
land_noise =
{
	noisemin = 0.0;
	noisemax = 0.6;
	noise1front = 1000.0;
	noise1back = 80000.0;
	noise1top = 12000.0;
	noise1bottom = 2000.0;
	noise1PerSquare = 2.0;
	noise2PerSquare = 150.0;
}

land_detailNoise=
{
	Height = 700.0;
	Slope = 0.0;	
}

-- District rendering tuned to ATMOSX graphics profile values (objects range: 5000-140000)
district =
{
	maxDistrictsAround = 60000;

	farDistance = 9600;  -- Reduced from 22k to stabilize large-city district streaming
	farFullRenderDistance = 7200;  -- Reduced from 18k to avoid dense urban chunk flicker
	nearFullRenderDistance = 3600;  -- Reduced from 9k for more stable full-detail transitions
	nearDistance = 3600;  -- Reduced from 9k to keep city culling within a safer range
	
-- These tree values seem to be obsolete (they don't do anything)
	treesFarDistance = 7200;  -- Extended from 1500 to prevent pop-in with ATMOSX 900m districtobjects
	treesFarFullBlendRenderDistance = 4800;  -- Extended from 1200 for smooth tree fade-out
	treesFarFullRenderDistance = 3000;  -- Extended from 1000 to match district geometry ranges
	treeslodDistance = 1500;  -- Extended from 600 to reduce LOD popping
	heightFactor = 0;
	heightRandomFactor = 0;
	ajastfactor = 1;
	
	lampFarDistance = 72000;  -- Extended from 10k to match graphics lights range {200, 120000}
	splineBlockFarDistance = 720;  -- Increased from 500 for extended road spline visibility

--	renderType = "texture"; -- simple, texture, instance
	renderType = "simple"; -- simple, texture, instance
	
	-- District lamps: enhanced for long-range night visibility with ATMOSX preset
	lamp =
	{
		lampOn = 1;	
		maxSize = 8.4;
		staticSize = 4.0;
		spriteScale = 0.001;
		minDistance = 150.0;
		maxDistance = 18000;  -- Extended from 10k for distant city light sprite reach
		maxAlphaDistance = 7200;  -- Extended from 400 for smoother alpha fade
		minAlphaDistance = 0;
		minAlpha = 0.0;
		maxAlpha = 1.0;
		minBrightnessDistance = 0.0;
		maxBrightnessDistance = 72000;  -- Extended to lampFarDistance for consistent night lighting
		dsLightRadius = 80;  -- Increased from 60 for better night halo visibility
		dsLightBrightness = 5;  -- Increased from 4 for stronger distant ambient glow
	};
}

flat_shadow =
{
	farDistance = 900; -- doesn't do anything
	fullFarDistance = 0.0; -- doesn't do anything 
}

-- Fog extended to support long-range ATMOSX visibility
fog =
{
	front = 1000.0;  -- Near fog plane
	back  = 84000;  -- Increased from 70k to match extended terrain reach
}

layerfog =
{
	fog_begin = 0.0;
	fog_end = 1000.0;
	fog_strength = 10000.0;
	fog_color = {1.0, 1.0, 1.0};
}

infrared =
{
	landDetail = 0.8;
	landDarkness = 1.0;
	riverDarkness = 0.7;
	roadDarkness = 1.5;
	runwayDarkness = 1.7;
}

noise =
{
	noiseStartDistance = 3000.0;
	noiseEndDistance = 200.0;
	noiseMaxBlend = 0.7;
	noiseScale = 90.0;  --15.0
	rampNoisePower = 0.8;
	rampNoiseScale = 17.0;
	smallNoiseStartDistance = 200.0;
	smallNoiseEndDistance = 1.0;
	smallNoiseMaxBlend = 0.5;
	smallNoiseScale = 450.0;		
}

-- Global lamp31 profile: night lighting extended to ultra-distant range
lamp31 =
{
	lampOn = 1;	
	maxSize = 8.4;
	staticSize = 4.0;
	spriteScale = 0.001;
	minDistance = 150.0;
	maxDistance = 18000;  -- Extended from 10k for global distant light visibility
	maxAlphaDistance = 7200;  -- Extended from 400 for smooth distant fade
	minAlphaDistance = 0;
	minAlpha = 0.0;
	maxAlpha = 1.0;
	minBrightnessDistance = 0.0;
	maxBrightnessDistance = 72000;  -- Extended to support long-range lighting
	dsLightRadius = 80;  -- Increased from 60 for enhanced night halo effect
	dsLightBrightness = 5;  -- Increased from 4 for brighter distant ambience
}

-- General lamp profile: fine-grained lighting extended for mid-range night visibility
lamp =
{
	lampOn = 1;	
	maxSize = 5.4;
	staticSize = 2.9;
	spriteScale = 0.0012; 
	minDistance = 100.0;
	maxDistance = 7200;  -- Extended from 3385 for extended local light sprite reach
	maxAlphaDistance = 4800;  -- Extended from 1300 for smoother fade-out at range
	minAlphaDistance = 360;  -- Increased from 250 to start fade sooner and smoother
	minAlpha = 0.0; --0.36
	maxAlpha = 1.0; --0.26
	minBrightnessDistance = 0.0;
	maxBrightnessDistance =72000;  -- Extended from 24k to match ATMOSX lamp brightness reach
}

fan = 
{
	read = 0; -- ������ ��������� �� ����� ������� (��� �������)
	
	pos = {-117, 0.3, 120};
	dir = {0, -1, 0};
	power = 8000;
	radius = 30;
	
	oscillator = 0.2;
	frequency = 15;
};

--hiddensemantics={0, 2, 5, 7, 9, 23, 26};
hiddensemantics={
--	"Sea",
--	"Lake", 
--	"Island",
--	"Land",
--	"Field",
--	"Beach",
--	"Plant",
--	"Town",
--	"River",
--	"Channel",
--	"Road",
--	"Rail",
--	"Runway",
--	"Building",
--	"ELT",
--	"SmallShit",
--	"Trees",
--	"Lamp",
	};
hiddenlayer={
--	0,
--	1,
--	2, 
--	3, 
--	4, 
--	5, 
--	6, 
--	18,
--	19,		-- flat_shadows		
--	20,		-- houses
--	21,		-- trees
--	22,		-- pole
--	23,		-- lights
--	24
};
hiddenlevels={
--	0, 
--	1, 
--	2
	};
hiddencameras={
--	0, --near, 
--	1, --far
	};
debug = 
{
	switchoffDrawRoutine = 0;
	switchoffEdm = 0;
	switchoffFetchSurface = 0;
	switchoffFetchUniqueScenes = 0;
	switchoffFetchDistricts = 0;
	switchoffFetchSmokes = 0;
	switchoffFetchLights = 0;
	switchoffRenderLights = 0;
}
