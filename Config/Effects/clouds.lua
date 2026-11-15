-- G2_Escalas_Muito_Misturadas: noiseBlur/noiseFreq reajustados para misturar escalas de ruido (base K3)
-- K3_AmplitudeMaior: mapa suave de faixa larga, coverageMapFactor=1.0, espessura x1.35 (base E2)
-- E2_Gomos_Maior: gomos maiores/mais macios e com variacao (base T7a)
-- T7a_AltasDetalhe_Moderado: camadas com base >= 4000 m (teste), base T5b
-- T5b_Espessura_x19: base T4a + espessura x1.9 (teste)
-- T4a_Mapa050_CoberturaPlus15: coverageMapFactor=0.5, coverage x1.15 (teste)
-- ATMOS-X presets + detail tuning (D_Detalhe): experimental cumulus tuning; requires in-game validation.
cloudsTechnique = 0 -- 0 - volumteric, 1 - via OParticleSystem, 2 - old-school 3- old-school EDGE-style

clouds = 
{
	presets = 
	{		
		
		default =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 938,
					altitudeMax = 2500,
					tile = 2.352,
					shapeFactor = 0.000,
					density = 0.622,
					densityGrad = 2.855,
					coverage = 0.495,
					noiseFreq = 2.658,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5000,
					altitudeMax = 5938,
					tile = 5.744,
					shapeFactor = 0.000,
					density = 0.530,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3438,
					altitudeMax = 4688,
					tile = 2.640,
					shapeFactor = 0.000,
					density = 0.542,
					densityGrad = 1.000,
					coverage = 0.447,
					noiseFreq = 2.232,
					noiseBlur = 0.429,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset89 =
		{
			visibleInGUI = true,
			readableName = '99 ## Congestus Teste (vertical)',
			readableNameShort = 'Congestus Teste',
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cumulus5.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = 1400.00,
			presetAltMax = 7500.00,
			layers = {
				{
					altitudeMin = 1400,
					altitudeMax = 6000,
					tile = 2.500,
					shapeFactor = 0.400,
					density = 0.850,
					densityGrad = 1.300,
					coverage = 0.220,
					noiseFreq = 1.000,
					noiseBlur = 1.200,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6200,
					altitudeMax = 7200,
					tile = 1.000,
					shapeFactor = 0.050,
					density = 0.450,
					densityGrad = 0.800,
					coverage = 0.550,
					noiseFreq = 0.800,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 1.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset1 =
		{
			visibleInGUI = true,
			readableName = '01 ##'.._('Few Scattered Clouds \nMETAR: FEW/SCT 7/8'),
			readableNameShort = _('Light Scattered 1 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 8450.00,
			precipitationPower = -1.00,
			presetAltMin = 840.00,
			presetAltMax = 4200.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4890,
					tile = 9.024,
					shapeFactor = 0.015,
					density = 0.428,
					densityGrad = 0.622,
					coverage = 0.550,
					noiseFreq = 0.800,
					noiseBlur = 1.230,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5040,
					altitudeMax = 6500,
					tile = 5.104,
					shapeFactor = 0.132,
					density = 0.487,
					densityGrad = 1.032,
					coverage = 0.472,
					noiseFreq = 0.945,
					noiseBlur = 1.267,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.37,
					coverageMapUVOffsetY = 0.61,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.880,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 2.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset2 =
		{
			visibleInGUI = true,
			readableName = '02 ##'.._('Two Layers Few and Scattered \nMETAR: FEW/SCT 8/10 SCT 23/24'),
			readableNameShort = _('Light Scattered 2 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_2.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 11350.00,
			precipitationPower = -1.00,
			presetAltMin = 1260.00,
			presetAltMax = 2520.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4880,
					tile = 4.336,
					shapeFactor = 0.000,
					density = 0.546,
					densityGrad = 1.200,
					coverage = 0.641,
					noiseFreq = 2.160,
					noiseBlur = 1.290,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7560,
					altitudeMax = 8400,
					tile = 2.992,
					shapeFactor = 0.264,
					density = 0.680,
					densityGrad = 1.466,
					coverage = 0.539,
					noiseFreq = 2.105,
					noiseBlur = 1.218,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10920,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset3 =
		{
			visibleInGUI = true,
			readableName = '03 ##'.._('Two Layer Scattered \nMETAR: SCT 8/9 FEW 21'),
			readableNameShort = _('High Scattered 1 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_3.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 9150.00,
			precipitationPower = -1.00,
			presetAltMin = 840.00,
			presetAltMax = 2520.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5750,
					tile = 4.800,
					shapeFactor = 0.000,
					density = 0.689,
					densityGrad = 1.406,
					coverage = 0.679,
					noiseFreq = 2.129,
					noiseBlur = 1.046,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6300,
					altitudeMax = 7560,
					tile = 3.216,
					shapeFactor = 0.264,
					density = 0.504,
					densityGrad = 1.466,
					coverage = 0.584,
					noiseFreq = 2.200,
					noiseBlur = 1.322,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.37,
					coverageMapUVOffsetY = 0.61,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset4 =
		{
			visibleInGUI = true,
			readableName = '04 ##'.._('Two Layer Scattered \nMETAR: SCT 8/10 FEW/SCT 24/26'),
			readableNameShort = _('High Scattered 2 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_4.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10500.00,
			precipitationPower = -1.00,
			presetAltMin = 1260.00,
			presetAltMax = 2520.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5750,
					tile = 6.032,
					shapeFactor = 0.000,
					density = 0.600,
					densityGrad = 1.200,
					coverage = 0.719,
					noiseFreq = 2.200,
					noiseBlur = 1.208,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7560,
					altitudeMax = 8560,
					tile = 2.992,
					shapeFactor = 0.000,
					density = 0.827,
					densityGrad = 1.400,
					coverage = 0.573,
					noiseFreq = 2.200,
					noiseBlur = 1.248,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10920,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset5 =
		{
			visibleInGUI = true,
			readableName = '05 ##'.._('Three Layer High altitude Scattered \nMETAR: SCT 14/17 FEW 27/29 BKN 40'),
			readableNameShort = _('Scattered 1 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_5.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10400.00,
			precipitationPower = -1.00,
			presetAltMin = 1260.00,
			presetAltMax = 4620.00,
			layers = {
				{
					altitudeMin = 4620,
					altitudeMax = 6480,
					tile = 3.392,
					shapeFactor = 0.000,
					density = 0.680,
					densityGrad = 1.000,
					coverage = 0.696,
					noiseFreq = 3.272,
					noiseBlur = 0.386,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8400,
					altitudeMax = 9240,
					tile = 6.096,
					shapeFactor = 0.000,
					density = 0.399,
					densityGrad = 1.200,
					coverage = 0.443,
					noiseFreq = 1.142,
					noiseBlur = 1.228,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.880,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 2.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset6 =
		{
			visibleInGUI = true,
			readableName = '06 ##'.._('One Layer Scattered/Broken \nMETAR: SCT/BKN 8/10 FEW 40'),
			readableNameShort = _('Scattered 2 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_6.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 9900.00,
			precipitationPower = -1.00,
			presetAltMin = 1260.00,
			presetAltMax = 4200.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4680,
					tile = 6.512,
					shapeFactor = 0.000,
					density = 0.529,
					densityGrad = 1.114,
					coverage = 0.791,
					noiseFreq = 1.088,
					noiseBlur = 1.179,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7140,
					altitudeMax = 9240,
					tile = 2.112,
					shapeFactor = 0.000,
					density = 1.136,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.051,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 12180,
					altitudeMax = 13020,
					tile = 3.040,
					shapeFactor = 0.000,
					density = 1.026,
					densityGrad = 2.000,
					coverage = 0.000,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset7 =
		{
			visibleInGUI = true,
			readableName = '07 ##'.._('Two Layer Scattered/Broken \nMETAR: BKN 7.5/12 SCT/BKN 21/23 SCT 40'),
			readableNameShort = _('Scattered 3 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_7.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 11400.00,
			precipitationPower = -1.00,
			presetAltMin = 1680.00,
			presetAltMax = 5040.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 6000,
					tile = 4.336,
					shapeFactor = 0.253,
					density = 0.648,
					densityGrad = 1.000,
					coverage = 0.603,
					noiseFreq = 1.039,
					noiseBlur = 1.289,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6720,
					altitudeMax = 7980,
					tile = 2.048,
					shapeFactor = 0.000,
					density = 0.582,
					densityGrad = 1.000,
					coverage = 0.417,
					noiseFreq = 2.200,
					noiseBlur = 1.239,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.880,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 2.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset8 =
		{
			visibleInGUI = true,
			readableName = '08 ##'.._('Two Layer Scattered/Broken High Altitude \nMETAR: SCT/BKN 18/20 FEW 36/38 FEW 40'),
			readableNameShort = _('High Scattered 3 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_8.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 11250.00,
			precipitationPower = -1.00,
			presetAltMin = 3780.00,
			presetAltMax = 5460.00,
			layers = {
				{
					altitudeMin = 5460,
					altitudeMax = 6720,
					tile = 6.032,
					shapeFactor = 0.000,
					density = 0.670,
					densityGrad = 1.200,
					coverage = 0.769,
					noiseFreq = 0.000,
					noiseBlur = 0.459,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10920,
					altitudeMax = 12600,
					tile = 0.816,
					shapeFactor = 0.853,
					density = 0.565,
					densityGrad = 0.700,
					coverage = 0.400,
					noiseFreq = 1.967,
					noiseBlur = 1.170,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.880,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 2.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset9 =
		{
			visibleInGUI = true,
			readableName = '09 ##'.._('Two Layer Broken/Scattered \nMETAR: BKN 7.5/10 SCT 20/22 FEW41'),
			readableNameShort = _('Scattered 4 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_9.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10700.00,
			precipitationPower = -1.00,
			presetAltMin = 1680.00,
			presetAltMax = 3780.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5750,
					tile = 8.032,
					shapeFactor = 0.000,
					density = 0.950,
					densityGrad = 1.500,
					coverage = 0.808,
					noiseFreq = 3.066,
					noiseBlur = 0.765,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6300,
					altitudeMax = 7560,
					tile = 5.104,
					shapeFactor = 0.000,
					density = 0.592,
					densityGrad = 1.200,
					coverage = 0.708,
					noiseFreq = 0.881,
					noiseBlur = 1.268,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.37,
					coverageMapUVOffsetY = 0.61,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.880,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset10 =
		{
			visibleInGUI = true,
			readableName = '10 ##'.._('Two Layers Scattered Large Thick Clouds  \nMETAR: SCT/BKN 18/20 FEW36/38 FEW 40'),
			readableNameShort = _('Scattered 5 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_10.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12800.00,
			precipitationPower = -1.00,
			presetAltMin = 1260.00,
			presetAltMax = 4200.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 6000,
					tile = 9.200,
					shapeFactor = 0.106,
					density = 0.585,
					densityGrad = 1.000,
					coverage = 0.603,
					noiseFreq = 0.800,
					noiseBlur = 1.222,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6720,
					altitudeMax = 7980,
					tile = 7.744,
					shapeFactor = 0.084,
					density = 0.660,
					densityGrad = 1.000,
					coverage = 0.506,
					noiseFreq = 0.000,
					noiseBlur = 0.459,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.880,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset11 =
		{
			visibleInGUI = true,
			readableName = '11 ##'.._('Two Layers Scattered Large Clouds High Ceiling \nMETAR: BKN 18/20 BKN 32/33 FEW 41'),
			readableNameShort = _('Scattered 6 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_11.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12550.00,
			precipitationPower = -1.00,
			presetAltMin = 2520.00,
			presetAltMax = 5460.00,
			layers = {
				{
					altitudeMin = 5460,
					altitudeMax = 6720,
					tile = 2.224,
					shapeFactor = 0.000,
					density = 0.686,
					densityGrad = 1.000,
					coverage = 0.949,
					noiseFreq = 3.222,
					noiseBlur = 0.340,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 9660,
					altitudeMax = 10500,
					tile = 4.752,
					shapeFactor = 0.026,
					density = 0.670,
					densityGrad = 1.200,
					coverage = 0.573,
					noiseFreq = 2.200,
					noiseBlur = 1.092,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.880,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 2.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset12 =
		{
			visibleInGUI = true,
			readableName = '12 ##'.._('Two Layers Scattered Large Clouds High Ceiling \nMETAR: BKN 12/14 SCT 22/23 FEW 41'),
			readableNameShort = _('Scattered 7 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_12.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 11200.00,
			precipitationPower = -1.00,
			presetAltMin = 1680.00,
			presetAltMax = 3360.00,
			layers = {
				{
					altitudeMin = 3360,
					altitudeMax = 6150,
					tile = 5.504,
					shapeFactor = 0.125,
					density = 0.562,
					densityGrad = 1.400,
					coverage = 0.713,
					noiseFreq = 0.000,
					noiseBlur = 0.376,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6300,
					altitudeMax = 7560,
					tile = 2.400,
					shapeFactor = 0.000,
					density = 0.618,
					densityGrad = 0.660,
					coverage = 0.713,
					noiseFreq = 2.031,
					noiseBlur = 1.165,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.37,
					coverageMapUVOffsetY = 0.61,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.880,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 2.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset13 =
		{
			visibleInGUI = true,
			readableName = '13 ##'.._('Two Layers Broken Clouds \nMETAR: BKN 12/14 BKN 26/28 FEW 41'),
			readableNameShort = _('Broken 1 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_13.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12050.00,
			precipitationPower = -1.00,
			presetAltMin = 1680.00,
			presetAltMax = 3360.00,
			layers = {
				{
					altitudeMin = 3360,
					altitudeMax = 6500,
					tile = 10.080,
					shapeFactor = 0.000,
					density = 0.490,
					densityGrad = 0.700,
					coverage = 0.763,
					noiseFreq = 0.000,
					noiseBlur = 0.765,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7980,
					altitudeMax = 8820,
					tile = 1.824,
					shapeFactor = 0.000,
					density = 0.713,
					densityGrad = 1.000,
					coverage = 0.884,
					noiseFreq = 2.200,
					noiseBlur = 1.092,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 12180,
					altitudeMax = 13020,
					tile = 3.040,
					shapeFactor = 0.000,
					density = 1.026,
					densityGrad = 2.000,
					coverage = 0.000,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset14 =
		{
			visibleInGUI = true,
			readableName = '14 ##'.._('Broken Thick Low Layer with Few High Layer\nMETAR: BKN LYR 7/16 FEW 41'),
			readableNameShort = _('Broken 2 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_14.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 11400.00,
			precipitationPower = -1.00,
			presetAltMin = 1680.00,
			presetAltMax = 3360.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4890,
					tile = 2.992,
					shapeFactor = 0.000,
					density = 0.784,
					densityGrad = 1.000,
					coverage = 0.841,
					noiseFreq = 2.200,
					noiseBlur = 1.055,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5040,
					altitudeMax = 6500,
					tile = 2.112,
					shapeFactor = 0.000,
					density = 0.817,
					densityGrad = 1.200,
					coverage = 0.841,
					noiseFreq = 2.200,
					noiseBlur = 1.117,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.37,
					coverageMapUVOffsetY = 0.61,
				},
				{
					altitudeMin = 12180,
					altitudeMax = 13020,
					tile = 3.040,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset15 =
		{
			visibleInGUI = true,
			readableName = '15 ##'.._('Two Layers Broken Large Clouds \nMETAR: SCT/BKN 14/18 BKN 24/27 FEW 40'),
			readableNameShort = _('Broken 3 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_15.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 11400.00,
			precipitationPower = -1.00,
			presetAltMin = 840.00,
			presetAltMax = 5040.00,
			layers = {
				{
					altitudeMin = 4200,
					altitudeMax = 6500,
					tile = 3.872,
					shapeFactor = 0.106,
					density = 1.000,
					densityGrad = 1.216,
					coverage = 0.736,
					noiseFreq = 1.330,
					noiseBlur = 1.283,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7140,
					altitudeMax = 8820,
					tile = 4.336,
					shapeFactor = 0.000,
					density = 1.000,
					densityGrad = 1.200,
					coverage = 0.935,
					noiseFreq = 0.800,
					noiseBlur = 1.025,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.880,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 2.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset16 =
		{
			visibleInGUI = true,
			readableName = '16 ##'.._('Two Layers Broken Large Clouds \nMETAR: BKN 14/18 BKN 28/30 FEW 40'),
			readableNameShort = _('Broken 4 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_16.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12450.00,
			precipitationPower = -1.00,
			presetAltMin = 1260.00,
			presetAltMax = 4200.00,
			layers = {
				{
					altitudeMin = 4200,
					altitudeMax = 6500,
					tile = 3.632,
					shapeFactor = 0.190,
					density = 0.827,
					densityGrad = 1.400,
					coverage = 0.881,
					noiseFreq = 0.800,
					noiseBlur = 1.027,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8400,
					altitudeMax = 10080,
					tile = 2.400,
					shapeFactor = 0.000,
					density = 0.844,
					densityGrad = 1.300,
					coverage = 0.986,
					noiseFreq = 2.200,
					noiseBlur = 1.138,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10920,
					altitudeMax = 12600,
					tile = 0.880,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 2.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset17 =
		{
			visibleInGUI = true,
			readableName = '17 ##'.._('Three Layers Broken/Overcast \nMETAR: BKN/OVC LYR 7/13 20/22 32/34'),
			readableNameShort = _('Broken 5 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_17.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 0.00,
			presetAltMax = 2520.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4620,
					tile = 9.904,
					shapeFactor = 0.165,
					density = 0.752,
					densityGrad = 1.300,
					coverage = 0.641,
					noiseFreq = 0.000,
					noiseBlur = 0.235,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6300,
					altitudeMax = 7980,
					tile = 3.568,
					shapeFactor = 0.264,
					density = 0.915,
					densityGrad = 1.200,
					coverage = 0.527,
					noiseFreq = 2.200,
					noiseBlur = 1.081,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10080,
					altitudeMax = 11340,
					tile = 2.224,
					shapeFactor = 0.000,
					density = 1.000,
					densityGrad = 1.200,
					coverage = 0.615,
					noiseFreq = 2.200,
					noiseBlur = 1.167,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset18 =
		{
			visibleInGUI = true,
			readableName = '18 ##'.._('Three Layers Broken/Overcast \nMETAR: BKN/OVC LYR 13/15 25/29 38/41'),
			readableNameShort = _('Broken 6 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_18.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 0.00,
			presetAltMax = 3780.00,
			layers = {
				{
					altitudeMin = 3780,
					altitudeMax = 5040,
					tile = 3.168,
					shapeFactor = 0.000,
					density = 0.657,
					densityGrad = 1.200,
					coverage = 0.864,
					noiseFreq = 1.575,
					noiseBlur = 1.185,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7560,
					altitudeMax = 9660,
					tile = 1.696,
					shapeFactor = 0.264,
					density = 1.000,
					densityGrad = 1.200,
					coverage = 0.745,
					noiseFreq = 2.200,
					noiseBlur = 1.168,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 11760,
					altitudeMax = 13020,
					tile = 0.880,
					shapeFactor = 0.172,
					density = 1.000,
					densityGrad = 1.300,
					coverage = 0.699,
					noiseFreq = 2.200,
					noiseBlur = 1.108,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset19 =
		{
			visibleInGUI = true,
			readableName = '19 ##'.._('Three Layers Overcast At Low Level \nMETAR: OVC 9/16 BKN/OVC LYR 23/24 31/33'),
			readableNameShort = _('Broken 7 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_19.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 0.00,
			presetAltMax = 2940.00,
			layers = {
				{
					altitudeMin = 2940,
					altitudeMax = 5460,
					tile = 2.048,
					shapeFactor = 0.509,
					density = 0.918,
					densityGrad = 1.400,
					coverage = 0.935,
					noiseFreq = 2.121,
					noiseBlur = 1.063,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7140,
					altitudeMax = 8400,
					tile = 3.040,
					shapeFactor = 0.077,
					density = 1.000,
					densityGrad = 1.200,
					coverage = 0.649,
					noiseFreq = 2.200,
					noiseBlur = 1.067,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11340,
					tile = 0.992,
					shapeFactor = 0.147,
					density = 0.844,
					densityGrad = 1.400,
					coverage = 0.451,
					noiseFreq = 2.200,
					noiseBlur = 1.176,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset20 =
		{
			visibleInGUI = true,
			readableName = '20 ##'.._('Three Layers Overcast Low Level \nMETAR: BKN/OVC 13/18 BKN 28/30 SCT FEW 38'),
			readableNameShort = _('Broken 8 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_20.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 11000.00,
			precipitationPower = -1.00,
			presetAltMin = 0.00,
			presetAltMax = 3780.00,
			layers = {
				{
					altitudeMin = 3780,
					altitudeMax = 6300,
					tile = 2.576,
					shapeFactor = 0.158,
					density = 1.000,
					densityGrad = 1.400,
					coverage = 0.805,
					noiseFreq = 1.192,
					noiseBlur = 1.217,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8400,
					altitudeMax = 10080,
					tile = 6.688,
					shapeFactor = 0.000,
					density = 1.216,
					densityGrad = 1.300,
					coverage = 0.603,
					noiseFreq = 0.000,
					noiseBlur = 0.201,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 12180,
					altitudeMax = 13440,
					tile = 1.824,
					shapeFactor = 0.000,
					density = 0.748,
					densityGrad = 2.000,
					coverage = 0.375,
					noiseFreq = 2.049,
					noiseBlur = 1.077,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset21 =
		{
			visibleInGUI = true,
			readableName = '21 ##'.._('Overcast low level \nMETAR: BKN/OVC LYR 7/8 17/19'),
			readableNameShort = _('Overcast 1 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_21.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 1260.00,
			presetAltMax = 4200.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4200,
					tile = 8.672,
					shapeFactor = 0.158,
					density = 0.748,
					densityGrad = 1.400,
					coverage = 0.549,
					noiseFreq = 0.483,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5460,
					altitudeMax = 6720,
					tile = 3.632,
					shapeFactor = 0.106,
					density = 1.000,
					densityGrad = 1.400,
					coverage = 0.762,
					noiseFreq = 2.317,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 12180,
					altitudeMax = 13440,
					tile = 1.824,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 2.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.603,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset22 =
		{
			visibleInGUI = true,
			readableName = '22 ##'.._('Overcast low Level \nMETAR: BKN LYR 7/10 17/20'),
			readableNameShort = _('Overcast 2 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_22.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 420.00,
			presetAltMax = 4200.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4200,
					tile = 2.528,
					shapeFactor = 0.066,
					density = 0.468,
					densityGrad = 0.316,
					coverage = 0.648,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5460,
					altitudeMax = 7140,
					tile = 5.984,
					shapeFactor = 0.000,
					density = 0.968,
					densityGrad = 1.200,
					coverage = 0.630,
					noiseFreq = 2.596,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 12180,
					altitudeMax = 13440,
					tile = 2.224,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.603,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset23 =
		{
			visibleInGUI = true,
			readableName = '23 ##'.._('Three Layer Broken Low Level Scattered High \nMETAR: BKN LYR 11/14 18/25 SCT 32/35'),
			readableNameShort = _('Overcast 3 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_23.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.00,
			presetAltMin = 840.00,
			presetAltMax = 3360.00,
			layers = {
				{
					altitudeMin = 3360,
					altitudeMax = 5460,
					tile = 6.272,
					shapeFactor = 0.300,
					density = 0.872,
					densityGrad = 1.400,
					coverage = 0.571,
					noiseFreq = 0.483,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5460,
					altitudeMax = 6720,
					tile = 5.456,
					shapeFactor = 0.000,
					density = 0.766,
					densityGrad = 1.500,
					coverage = 0.689,
					noiseFreq = 2.859,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10080,
					altitudeMax = 11340,
					tile = 3.040,
					shapeFactor = 0.084,
					density = 0.926,
					densityGrad = 1.400,
					coverage = 0.615,
					noiseFreq = 1.509,
					noiseBlur = 1.176,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset24 =
		{
			visibleInGUI = true,
			readableName = '24 ##'.._('Three Layer Overcast \nMETAR: BKN/OVC 3/7 17/22 BKN 34'),
			readableNameShort = _('Overcast 4 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_24.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 420.00,
			presetAltMax = 2520.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4200,
					tile = 2.576,
					shapeFactor = 0.000,
					density = 0.498,
					densityGrad = 1.200,
					coverage = 0.648,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6720,
					altitudeMax = 8820,
					tile = 3.280,
					shapeFactor = 0.000,
					density = 1.128,
					densityGrad = 1.300,
					coverage = 0.766,
					noiseFreq = 2.822,
					noiseBlur = 0.671,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 12180,
					altitudeMax = 13020,
					tile = 3.040,
					shapeFactor = 0.000,
					density = 0.992,
					densityGrad = 1.400,
					coverage = 0.615,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset25 =
		{
			visibleInGUI = true,
			readableName = '25 ##'.._('Three Layer Overcast \nMETAR: OVC LYR 12/14 22/25 40/42'),
			readableNameShort = _('Overcast 5 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_25.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 420.00,
			presetAltMax = 3360.00,
			layers = {
				{
					altitudeMin = 3360,
					altitudeMax = 5040,
					tile = 2.640,
					shapeFactor = 0.000,
					density = 0.660,
					densityGrad = 1.000,
					coverage = 0.868,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6720,
					altitudeMax = 7980,
					tile = 3.040,
					shapeFactor = 0.048,
					density = 1.114,
					densityGrad = 1.400,
					coverage = 0.919,
					noiseFreq = 2.978,
					noiseBlur = 1.161,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 12180,
					altitudeMax = 13440,
					tile = 4.272,
					shapeFactor = 0.000,
					density = 1.000,
					densityGrad = 1.300,
					coverage = 0.788,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset26 =
		{
			visibleInGUI = true,
			readableName = '26 ##'.._('Three Layer Overcast \nMETAR: OVC 9/15 BKN 23/25 SCT 32'),
			readableNameShort = _('Overcast 6 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_26.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 420.00,
			presetAltMax = 2940.00,
			layers = {
				{
					altitudeMin = 2940,
					altitudeMax = 5460,
					tile = 2.048,
					shapeFactor = 0.399,
					density = 0.960,
					densityGrad = 1.400,
					coverage = 0.897,
					noiseFreq = 3.000,
					noiseBlur = 1.101,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7140,
					altitudeMax = 8400,
					tile = 3.040,
					shapeFactor = 0.264,
					density = 0.920,
					densityGrad = 1.300,
					coverage = 0.564,
					noiseFreq = 1.992,
					noiseBlur = 1.039,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11340,
					tile = 0.992,
					shapeFactor = 0.147,
					density = 0.660,
					densityGrad = 1.300,
					coverage = 0.374,
					noiseFreq = 2.410,
					noiseBlur = 0.255,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset27 =
		{
			visibleInGUI = true,
			readableName = '27 ##'.._('Three Layer Overcast \nMETAR: OVC 8/15 SCT/BKN 25/26 34/36'),
			readableNameShort = _('Overcast 7 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_27.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 420.00,
			presetAltMax = 2520.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5880,
					tile = 5.984,
					shapeFactor = 0.388,
					density = 0.938,
					densityGrad = 1.194,
					coverage = 0.769,
					noiseFreq = 1.452,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7560,
					altitudeMax = 8820,
					tile = 3.872,
					shapeFactor = 0.000,
					density = 0.838,
					densityGrad = 1.300,
					coverage = 0.590,
					noiseFreq = 2.029,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10920,
					altitudeMax = 11760,
					tile = 2.112,
					shapeFactor = 0.000,
					density = 0.451,
					densityGrad = 1.000,
					coverage = 0.714,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		RainyPreset1 =
		{
			visibleInGUI = true,
			readableName = '28 ##'.._('Overcast with Rain \nMETAR: VIS 3-5KM RA OVC 3/15 28/30 FEW 40'),
			readableNameShort = _('Overcast And Rain 1 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_28.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 11000.00,
			precipitationPower = 0.30,
			presetAltMin = 420.00,
			presetAltMax = 2940.00,
			layers = {
				{
					altitudeMin = 2940,
					altitudeMax = 5880,
					tile = 3.104,
					shapeFactor = 0.315,
					density = 1.150,
					densityGrad = 1.400,
					coverage = 0.612,
					noiseFreq = 1.857,
					noiseBlur = 0.983,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8820,
					altitudeMax = 10500,
					tile = 4.336,
					shapeFactor = 0.000,
					density = 0.820,
					densityGrad = 1.300,
					coverage = 0.608,
					noiseFreq = 0.000,
					noiseBlur = 0.658,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 12180,
					altitudeMax = 13440,
					tile = 1.824,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.603,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		RainyPreset2 =
		{
			visibleInGUI = true,
			readableName = '29 ##'.._('Overcast with Rain \nMETAR: VIS 1-5KM RA BKN/OVC 3/11 SCT 18/29 FEW 40'),
			readableNameShort = _('Overcast And Rain 2 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_29.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.50,
			presetAltMin = 840.00,
			presetAltMax = 2520.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5040,
					tile = 9.440,
					shapeFactor = 0.253,
					density = 1.026,
					densityGrad = 1.300,
					coverage = 0.557,
					noiseFreq = 0.000,
					noiseBlur = 0.460,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6300,
					altitudeMax = 7560,
					tile = 3.568,
					shapeFactor = 0.264,
					density = 0.770,
					densityGrad = 1.200,
					coverage = 0.520,
					noiseFreq = 1.857,
					noiseBlur = 1.266,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10080,
					altitudeMax = 11340,
					tile = 2.688,
					shapeFactor = 0.000,
					density = 0.982,
					densityGrad = 1.200,
					coverage = 0.465,
					noiseFreq = 2.484,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		RainyPreset3 =
		{
			visibleInGUI = true,
			readableName = '30 ##'.._('Overcast with Rain \nMETAR: VIS 3-5KM RA OVC LYR 6/18 19/21 SCT 34'),
			readableNameShort = _('Overcast And Rain 3 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_30.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.60,
			presetAltMin = 840.00,
			presetAltMax = 2520.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5880,
					tile = 9.904,
					shapeFactor = 0.465,
					density = 0.770,
					densityGrad = 0.740,
					coverage = 0.557,
					noiseFreq = 0.000,
					noiseBlur = 0.460,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5880,
					altitudeMax = 8400,
					tile = 4.928,
					shapeFactor = 0.125,
					density = 0.902,
					densityGrad = 0.858,
					coverage = 0.725,
					noiseFreq = 2.406,
					noiseBlur = 0.520,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10080,
					altitudeMax = 11340,
					tile = 2.688,
					shapeFactor = 0.000,
					density = 0.982,
					densityGrad = 1.200,
					coverage = 0.465,
					noiseFreq = 2.484,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		RainyPreset4 =
		{
			visibleInGUI = true, -- new clouds with some rain 1
			readableName = '31 ##'.._('Two Layers Scattered Large Thick Clouds  \nMETAR: SCT/BKN 18/20 FEW36/38 FEW 40'),
			readableNameShort = _('Light Rain 1 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_31.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 9500.00, --
			precipitationPower = 0.55, --
			presetAltMin = 1260.00, --
			presetAltMax = 4200.00, --
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4620,
					tile = 9.200,
					shapeFactor = 0.106,
					density = 0.542,
					densityGrad = 1.000,
					coverage = 0.524,
					noiseFreq = 0.780,
					noiseBlur = 0.451,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6720,
					altitudeMax = 7980,
					tile = 7.744,
					shapeFactor = 0.084,
					density = 0.556,
					densityGrad = 1.000,
					coverage = 0.440,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.880,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		RainyPreset5 =
		{
			visibleInGUI = true, -- new clouds with some rain 2
			readableName = '32 ##'.._('Three Layers Broken/Overcast \nMETAR: BKN/OVC LYR 7/13 20/22 32/34'),
			readableNameShort = _('Light Rain 2 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_32.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.30,
			presetAltMin = 1260.00,
			presetAltMax = 2520.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4620,
					tile = 9.904,
					shapeFactor = 0.165,
					density = 0.696,
					densityGrad = 1.300,
					coverage = 0.557,
					noiseFreq = 0.000,
					noiseBlur = 0.460,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6300,
					altitudeMax = 7980,
					tile = 3.568,
					shapeFactor = 0.264,
					density = 0.770,
					densityGrad = 1.200,
					coverage = 0.458,
					noiseFreq = 1.857,
					noiseBlur = 1.266,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10080,
					altitudeMax = 11340,
					tile = 2.224,
					shapeFactor = 0.000,
					density = 0.982,
					densityGrad = 1.200,
					coverage = 0.535,
					noiseFreq = 2.484,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		RainyPreset6 =
		{
			visibleInGUI = true, -- new clouds with some rain 3
			readableName = '33 ##'.._('Three Layers Overcast At Low Level \nMETAR: OVC 9/16 BKN/OVC LYR 23/24 31/33'),
			readableNameShort = _('Light Rain 3 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_33.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.40,
			presetAltMin = 1260.00,
			presetAltMax = 2940.00,
			layers = {
				{
					altitudeMin = 2940,
					altitudeMax = 5040,
					tile = 4.599,
					shapeFactor = 0.98,
					density = 0.850,
					densityGrad = 1.250,
					coverage = 0.626,
					noiseFreq = 2.567,
					noiseBlur = 0.250,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7140,
					altitudeMax = 8400,
					tile = 3.040,
					shapeFactor = 0.077,
					density = 0.850,
					densityGrad = 1.200,
					coverage = 0.564,
					noiseFreq = 3.000,
					noiseBlur = 1.019,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11340,
					tile = 0.992,
					shapeFactor = 0.147,
					density = 0.710,
					densityGrad = 1.400,
					coverage = 0.392,
					noiseFreq = 3.000,
					noiseBlur = 0.250,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		NEWRAINPRESET4 =
		{
			visibleInGUI = true, -- new clouds with some rain 4 by GA
			readableName = '34 ##'.._('Two Layers Overcast At Low Level \nMETAR: --'),
			readableNameShort = _('Light Rain 4 [ED]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cloud_34.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.70,
			presetAltMin = 840.00,
			presetAltMax = 5174.40,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 3780,
					tile = 0.992,
					shapeFactor = 0.086,
					density = 0.468,
					densityGrad = 0.316,
					coverage = 0.499,
					noiseFreq = 2.925,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3780,
					altitudeMax = 5460,
					tile = 5.984,
					shapeFactor = 0.000,
					density = 0.880,
					densityGrad = 1.000,
					coverage = 0.630,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 12180,
					altitudeMax = 13440,
					tile = 2.224,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.603,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset35 =
		{
			--ATX_METAR RA SCT030 SCT180 BKN240
			visibleInGUI = true,
			readableName = '35 ##'.._('Scattered Showers \nMETAR: RA SCT SCT BKN'), 
			readableNameShort = _('Scattered Showers 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/ScatteredShowers1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.3,
			presetAltMin = 200.00,
			presetAltMax = 7000.00,
			layers = {
				{
					altitudeMin = 1360,
					altitudeMax = 3540,
					tile = 22.000,
					shapeFactor = 0.05,
					density = 0.934,
					densityGrad = 1.240,
					coverage = 0.528,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6000,
					altitudeMax = 7500, --12130
					tile = 2.521, --2.521
					shapeFactor = 0.014, --0.210
					density = 0.510, --0.510
					densityGrad = 0.500, --1.000
					coverage = 0.500, --0.478
					noiseFreq = 1.000, --0.000
					noiseBlur = 8.850,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 9240, --12130
					tile = 0.895, --0.184
					shapeFactor = 0.00, --0.210
					density = 0.321, --0.310
					densityGrad = 0.350,
					coverage = 0.918, --0.778
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset36 =
		{
			--ATX_METAR RA SCT010 SCT120 BKN240
			visibleInGUI = true,
			readableName = '36 ##'.. _('Scattered Showers \nMETAR: RA SCT SCT BKN'),
			readableNameShort = _('Scattered Showers 2 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/ScatteredShowers2.png',
			levelMap = 'bazar/effects/clouds/cloudsTiled.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.3,
			presetAltMin = 200.00,
			presetAltMax = 14000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5040,
					tile = 4.541, --9.440
					shapeFactor = 0.253,
					density = 0.526,
					densityGrad = 0.300,
					coverage = 0.585,
					noiseFreq = 3.456, --0.000
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6000,
					altitudeMax = 7100, --12130
					tile = 2.521, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.510, --0.510
					densityGrad = 2.000, --1.000
					coverage = 0.500, --0.478
					noiseFreq = 1.000, --0.000
					noiseBlur = 8.850,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8840, --12130
					tile = 0.895, --0.184
					shapeFactor = 0.250, --0.210
					density = 0.321, --0.310
					densityGrad = 0.350,
					coverage = 0.918, --0.778
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset37 =
		{
			--ATX_METAR RA SCT010 SCT100 BKN280
			visibleInGUI = true,
			readableName = '37 ##'.._('Scattered Showers  \nMETAR: RA SCT BKN '),
			readableNameShort = _('Scattered Showers 3 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/ScatteredShowers3.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12000.00,
			precipitationPower = 0.6,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4620,
					tile = 9.200,
					shapeFactor = 0.106,
					density = 0.760,
					densityGrad = 0.740,
					coverage = 0.480,
					noiseFreq = 0.700,
					noiseBlur = 0.451,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5620,
					altitudeMax = 6800, --10300
					tile = 2.424,
					shapeFactor = 0.210, --0.210
					density = 0.335, --0.320
					densityGrad = 1.350,
					coverage = 0.680,
					noiseFreq = 1.857,
					noiseBlur = 1.266,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.00,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset38 =
		{
			--ATX_METAR RA BKN020 SCT140 OVC240
			visibleInGUI = true,
			readableName = '38 ##'.._('Scattered Showers \nMETAR: RA SCT BKN'),
			readableNameShort = _('Scattered Showers 4 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/ScatteredShowers4.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.3,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4200,
					tile = 2.528,
					shapeFactor = 0.066,
					density = 0.468,
					densityGrad = 0.316,
					coverage = 0.648,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6500, --8500
					altitudeMax = 7600, --9600
					tile = 2.521, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.510, --0.510
					densityGrad = 2.000, --1.000
					coverage = 0.500, --0.478
					noiseFreq = 1.000, --0.000
					noiseBlur = 8.850,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000, --10000
					altitudeMax = 8840, --10840
					tile = 0.824, --0.184
					shapeFactor = 0.215, --0.210
					density = 0.321, --0.310
					densityGrad = 0.350,
					coverage = 0.988, --0.778
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset39 =
		{
			--ATX_METAR RA SCT030 SCT180 BKN240
			visibleInGUI = true,
			readableName = '39 ##'.._('Scattered Showers  \nMETAR: RA SCT BKN BKN'),
			readableNameShort = _('Scattered Showers 5 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/ScatteredShowers5.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12000.00, --16000*
			precipitationPower = 0.4,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 1200,
					altitudeMax = 4500, --4500*
					tile = 3.200, --7.200*
					shapeFactor = 0.306, --2.106
					density = 0.922, --0.822*
					densityGrad = 1.000, --0.500*
					coverage = 0.554, --0.554*
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 4900,
					altitudeMax = 6500, --12130
					tile = 2.521, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.510, --0.510
					densityGrad = 2.000, --1.000
					coverage = 0.530, --0.478
					noiseFreq = 1.000, --0.000
					noiseBlur = 8.850,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8840, --12130
					tile = 0.895, --0.184
					shapeFactor = 0.250, --0.210
					density = 0.321, --0.310
					densityGrad = 0.350,
					coverage = 0.918, --0.778
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset40 =
		{
			--ATX_METAR RA BKN008 BKN080
			visibleInGUI = true,
			readableName = '40 ##'.._('Low clounds w/Scattered Showers'),
			readableNameShort = _('Scattered Showers 6 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/overcastcumulus.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.10,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 609,
					altitudeMax = 1909,
					tile = 0.324,
					shapeFactor = 0.000, --0.210
					density = 0.355,
					densityGrad = 0.000,
					coverage = 0.595, -- 0.495 --0.895 
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 1320,
					altitudeMax = 3420,
					tile = 9.200,
					shapeFactor = 0.00,
					density = 0.325,
					densityGrad = 0.000,
					coverage = 0.514,
					noiseFreq = 0.780,
					noiseBlur = 0.451,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6000,
					altitudeMax = 7300,
					tile = 0.000,
					shapeFactor = 0.450, --0.210
					density = 0.000,
					densityGrad = 0.350,
					coverage = 0.000, --0.895
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset41 =
		{
			--ATX_METAR -RA BKN015 SCT200
			visibleInGUI = true,
			readableName = '41 ##'.._('Overcast light rain \nMETAR: -RA BKN BKN'),
			readableNameShort = _('Overcast Light Rain 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/OvercastRain1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.1,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4620,
					tile = 9.200,
					shapeFactor = 0.106,
					density = 0.642,
					densityGrad = 1.000,
					coverage = 0.654,
					noiseFreq = 0.780,
					noiseBlur = 0.451,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 9200,
					altitudeMax = 10200, --10300
					tile = 0.424,
					shapeFactor = 0.219, --0.210
					density = 0.360, --0.310
					densityGrad = 0.350,
					coverage = 0.541, --0.617 --looks GREAT
					noiseFreq = 6.000, --3.000
					noiseBlur = 4.159,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8300,
					tile = 0.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset42 =
		{
			--ATX_METAR -RA OVC008 BKN200
			visibleInGUI = true,
			readableName = '42 ##'.._('Overcast light rain \nMETAR: RA OVC BKN'),
			readableNameShort = _('Overcast Light Rain 2 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/OvercastRain2.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.1,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 3360,
					altitudeMax = 5040,
					tile = 2.640,
					shapeFactor = 0.000,
					density = 0.660,
					densityGrad = 1.000,
					coverage = 0.868,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7200,
					altitudeMax = 8200, --10300
					tile = 0.000,
					shapeFactor = 0.000, --0.210
					density = 0.000, --0.310
					densityGrad = 0.000,
					coverage = 0.000, --0.617 
					noiseFreq = 3.000, --3.000
					noiseBlur = 4.159,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7200,
					altitudeMax = 8200, --10300
					tile = 0.424,
					shapeFactor = 0.219, --0.210
					density = 0.360, --0.310
					densityGrad = 0.350,
					coverage = 0.591, --0.617 --looks GREAT
					noiseFreq = 3.000, --3.000
					noiseBlur = 4.159,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset43 =
		{
			--ATX_METAR +RA OVC030 BKN150 OVC280
			visibleInGUI = true,
			readableName = '43 ##'.._('Overcast with Rain \nMETAR: RA OVC BKN OVC'),
			readableNameShort = _('Overcast And Moderate Rain 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/OvercastRain3.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = 0.8,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 300,
					altitudeMax = 3460,
					tile = 12.000, --6.004
					shapeFactor = 2.100, --1.500
					density = 0.850,
					densityGrad = 0.440,
					coverage = 0.657,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5000,
					altitudeMax = 5900,
					tile = 2.000,
					shapeFactor = 0.910, --0.210
					density = 0.515, --0.315
					densityGrad = 2.350, --0.350
					coverage = 0.610,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 9500,
					altitudeMax = 10240, --12130
					tile = 0.824, --0.184
					shapeFactor = 0.215, --0.210
					density = 0.321, --0.310
					densityGrad = 0.350,
					coverage = 0.988, --0.778
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset44 =
		{
			--ATX_METAR SCT020
			visibleInGUI = true,
			readableName = '44 ##'.._('One Layer Scattered \nMETAR: FEW/SCT '),
			readableNameShort = _('Scattered Cumulus 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cumulus1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 8450.00,
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5750,
					tile = 22.032,
					shapeFactor = 0.000,
					density = 0.680, --0.630
					densityGrad = 1.500, --1.5
					coverage = 0.743,
					noiseFreq = 2.200,
					noiseBlur = 1.219,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7560,
					altitudeMax = 8561,
					tile = 0.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 1.400,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10920,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset45 =
		{
			--ATX_METAR SCT060
			visibleInGUI = true,
			readableName = '45 ##'.._('One Layer Scattered \nMETAR: SCT 6/10'),
			readableNameShort = _('Scattered Cumulus 2 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cumulus2.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10750.00,
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 15000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5750,
					tile = 22.032,
					shapeFactor = 0.000,
					density = 0.670, --0.590
					densityGrad = 4.200, --1.200
					coverage = 0.759,
					noiseFreq = 2.200,
					noiseBlur = 1.189,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7560,
					altitudeMax = 8561,
					tile = 0.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 1.400,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10840, --12130
					tile = 0.000, --0.184
					shapeFactor = 0.000, --0.210
					density = 0.000, --0.310
					densityGrad = 1.000,
					coverage = 0.000, --0.778
					noiseFreq = 0.000,
					noiseBlur = 0.850, --0.050
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset46 =
		{
			--ATX_METAR SCT060
			visibleInGUI = true,
			readableName = '46 ##'.._('Two Layer Scattered \nMETAR: SCT SCT'),
			readableNameShort = _('Scattered Cumulus 3 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cumulus3.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 8350.00,
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5750,
					tile = 22.032,
					shapeFactor = 0.000,
					density = 0.637,
					densityGrad = 1.200,
					coverage = 0.782,
					noiseFreq = 2.200,
					noiseBlur = 1.190,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3880,
					altitudeMax = 5080,
					tile = 0.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 1.200,
					coverage = 0.000,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6000,
					altitudeMax = 7200,
					tile = 0.532, --0.832
					shapeFactor = 0.624,
					density = 0.522,
					densityGrad = 1.200,
					coverage = 0.728, --0.625
					noiseFreq = 3.162, --1.188
					noiseBlur = 1.472, --4.414 *looks GREAT
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.71,
					coverageMapUVOffsetY = 0.23,
				},
			}
		},
		
		Preset47 =
		{
			--ATX_METAR SCT030 SCT120
			visibleInGUI = true,
			readableName = '47 ##'.._('Two Layer Scattered \nMETAR: SCT SCT'),
			readableNameShort = _('Scattered Cumulus 4 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cumulus4.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 11300.00,
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 3850,
					tile = 22.032,
					shapeFactor = 0.000,
					density = 0.637,
					densityGrad = 1.200,
					coverage = 0.797,
					noiseFreq = 2.200,
					noiseBlur = 1.293,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 4000,
					altitudeMax = 6500,
					tile = 1.750,
					shapeFactor = 0.000,
					density = 0.601,
					densityGrad = 1.200,
					coverage = 0.736,
					noiseFreq = 2.200,
					noiseBlur = 1.152,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.37,
					coverageMapUVOffsetY = 0.61,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10300,
					tile = 2.000,
					shapeFactor = 0.210,
					density = 0.000,
					densityGrad = 0.350,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
			
		Preset48 =
		{
			--ATX_METAR SCT010 BKN150 OVC280
			visibleInGUI = true,
			readableName = '48 ##'.._('Three Layer Scattered \nMETAR: SCT BKN OVC'),
			readableNameShort = _('Scattered Cumulus 5 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cumulus5.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 8800.00,
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 15000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4850,
					tile = 22.032,
					shapeFactor = 0.000,
					density = 0.664,
					densityGrad = 1.200,
					coverage = 0.874,
					noiseFreq = 2.200,
					noiseBlur = 1.117,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5000, --7000
					altitudeMax = 6500, --8500
					tile = 0.724,
					shapeFactor = 0.000, --0.210
					density = 0.495, --0.610
					densityGrad = 3.750, --0.750
					coverage = 0.969, --0.462
					noiseFreq = 3.077,
					noiseBlur = 1.631,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.37,
					coverageMapUVOffsetY = 0.61,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10400,
					tile = 0.424,
					shapeFactor = 0.000,
					density = 0.386, --0.390
					densityGrad = 1.200,
					coverage = 0.828,
					noiseFreq = 2.200,
					noiseBlur = 1.264,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset49=
		{
			--ATX_METAR -RA OVC010 FEW170
			visibleInGUI = true,
			readableName = '49 ##'.._('Overcast Light Rain \nMETAR: -RA OVC FEW'),
			readableNameShort = _('Overcast Cumulus Light Mist [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/overcastcumulus.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 15000.00,
			precipitationPower = 0.04,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 1520,
					altitudeMax = 4840,
					tile = 16, --22.032
					shapeFactor = 0.158,
					density = 0.999,
					densityGrad = 1.200,
					coverage = 0.797,
					noiseFreq = 0.800,
					noiseBlur = 1.113,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.13,
					coverageMapUVOffsetY = 0.89,
				},
				{
					altitudeMin = 5400,
					altitudeMax = 6500,
					tile = 3.000,
					shapeFactor = 0.210,
					density = 0.356,
					densityGrad = 0.000,
					coverage = 0.690,
					noiseFreq = 0.800,
					noiseBlur = 1.319,
					coverageMapFactor = 1.00,
					coverageMapUVOffsetX = 0.53,
					coverageMapUVOffsetY = 0.47,
				},
				{
					altitudeMin = 7500,
					altitudeMax = 8600, --12130
					tile = 0.950, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.451, --0.510
					densityGrad = 0.025, --1.000
					coverage = 0.523, --0.778
					noiseFreq = 0.800, --0.000
					noiseBlur = 1.091, --0.850
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset50 =
		{
			--ATX_METAR SCT008
			visibleInGUI = true,
			readableName = '50 ##'.._('Single layer stratus \nMETAR: BKN'),
			readableNameShort = _('Low level stratus 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/stratus1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00, --10000
			precipitationPower = -1.00,
			presetAltMin = 0.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2000,
					altitudeMax = 3200,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.470,
					densityGrad = 0.350,
					coverage = 0.450,
					noiseFreq = 0.030,
					noiseBlur = 0.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3260,
					altitudeMax = 4561,
					tile = 2.112,
					shapeFactor = 0.000,
					density = 0.510, --0.410
					densityGrad = 1.000,
					coverage = 0.514,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10920,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset51 =
		{
			--ATX_METAR BKN015
			visibleInGUI = true,
			readableName = '51 ##'.._('Single layer stratus \nMETAR: BKN'),
			readableNameShort = _('Low level stratus 2 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/stratus2.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00, --10000
			precipitationPower = -1.00,
			presetAltMin = 0.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2000,
					altitudeMax = 3200,
					tile = 2.000,
					shapeFactor = 0.500,
					density = 0.470,
					densityGrad = 0.350,
					coverage = 0.580,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3260,
					altitudeMax = 4561,
					tile = 2.112,
					shapeFactor = 0.000,
					density = 0.610, --0.410
					densityGrad = 1.000,
					coverage = 0.614,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10920,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset52 =
		{
			--ATX_METAR BKN020
			visibleInGUI = true,
			readableName = '52 ##'.._('Single layer stratus \nMETAR: BKN'),
			readableNameShort = _('Low level stratus 3 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/stratus3.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00, --10000
			precipitationPower = -1.00,
			presetAltMin = 0.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2000,
					altitudeMax = 3200,
					tile = 2.000,
					shapeFactor = 2.500,
					density = 0.470,
					densityGrad = 0.350,
					coverage = 0.680,
					noiseFreq = 3.000,
					noiseBlur = 3.599,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3260,
					altitudeMax = 4561,
					tile = 2.112,
					shapeFactor = 0.000,
					density = 0.610, --0.410
					densityGrad = 1.000,
					coverage = 0.714,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10920,
					altitudeMax = 12760, --11760
					tile = 2.112,
					shapeFactor = 0.000,
					density = 0.610, --0.410
					densityGrad = 1.000,
					coverage = 0.000,
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset53 =
		{
			--ATX_METAR BKN030
			visibleInGUI = true,
			readableName = '53 ##'.._('Single layer stratus \nMETAR: BKN'),
			readableNameShort = _('Low level stratus 4 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/stratus4.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00, --8000.00
			precipitationPower = -1.00,
			presetAltMin = 0.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2000,
					altitudeMax = 3600,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.470,
					densityGrad = 0.350,
					coverage = 0.780,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 2220,
					altitudeMax = 4280,
					tile = 18.032,
					shapeFactor = 2.500,
					density = 0.000,
					densityGrad = 1.200,
					coverage = 0.000,
					noiseFreq = 2.188,
					noiseBlur = 1.200,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10920,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset54 =
		{
			--ATX_METAR BKN020 SCT150
			visibleInGUI = true,
			readableName = '54 ##'.._('Low stratus with broken clouds \nMETAR: BKN SCT'),
			readableNameShort = _('Low level stratus 5 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/stratus5.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12500.00, --8500*
			precipitationPower = -1.00,
			presetAltMin = 0.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 800, --1100
					altitudeMax = 3580,
					tile = 18.032, --22.032
					shapeFactor = 2.100,
					density = 0.415, --0.615
					densityGrad = 1.800,
					coverage = 0.645,
					noiseFreq = 3.000, --2.188
					noiseBlur = 6.200,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 1300, --1100
					altitudeMax = 4080,
					tile = 0.000, --22.032
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 3.000, --2.188
					noiseBlur = 6.200,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5000, --7000
					altitudeMax = 6500, --8500
					tile = 0.724,
					shapeFactor = 0.000, --0.210
					density = 0.495, --0.610
					densityGrad = 0.750, --0.750
					coverage = 0.532, --0.462
					noiseFreq = 2.106,
					noiseBlur = 1.631,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset55 =
		{
			--ATX_METAR BKN020 BKN040
			visibleInGUI = true,
			readableName = '55 ##'.._('Low level stratus with big puffy cumulus \nMETAR: BKN BKN'),
			readableNameShort = _('Low level stratus 6 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/stratus6.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 609,
					altitudeMax = 1909,
					tile = 0.324,
					shapeFactor = 0.000, --0.210
					density = 0.355,
					densityGrad = 0.000,
					coverage = 0.595, -- 0.495 --0.895 
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 1320,
					altitudeMax = 3420,
					tile = 9.200,
					shapeFactor = 0.00,
					density = 0.325,
					densityGrad = 0.000,
					coverage = 0.514,
					noiseFreq = 0.780,
					noiseBlur = 0.451,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6000,
					altitudeMax = 7300,
					tile = 0.000,
					shapeFactor = 0.450, --0.210
					density = 0.000,
					densityGrad = 0.350,
					coverage = 0.000, --0.895
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset56 =
		{
			--ATX_METAR BKN010 SCT030
			visibleInGUI = true,
			readableName = '56 ##'.._('Low level stratus with light scattered cumulus \nMETAR: BKN SCT'),
			readableNameShort = _('Low level stratus 7 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/stratus7.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 609,
					altitudeMax = 1909,
					tile = 0.324,
					shapeFactor = 0.450, --0.210
					density = 0.418,
					densityGrad = 0.350,
					coverage = 0.525, -- 0.495 --0.895 
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 1305,
					altitudeMax = 3480,
					tile = 2.528,
					shapeFactor = 0.066,
					density = 0.400,
					densityGrad = 0.316,
					coverage = 0.408,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6000,
					altitudeMax = 7300,
					tile = 0.000,
					shapeFactor = 0.450, --0.210
					density = 0.000,
					densityGrad = 0.350,
					coverage = 0.000, --0.895
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		
		
		
		Preset57 =
		{
			--ATX_METAR SCT120
			visibleInGUI = true,
			readableName = '57 ##'.._('Mid level Altostratus \nMETAR: SCT'),
			readableNameShort = _('Altotratus 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/altostratus1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12500.00,
			precipitationPower = -1.00,
			presetAltMin = 2000.00,
			presetAltMax = 6096.00,
			layers = {
				{
					altitudeMin = 0,
					altitudeMax = 300,
					tile = 0.000,
					shapeFactor = 0.210,
					density = 0.000,
					densityGrad = 8.350,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 4000,
					altitudeMax = 5800,
					tile = 1.424, --5.124
					shapeFactor = 0.510,
					density = 0.385,
					densityGrad = 0.000, --8.350
					coverage = 0.480, --0.820
					noiseFreq = 2.072, --2.000
					noiseBlur = 0.814, --0.799
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10920,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
	    Preset58 =
		{
			--ATX_METAR BKN120
			visibleInGUI = true,
			readableName = '58 ##'.._('Altostratus Scattered \nMETAR: BKN'),
			readableNameShort = _('Altostratus 2 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/altostratus2.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00, --10000
			precipitationPower = -1.00,
			presetAltMin = 1828.00,
			presetAltMax = 6096.00,
			layers = {
				{
					altitudeMin = 0,
					altitudeMax = 300,
					tile = 1.625,
					shapeFactor = 0.210,
					density = 0.000,
					densityGrad = 0.350,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 4000,
					altitudeMax = 5500,
					tile = 1.825,
					shapeFactor = 0.00, --0.210
					density = 0.352,
					densityGrad = 0.000, --0.350
					coverage = 0.720,
					noiseFreq = 1.054,
					noiseBlur = 1.122,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10700,
					tile = 0.000,
					shapeFactor = 0.000, --0.210
					density = 0.000,
					densityGrad = 0.000, --0.350
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset59 =
		{
			--ATX_METAR BKN120 SCT140
			visibleInGUI = true,
			readableName = '59 ##'.._('Altostratus Scattered \nMETAR: BKN/SCT'),
			readableNameShort = _('Altostratus 3 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/altostratus3.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00, --10000
			precipitationPower = -1.00,
			presetAltMin = 1828.00,
			presetAltMax = 6096.00,
			layers = {
				{
					altitudeMin = 2500,
					altitudeMax = 3500,
					tile = 1.825,
					shapeFactor = 0.110, --0.210
					density = 0.780,
					densityGrad = 3.350, --0.350
					coverage = 0.670,
					noiseFreq = 2.000,
					noiseBlur = 0.799,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 4000,
					altitudeMax = 5500,
					tile = 1.825,
					shapeFactor = 0.110, --0.210
					density = 0.858,
					densityGrad = 3.350, --0.350
					coverage = 0.520,
					noiseFreq = 2.626,
					noiseBlur = 0.814,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10700,
					tile = 0.000,
					shapeFactor = 0.000, --0.210
					density = 0.000,
					densityGrad = 0.000, --0.350
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset60 =
		{
			--ATX_METAR BKN080 BKN140 OVC26
			visibleInGUI = true,
			readableName = '60 ##'.._('Altostratus Broken \nMETAR: OVC/BKN'),
			readableNameShort = _('Altostratus 4 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/altostratus4.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 1828.00,
			presetAltMax = 6096.00,
			layers =
				{
				{
					altitudeMin = 2286,
					altitudeMax = 3200,
					tile = 1.500,
					shapeFactor = 0.000,
					density = 0.700,
					densityGrad = 2.855,
					coverage = 0.70,
					noiseFreq = 20.00,
					noiseBlur = 11.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5486,
					altitudeMax = 6522,
					tile = 1.500,
					shapeFactor = 0.000,
					density = 0.495,
					densityGrad = 2.855,
					coverage = 0.70,
					noiseFreq = 2.317,
					noiseBlur = 1.324,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7315,
					altitudeMax = 8077,
					tile = 0.450,
					shapeFactor = 0.000,
					density = 0.352,
					densityGrad = 0.000,
					coverage = 0.70,
					noiseFreq = 0.300,
					noiseBlur = 1.071,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		
		Preset61 =
		{
			--ATX_METAR SCT070
			visibleInGUI = true,
			readableName = '61 ##'.._('Altocumulus scattered \nMETAR: SCT'),
			readableNameShort = _('Altocumulus 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/altocumulus1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 2000.00,
			presetAltMax = 7620.00,
			layers = {
				{
					altitudeMin = 300,
					altitudeMax = 2260,
					tile = 0.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.125,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3700,
					altitudeMax = 4800, --12130
					tile = 2.521, --2.000
					shapeFactor = 0.024, --0.210
					density = 0.810, --0.510
					densityGrad = 1.000, --1.000
					coverage = 0.478, --0.778
					noiseFreq = 1.000, --0.000
					noiseBlur = 2.850, --0.850
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8940, --12130
					tile = 0.824, --0.184
					shapeFactor = 0.215, --0.210
					density = 0.391, --0.310
					densityGrad = 0.450,
					coverage = 0.000, --0.778
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
			
		Preset62 =
		{
			--ATX_METAR SCT080
			visibleInGUI = true,
			readableName = '62 ##'.._('Mid Level Altocumulus Few \nMETAR: SCT'),
			readableNameShort = _('Altocumulus 2 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/altocumulus2.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 2000.00,
			presetAltMax = 7620.00,
			layers = {
				{
					altitudeMin = 2500, --10000
					altitudeMax = 4000, --10900
					tile = 0.000, --0.232
					shapeFactor = 0.125, --0.000
					density = 0.000, --0.410
					densityGrad = 0.600, --0.200
					coverage = 0.000, --0.375
					noiseFreq = 2.088, --2.088
					noiseBlur = 0.500, --1.500
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3700,
					altitudeMax = 4800, --12130
					tile = 0.721, --2.000
					shapeFactor = 0.000, --0.210
					density = 0.610, --0.510
					densityGrad = 1.000, --1.000
					coverage = 0.525, --0.778
					noiseFreq = 12.000, --0.000
					noiseBlur = 6.150, --0.850
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11500, --12130
					tile = 2.000, --0.184
					shapeFactor = 0.034, --0.210
					density = 0.480, --0.310
					densityGrad = 1.000,
					coverage = 0.000, --0.778
					noiseFreq = 0.000,
					noiseBlur = 0.850, --0.050
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		
		Preset63 =
		{
			--ATX_METAR BKN080
			visibleInGUI = true,
			readableName = '63 ##'.._('Altocumulus broken \nMETAR: OVC/BKN'),
			readableNameShort = _('Altocumulus 3 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/altocumulus3.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 2000.00,
			presetAltMax = 7620.00,
			layers = {
				{
					altitudeMin = 2500, --10000
					altitudeMax = 4000, --10900
					tile = 0.000, --0.232
					shapeFactor = 0.125, --0.000
					density = 0.000, --0.410
					densityGrad = 0.600, --0.200
					coverage = 0.000, --0.375
					noiseFreq = 2.088, --2.088
					noiseBlur = 0.500, --1.500
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3700,
					altitudeMax = 4800, --12130
					tile = 0.721, --2.000
					shapeFactor = 0.000, --0.210
					density = 0.610, --0.510
					densityGrad = 1.000, --1.000
					coverage = 0.675, --0.778
					noiseFreq = 12.000, --0.000
					noiseBlur = 6.150, --0.850
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11500, --12130
					tile = 2.000, --0.184
					shapeFactor = 0.034, --0.210
					density = 0.480, --0.310
					densityGrad = 1.000,
					coverage = 0.000, --0.778
					noiseFreq = 0.000,
					noiseBlur = 0.850, --0.050
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset64 =
		{
			--ATX_METAR OVC080
			visibleInGUI = true,
			readableName = '64 ##'.._('Altocumulus broken \nMETAR: OVC/BKN'),
			readableNameShort = _('Altocumulus 4 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/altocumulus4.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 2000.00,
			presetAltMax = 7620.00,
			layers = {
				{
					altitudeMin = 2500, --10000
					altitudeMax = 4000, --10900
					tile = 0.000, --0.232
					shapeFactor = 0.125, --0.000
					density = 0.000, --0.410
					densityGrad = 0.600, --0.200
					coverage = 0.000, --0.375
					noiseFreq = 2.088, --2.088
					noiseBlur = 0.500, --1.500
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3700,
					altitudeMax = 4800, --12130
					tile = 0.221, --2.000
					shapeFactor = 0.000, --0.210
					density = 0.610, --0.510
					densityGrad = 1.000, --1.000
					coverage = 0.575, --0.778
					noiseFreq = 12.000, --0.000
					noiseBlur = 6.150, --0.850
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11500, --12130
					tile = 2.000, --0.184
					shapeFactor = 0.034, --0.210
					density = 0.480, --0.310
					densityGrad = 1.000,
					coverage = 0.000, --0.778
					noiseFreq = 0.000,
					noiseBlur = 0.850, --0.050
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset65 =
		{
			--ATX_METAR +RA OVC010 BKN180
			visibleInGUI = true,
			readableName = '65 ##'.._('Heavy rain with thick overcast cloud layer \nMETAR: RA OVC BKN'),
			readableNameShort = _('Nimbostratus with heavy rain [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/nimbostratus1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00, --10000
			precipitationPower = 0.8,
			presetAltMin = 609.00,
			presetAltMax = 6096.00,
			layers = {
				{
					altitudeMin = 400,
					altitudeMax = 4380, --5280
					tile = 25.942, --35.942
					shapeFactor = 4.000, --2.100***
					density = 0.905, --0.925***
					densityGrad = 1.000, --1.000***
					coverage = 0.685, --0.715
					noiseFreq = 1.000, --0.000***
					noiseBlur = 1.500, --4.200
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6480, --7000
					altitudeMax = 7880, --8500
					tile = 0.000,
					shapeFactor = 0.000, --0.210
					density = 0.000, --0.610
					densityGrad = 0.000, --0.750
					coverage = 0.000, --0.462
					noiseFreq = 3.000,
					noiseBlur = 1.631,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6480, --7000
					altitudeMax = 7880, --8500
					tile = 0.724,
					shapeFactor = 0.000, --0.210
					density = 0.450, --0.610
					densityGrad = 1.000, --3.750
					coverage = 0.632, --0.462
					noiseFreq = 3.000,
					noiseBlur = 1.631,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset66=
		{
			--ATX_METAR FEW200
			visibleInGUI = true,
			readableName = '66 ##'.._('High level cirrocumulus clouds \nMETAR: SCT/BKN'),
			readableNameShort = _('Cirrocumulus 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cirrocumulus1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00, --12500
			precipitationPower = -1.00,
			presetAltMin = 5000.00,
			presetAltMax = 18288.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5880,
					tile = 5.984,
					shapeFactor = 0.388,
					density = 0.000,
					densityGrad = 1.194,
					coverage = 0.000,
					noiseFreq = 1.452,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7560,
					altitudeMax = 8820,
					tile = 3.872,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 1.300,
					coverage = 0.000,
					noiseFreq = 1.614,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11500, --12130
					tile = 10, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.510, --0.510
					densityGrad = 2.000, --1.000
					coverage = 0.478, --0.778
					noiseFreq = 2.088, --0.000
					noiseBlur = 2.850, --0.850
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
							
				},
			}
		},
		
		Preset67 =
		{
			--ATX_METAR SCT200
			visibleInGUI = true,
			readableName = '67 ##'.._('High level cirrocumulus clouds \nMETAR: SCT/BKN'),
			readableNameShort = _('Cirrocumulus 2 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cirrocumulus2.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00, --10000
			precipitationPower = -1.00,
			presetAltMin = 5000.00,
			presetAltMax = 18288.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 3880,
					tile = 5.984,
					shapeFactor = 0.388,
					density = 0.000,
					densityGrad = 1.194,
					coverage = 0.000,
					noiseFreq = 1.452,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 7560,
					altitudeMax = 8820,
					tile = 3.872,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 1.300,
					coverage = 0.000,
					noiseFreq = 1.614,
					noiseBlur = 0.025,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11500, --12130
					tile = 2.521, --2.000
					shapeFactor = 0.024, --0.210
					density = 0.561, --0.510
					densityGrad = 2.000, --1.000
					coverage = 0.565, --0.778
					noiseFreq = 1.169, --0.000
					noiseBlur = 2.850, --0.850
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset68 =
		{
			--ATX_METAR BKN200
			visibleInGUI = true,
			readableName = '68 ##'.._('High level cirrocumulus scattered \nMETAR: SCT'),
			readableNameShort = _('Cirrocumulus 3 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cirrocumulus3.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 8500.00,
			precipitationPower = -1.00,
			presetAltMin = 5000.00,
			presetAltMax = 18288.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 3780,
					tile = 0.000,
					shapeFactor = 0.000,
					density = 0.000, --0.590
					densityGrad = 4.200, --1.200
					coverage = 0.000,
					noiseFreq = 2.088,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8500,
					altitudeMax = 9600, --12130
					tile = 2.521, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.561, --0.510
					densityGrad = 0.200, --1.000
					coverage = 0.500, --0.478
					noiseFreq = 1.338, --0.000
					noiseBlur = 0.867,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11500, --12130
					tile = 2.521, --2.000
					shapeFactor = 0.024, --0.210
					density = 0.561, --0.510
					densityGrad = 2.000, --1.000
					coverage = 0.625, --0.778
					noiseFreq = 1.479, --0.000
					noiseBlur = 2.850, --0.850
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset69 =
		{
			--ATX_METAR FEW250
			visibleInGUI = true,
			readableName = '69 ##'.._('High level cirrostratus clouds \nMETAR: FEW'),
			readableNameShort = _('Cirrostratus 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cirrostratus1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 5000.00,
			presetAltMax = 12192.00,
			layers = {
				{
					altitudeMin = 6096,
					altitudeMax = 7196,
					tile = 0.000,
					shapeFactor = 0.000,
					density = 0.00,
					densityGrad = 0.00,
					coverage = 0.000,
					noiseFreq = 1.100,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8500,
					altitudeMax = 9600, --12130
					tile = 0.000, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.000, --0.510
					densityGrad = 0.000, --1.000
					coverage = 0.000, --0.478
					noiseFreq = 1.000, --0.000
					noiseBlur = 0.850,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11000,
					tile = 1.450,
					shapeFactor = 1.650,
					density = 0.385,
					densityGrad = 0.00,
					coverage = 0.450,
					noiseFreq = 0.991,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset70 =
		{
			--ATX_METAR SCT250
			visibleInGUI = true,
			readableName = '70 ##'.._('High level cirrostratus overcast \nMETAR: SCT'),
			readableNameShort = _('Cirrostratus 2 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cirrostratus2.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 5000.00,
			presetAltMax = 12192.00,
			layers = {
				{
					altitudeMin = 6096,
					altitudeMax = 7196,
					tile = 0.000,
					shapeFactor = 0.000,
					density = 0.00,
					densityGrad = 0.00,
					coverage = 0.000,
					noiseFreq = 1.100,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8500,
					altitudeMax = 9600, --12130
					tile = 0.000, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.000, --0.510
					densityGrad = 0.000, --1.000
					coverage = 0.000, --0.478
					noiseFreq = 1.000, --0.000
					noiseBlur = 0.850,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11000,
					tile = 1.450,
					shapeFactor = 1.650,
					density = 0.385,
					densityGrad = 0.00,
					coverage = 0.650,
					noiseFreq = 1.361,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset71 =
		{
			--ATX_METAR BKN250
			visibleInGUI = true,
			readableName = '71 ##'.._('High level cirrostratus overcast \nMETAR: BKN'),
			readableNameShort = _('Cirrostratus 3 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cirrostratus3.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 5000.00,
			presetAltMax = 18288.00,
			layers = {
				{
					altitudeMin = 6096,
					altitudeMax = 7196,
					tile = 0.000,
					shapeFactor = 0.000,
					density = 0.00,
					densityGrad = 0.00,
					coverage = 0.000,
					noiseFreq = 1.100,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8500,
					altitudeMax = 9600, --12130
					tile = 0.000, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.000, --0.510
					densityGrad = 0.000, --1.000
					coverage = 0.000, --0.478
					noiseFreq = 1.000, --0.000
					noiseBlur = 0.850,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 11000,
					tile = 1.450,
					shapeFactor = 1.650,
					density = 0.385,
					densityGrad = 0.00,
					coverage = 0.700,
					noiseFreq = 1.197,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset72 =
		{
			--ATX_METAR OVC250
			visibleInGUI = true,
			readableName = '72 ##'.._('High level cirrostratus overcast \nMETAR: OVC'),
			readableNameShort = _('Cirrostratus 4 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cirrostratus4.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 5000.00,
			presetAltMax = 18288.00,
			layers = {
				{
					altitudeMin = 6096,
					altitudeMax = 7196,
					tile = 0.000,
					shapeFactor = 0.000,
					density = 0.00,
					densityGrad = 0.00,
					coverage = 0.000,
					noiseFreq = 1.100,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8500,
					altitudeMax = 9600, --12130
					tile = 0.000, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.000, --0.510
					densityGrad = 0.000, --1.000
					coverage = 0.000, --0.478
					noiseFreq = 1.000, --0.000
					noiseBlur = 0.850,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10500,
					tile = 1.250,
					shapeFactor = 1.650,
					density = 0.440,
					density = 0.40,
					densityGrad = 0.00,
					coverage = 0.900,
					noiseFreq = 1.423,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
				
		Preset73 =
		{
			--ATX_METAR +RA SCT035CB
			visibleInGUI = true,
			readableName = '73 ##'.._('Scattered Thunderstorms \nMETAR: RA SCT TS'),
			readableNameShort = _('Scattered Thunderstorms 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/tstorm1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 15000.00,
			precipitationPower = 0.9,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 7550,
					tile = 0.600,
					shapeFactor = 0.700,
					density = 0.92,
					densityGrad = 0.38,
					coverage = 0.45,
					noiseFreq = 2.20,
					noiseBlur = 1.00,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3000,
					altitudeMax = 3500,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.250,
					densityGrad = 0.272,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 11000,
					altitudeMax = 12000,
					tile = 1.450,
					shapeFactor = 1.650,
					density = 0.35,
					densityGrad = 0.00,
					coverage = 0.700,
					noiseFreq = 1.100,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset74 =
		{
			--ATX_METAR +RA BKN035CB
			visibleInGUI = true,
			readableName = '74 ##'.._('Scattered Thunderstorms \nMETAR: RA SCT TS'),
			readableNameShort = _('Scattered Thunderstorms 2 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/tstorm1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 15000.00,
			precipitationPower = 0.9,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 7550,
					tile = 0.600,
					shapeFactor = 0.700,
					density = 0.72,
					densityGrad = 0.38,
					coverage = 0.55,
					noiseFreq = 2.55,
					noiseBlur = 0.50,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3000,
					altitudeMax = 3500,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.250,
					densityGrad = 0.272,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 11000,
					altitudeMax = 12000,
					tile = 1.450,
					shapeFactor = 1.650,
					density = 0.35,
					densityGrad = 0.00,
					coverage = 0.700,
					noiseFreq = 1.100,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset75 =
		{
			--ATX_METAR SCT030 SCT080
			visibleInGUI = true,
			readableName = '75 ##'.._('Cumulus and Altocumulus scattered \nMETAR: OVC/SCT'),
			readableNameShort = _('Cumulus and Altocumulus 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/cumulusaltomixed.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10000.00,
			precipitationPower = -1.00,
			presetAltMin = 500.00,
			presetAltMax = 7620.00,
			layers = {
				{
					altitudeMin = 1000,
					altitudeMax = 2260,
					tile = 16.000,
					shapeFactor = 0.000,
					density = 0.620, --0.590
					densityGrad = 4.200, --1.200
					coverage = 0.495,
					noiseFreq = 2.088,
					noiseBlur = 0.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 4700,
					altitudeMax = 6170,
					tile = 0.225, --0.832
					shapeFactor = 0.024,
					density = 0.913,
					densityGrad = 0.791, --1.200
					coverage = 0.475, --0.625
					noiseFreq = 1.121, --1.188
					noiseBlur = 0.830, --4.414 
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8940, --12130
					tile = 0.824, --0.184
					shapeFactor = 0.215, --0.210
					density = 0.000, --0.310
					densityGrad = 0.000,
					coverage = 0.000, --0.778
					noiseFreq = 0.000,
					noiseBlur = 0.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset76 =
		{
			--ATX_METAR SCT030 SCT180 BKN240
			visibleInGUI = true,
			readableName = '76 ##'.._('Broken Thick Clouds \nMETAR: SCT BKN'),
			readableNameShort = _('Broken Cumulus No Rain 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/ScatteredShowers1.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12250.00,
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 7000.00,
			layers = {
				{
					altitudeMin = 1360,
					altitudeMax = 5440,
					tile = 22.000,
					shapeFactor = 0.05,
					density = 1.000,
					densityGrad = 1.240,
					coverage = 0.607,
					noiseFreq = 0.000,
					noiseBlur = 0.765,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6000,
					altitudeMax = 7100, --12130
					tile = 2.521, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.551, --0.510
					densityGrad = 2.000, --1.000
					coverage = 0.575, --0.478
					noiseFreq = 1.298, --0.000
					noiseBlur = 4.513,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8840, --12130
					tile = 0.895, --0.184
					shapeFactor = 0.250, --0.210
					density = 0.347, --0.310
					densityGrad = 0.350,
					coverage = 1.000, --0.778
					noiseFreq = 0.000,
					noiseBlur = 0.765,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset77 =
		{
			--ATX_METAR RA SCT010 SCT120 BKN240
			visibleInGUI = true,
			readableName = '77 ##'.. _('Broken Thick Clouds \nMETAR: SCT SCT BKN '),
			readableNameShort = _('Broken Cumulus No Rain 2 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/ScatteredShowers2.png',
			levelMap = 'bazar/effects/clouds/cloudsTiled.png',
			detailNoiseMapSize = 13350.00,
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 14000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5040,
					tile = 4.541, --9.440
					shapeFactor = 0.253,
					density = 0.568,
					densityGrad = 0.300,
					coverage = 0.673,
					noiseFreq = 3.456, --0.000
					noiseBlur = 0.663,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6000,
					altitudeMax = 7100, --12130
					tile = 2.521, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.551, --0.510
					densityGrad = 2.000, --1.000
					coverage = 0.575, --0.478
					noiseFreq = 1.128, --0.000
					noiseBlur = 4.513,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8840, --12130
					tile = 0.895, --0.184
					shapeFactor = 0.250, --0.210
					density = 0.347, --0.310
					densityGrad = 0.350,
					coverage = 1.000, --0.778
					noiseFreq = 0.000,
					noiseBlur = 0.765,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		Preset78 =
		{
			--ATX_METAR RA SCT010 SCT100 BKN280
			visibleInGUI = true,
			readableName = '78 ##'.._('Broken Thick Clouds  \nMETAR: SCT BKN '),
			readableNameShort = _('Broken Cumulus No Rain 3 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/ScatteredShowers3.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12300.00,
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 4950,
					tile = 9.200,
					shapeFactor = 0.106,
					density = 0.832,
					densityGrad = 0.740,
					coverage = 0.522,
					noiseFreq = 0.800,
					noiseBlur = 1.218,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 5100,
					altitudeMax = 6300, --10300
					tile = 2.424,
					shapeFactor = 0.295, --0.210
					density = 0.470, --0.320
					densityGrad = 0.350,
					coverage = 0.782,
					noiseFreq = 2.200,
					noiseBlur = 1.034,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10500,
					altitudeMax = 12180,
					tile = 0.00,
					shapeFactor = 0.201,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset79 =
		{
			--ATX_METAR RA BKN020 SCT140 OVC240
			visibleInGUI = true,
			readableName = '79 ##'.._('Broken Thick Clouds \nMETAR: SCT BKN'),
			readableNameShort = _('Broken Cumulus No Rain 4 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/ScatteredShowers4.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12450.00,
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 2520,
					altitudeMax = 5710,
					tile = 2.528,
					shapeFactor = 0.066,
					density = 0.505,
					densityGrad = 0.316,
					coverage = 0.745,
					noiseFreq = 2.200,
					noiseBlur = 1.224,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 6500, --8500
					altitudeMax = 7600, --9600
					tile = 2.521, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.510, --0.510
					densityGrad = 2.000, --1.000
					coverage = 0.575, --0.478
					noiseFreq = 1.000, --0.000
					noiseBlur = 8.850,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000, --10000
					altitudeMax = 8840, --10840
					tile = 0.824, --0.184
					shapeFactor = 0.215, --0.210
					density = 0.321, --0.310
					densityGrad = 0.350,
					coverage = 1.000, --0.778
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		Preset80 =
		{
			--ATX_METAR RA SCT030 SCT180 BKN240
			visibleInGUI = true,
			readableName = '80 ##'.._('Broken Thick Clouds  \nMETAR: SCT BKN BKN'),
			readableNameShort = _('Broken Cumulus No Rain 5 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/ScatteredShowers5.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 10800.00, --16000*
			precipitationPower = -1.00,
			presetAltMin = 200.00,
			presetAltMax = 10000.00,
			layers = {
				{
					altitudeMin = 1200,
					altitudeMax = 4500, --4500*
					tile = 3.200, --7.200*
					shapeFactor = 0.306, --2.106
					density = 0.996, --0.822*
					densityGrad = 1.000, --0.500*
					coverage = 0.637, --0.554*
					noiseFreq = 0.000,
					noiseBlur = 0.765,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 4900,
					altitudeMax = 6500, --12130
					tile = 2.521, --2.521
					shapeFactor = 0.024, --0.210
					density = 0.551, --0.510
					densityGrad = 2.000, --1.000
					coverage = 0.609, --0.478
					noiseFreq = 1.224, --0.000
					noiseBlur = 4.513,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000, --10000
					altitudeMax = 8840, --10840
					tile = 0.824, --0.184
					shapeFactor = 0.215, --0.210
					density = 0.321, --0.310
					densityGrad = 0.350,
					coverage = 1.000, --0.778
					noiseFreq = 0.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.50,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
	Preset81 =
		{
			--ATX_METAR FEW020 BKN080
			visibleInGUI = true,
			readableName = '81 ##'.._('2 layers, low and mid level'),
			readableNameShort = _('Cumulus & Altocumulus 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/Preset81.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 13000.00,
			precipitationPower = 0.00,
			presetAltMin = 610.00,
			presetAltMax = 11500.00,
			layers =
			{
			{
				altitudeMin = 610,
				altitudeMax = 1524,
				tile = 2.500,
				shapeFactor = 1.000,
				density = 0.300,
				densityGrad = 0.250,
				coverage = 0.38,
				noiseFreq = 0.950,
				noiseBlur = 2.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 3700,
				altitudeMax = 4800,
				tile = 0.721,
				shapeFactor = 0.000,
				density = 0.610,
				densityGrad = 1.000,
				coverage = 0.68,
				noiseFreq = 12.000,
				noiseBlur = 5.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 10000,
				altitudeMax = 11500,
				tile = 2.000,
				shapeFactor = 0.034,
				density = 0.480,
				densityGrad = 1.000,
				coverage = 0.00,
				noiseFreq = 0.000,
				noiseBlur = 0.850,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			}
		},
		
	Preset82 =
		{
			--ATX_METAR BKN020 BKN210
			visibleInGUI = true,
			readableName = '82 ##'.._('2 layers, low/mid'),
			readableNameShort = _('Cumulus & Altocumulus 2 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/Preset82.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 13000.00,
			precipitationPower = 0.00,
			presetAltMin = 620.00,
			presetAltMax = 8561.00,
			layers =
			{
			{
				altitudeMin = 620,
				altitudeMax = 2349,
				tile = 12.000,
				shapeFactor = 0.750,
				density = 0.500,
				densityGrad = 4.200,
				coverage = 0.55,
				noiseFreq = 0.250,
				noiseBlur = 1.500,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 7560,
				altitudeMax = 8561,
				tile = 0.000,
				shapeFactor = 0.000,
				density = 0.000,
				densityGrad = 1.400,
				coverage = 0.00,
				noiseFreq = 3.000,
				noiseBlur = 1.500,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 6706,
				altitudeMax = 7316,
				tile = 1.250,
				shapeFactor = 0.000,
				density = 0.400,
				densityGrad = 0.550,
				coverage = 0.60,
				noiseFreq = 0.300,
				noiseBlur = 1.750,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			}
		},
		
    Preset83 =
		{
			--ATX_METAR RA BKN050CU BKN250
			visibleInGUI = true,
			readableName = '83 ##'.._('Building cumulonimbus, scattered showers'),
			readableNameShort = _('Scattered Showers 7 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/Preset83.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 13000.00,
			precipitationPower = 0.35,
			presetAltMin = 460.00,
			presetAltMax = 2438.00,
			layers =
			{
			{
				altitudeMin = 1600,
				altitudeMax = 5258,
				tile = 1.750,
				shapeFactor = 0.650,
				density = 0.720,
				densityGrad = 0.850,
				coverage = 0.65,
				noiseFreq = 24.200,
				noiseBlur = 5.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 5212,
				altitudeMax = 5822,
				tile = 1.850,
				shapeFactor = 0.120,
				density = 0.000,
				densityGrad = 0.150,
				coverage = 0.00,
				noiseFreq = 5.500,
				noiseBlur = 1.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 7620,
				altitudeMax = 8230,
				tile = 1.650,
				shapeFactor = 0.550,
				density = 0.450,
				densityGrad = 0.350,
				coverage = 0.65,
				noiseFreq = 1.350,
				noiseBlur = 1.350,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			}
		},
		
	Preset84 =
		{
			--ATX_METAR FEW080 SCT120 BKN250
			visibleInGUI = true,
			readableName = '84 ##'.._('3 layers mid level and upper level '),
			readableNameShort = _('Altocumulus & Cirrocumulus 1 [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/Preset84.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12500.00,
			precipitationPower = 0.00,
			presetAltMin = 2438.00,
			presetAltMax = 8108.00,
			layers =
			{
			{
				altitudeMin = 2438,
				altitudeMax = 3352,
				tile = 2.500,
				shapeFactor = 1.000,
				density = 0.300,
				densityGrad = 0.250,
				coverage = 0.38,
				noiseFreq = 0.950,
				noiseBlur = 2.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 3700,
				altitudeMax = 4800,
				tile = 0.721,
				shapeFactor = 0.000,
				density = 0.610,
				densityGrad = 1.000,
				coverage = 0.68,
				noiseFreq = 12.000,
				noiseBlur = 5.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 7620,
				altitudeMax = 8108,
				tile = 0.700,
				shapeFactor = 0.034,
				density = 0.480,
				densityGrad = 0.250,
				coverage = 0.65,
				noiseFreq = 0.700,
				noiseBlur = 1.200,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			}
		},
		
	Preset85 =
		{
			--ATX_METAR SCT080 BKN120
			visibleInGUI = true,
			readableName = '85 ##'.._('2 layers mid level'),
			readableNameShort = _('Altostratus & Altocumulus [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/Preset85.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 16000.00,
			precipitationPower = 0.00,
			presetAltMin = 2438.00,
			presetAltMax = 8108.00,
			layers =
			{
			{
				altitudeMin = 2438,
				altitudeMax = 3352,
				tile = 2.500,
				shapeFactor = 1.000,
				density = 0.350,
				densityGrad = 0.250,
				coverage = 0.60,
				noiseFreq = 0.950,
				noiseBlur = 2.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 3700,
				altitudeMax = 4800,
				tile = 0.721,
				shapeFactor = 0.000,
				density = 0.610,
				densityGrad = 1.000,
				coverage = 0.68,
				noiseFreq = 12.000,
				noiseBlur = 5.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 7620,
				altitudeMax = 8108,
				tile = 0.700,
				shapeFactor = 0.034,
				density = 0.000,
				densityGrad = 0.250,
				coverage = 0.00,
				noiseFreq = 0.700,
				noiseBlur = 1.200,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			}
		},
		
	Preset86 =
		{
			--ATX_METER FEW080 FEW120
			visibleInGUI = true,
			readableName = '86 ##'.._('2 layers mid level'),
			readableNameShort = _('Few Altocumulus [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/Preset86.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 13000.00,
			precipitationPower = 0.00,
			presetAltMin = 2438.00,
			presetAltMax = 8108.00,
			layers =
			{
			{
				altitudeMin = 2438,
				altitudeMax = 3352,
				tile = 2.500,
				shapeFactor = 1.000,
				density = 0.350,
				densityGrad = 0.250,
				coverage = 0.40,
				noiseFreq = 0.950,
				noiseBlur = 2.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 3700,
				altitudeMax = 4800,
				tile = 0.721,
				shapeFactor = 0.000,
				density = 0.610,
				densityGrad = 1.000,
				coverage = 0.45,
				noiseFreq = 12.000,
				noiseBlur = 5.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 7620,
				altitudeMax = 8108,
				tile = 0.700,
				shapeFactor = 0.034,
				density = 0.000,
				densityGrad = 0.250,
				coverage = 0.00,
				noiseFreq = 0.700,
				noiseBlur = 1.200,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			}
		},
		
	Preset87 =
		{
			--ATX_METAR FEW080 SCT120 SCT180
			visibleInGUI = true,
			readableName = '87 ##'.._('3 layers mid level'),
			readableNameShort = _('Altocumulus 3 layers [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/Preset87.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 13000.00,
			precipitationPower = 0.00,
			presetAltMin = 2438.00,
			presetAltMax = 6157.00,
			layers =
			{
			{
				altitudeMin = 2438,
				altitudeMax = 3352,
				tile = 2.500,
				shapeFactor = 1.000,
				density = 0.350,
				densityGrad = 0.250,
				coverage = 0.40,
				noiseFreq = 0.950,
				noiseBlur = 2.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 3700,
				altitudeMax = 4800,
				tile = 0.721,
				shapeFactor = 0.000,
				density = 0.610,
				densityGrad = 1.000,
				coverage = 0.52,
				noiseFreq = 12.000,
				noiseBlur = 5.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 5486,
				altitudeMax = 6157,
				tile = 1.150,
				shapeFactor = 0.000,
				density = 0.350,
				densityGrad = 0.250,
				coverage = 0.50,
				noiseFreq = 0.800,
				noiseBlur = 2.200,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			}
		},
		
	Preset88 =
		{
			--ATX_METAR SCT0120 BKN180 BKN250
			visibleInGUI = true,
			readableName = '88 ##'.._('3 layers mid and upper level'),
			readableNameShort = _('Altostratus & Altocumulus [ATMOS-X]'),
			thumbnailName = 'Bazar/Effects/Clouds/Thumbnails/Preset88.png',
			levelMap = 'bazar/effects/clouds/cloudsMap01.png',
			detailNoiseMapSize = 12000.00,
			precipitationPower = 0.00,
			presetAltMin = 3658.00,
			presetAltMax = 8382.00,
			layers =
			{
			{
				altitudeMin = 3658,
				altitudeMax = 4572,
				tile = 2.500,
				shapeFactor = 1.000,
				density = 0.300,
				densityGrad = 0.250,
				coverage = 0.45,
				noiseFreq = 0.950,
				noiseBlur = 2.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 5486,
				altitudeMax = 6586,
				tile = 0.721,
				shapeFactor = 0.000,
				density = 0.610,
				densityGrad = 1.000,
				coverage = 0.68,
				noiseFreq = 12.000,
				noiseBlur = 5.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			{
				altitudeMin = 7620,
				altitudeMax = 8382,
				tile = 1.500,
				shapeFactor = 0.000,
				density = 0.450,
				densityGrad = 0.350,
				coverage = 0.65,
				noiseFreq = 1.000,
				noiseBlur = 2.000,
				coverageMapFactor = 0.00,
				coverageMapUVOffsetX = 0.00,
				coverageMapUVOffsetY = 0.00,
			},
			}
		},
		
		clouds01 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.420,
					densityGrad = 0.272,
					coverage = 0.298,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		clouds02 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.420,
					densityGrad = 0.272,
					coverage = 0.340,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		clouds03 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.420,
					densityGrad = 0.272,
					coverage = 0.400,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		clouds04 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.420,
					densityGrad = 0.272,
					coverage = 0.480,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		clouds05 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.420,
					densityGrad = 0.272,
					coverage = 0.550,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		clouds06 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.500,
					densityGrad = 0.272,
					coverage = 0.600,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		clouds07 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.550,
					densityGrad = 0.350,
					coverage = 0.680,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		clouds08 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.600,
					densityGrad = 0.400,
					coverage = 0.750,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		clouds09 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.700,
					densityGrad = 0.550,
					coverage = 0.850,
					noiseFreq = 3.000,
					noiseBlur = 1.299,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},

		clouds10 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 2.000,
					shapeFactor = 0.350,
					density = 0.850,
					densityGrad = 0.650,
					coverage = 1.100,
					noiseFreq = 3.000,
					noiseBlur = 1.500,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 10000,
					altitudeMax = 10000,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.000,
					densityGrad = 0.000,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		clouds11 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 15000.00,
			precipitationPower = 0.80,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 0.600,
					shapeFactor = 0.700,
					density = 0.92,
					densityGrad = 0.38,
					coverage = 0.38,
					noiseFreq = 2.20,
					noiseBlur = 1.00,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3000,
					altitudeMax = 3500,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.250,
					densityGrad = 0.272,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8500,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.450,
					densityGrad = 0.025,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		clouds12 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 15000.00,
			precipitationPower = 0.80,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 0.600,
					shapeFactor = 0.700,
					density = 0.92,
					densityGrad = 0.38,
					coverage = 0.45,
					noiseFreq = 2.20,
					noiseBlur = 1.00,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3000,
					altitudeMax = 3500,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.250,
					densityGrad = 0.272,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8500,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.450,
					densityGrad = 0.025,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		clouds13 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 15000.00,
			precipitationPower = 0.80,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 0.600,
					shapeFactor = 0.700,
					density = 0.92,
					densityGrad = 0.38,
					coverage = 0.6,
					noiseFreq = 2.20,
					noiseBlur = 1.00,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3000,
					altitudeMax = 3500,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.250,
					densityGrad = 0.272,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8500,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.450,
					densityGrad = 0.025,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		clouds14 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 15000.00,
			precipitationPower = 0.80,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 0.600,
					shapeFactor = 0.700,
					density = 0.92,
					densityGrad = 0.38,
					coverage = 0.70,
					noiseFreq = 2.20,
					noiseBlur = 1.00,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3000,
					altitudeMax = 3500,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.250,
					densityGrad = 0.272,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8500,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.450,
					densityGrad = 0.025,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		clouds15 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 1.550,
					shapeFactor = 0.000,
					density = 0.450,
					densityGrad = 0.372,
					coverage = 0.450,
					noiseFreq = 2.000,
					noiseBlur = 1.099,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3000,
					altitudeMax = 3500,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.250,
					densityGrad = 0.272,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8500,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.450,
					densityGrad = 0.025,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		clouds16 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1250,
					altitudeMax = 2813,
					tile = 1.550,
					shapeFactor = 0.000,
					density = 0.820,
					densityGrad = 0.372,
					coverage = 0.475,
					noiseFreq = 2.000,
					noiseBlur = 1.099,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 3000,
					altitudeMax = 3500,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.250,
					densityGrad = 0.272,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 8000,
					altitudeMax = 8500,
					tile = 1.000,
					shapeFactor = 0.000,
					density = 0.450,
					densityGrad = 0.025,
					coverage = 0.000,
					noiseFreq = 2.000,
					noiseBlur = 0.270,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		},
		
		clouds17 =
		{
			visibleInGUI = false,
			readableName = '',
			readableNameShort = '',
			thumbnailName = '',
			levelMap = 'cloudsMap01.png',
			detailNoiseMapSize = 9000.00,
			precipitationPower = -1.00,
			presetAltMin = -1.00,
			presetAltMax = -1.00,
			layers = {
				{
					altitudeMin = 1981,
					altitudeMax = 2981,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.843,
					densityGrad = 1.000,
					coverage = 0.552,
					noiseFreq = 2.500,
					noiseBlur = 1.000,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
				{
					altitudeMin = 2895,
					altitudeMax = 3895,
					tile = 2.000,
					shapeFactor = 0.000,
					density = 0.623,
					densityGrad = 1.000,
					coverage = 0.841,
					noiseFreq = 2.500,
					noiseBlur = 1.000,
					coverageMapFactor = 0.00,
					coverageMapUVOffsetX = 0.00,
					coverageMapUVOffsetY = 0.00,
				},
			}
		}, 
	}
};


function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}   
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

--[[
clouds.presets.clouds02 = deepcopy(clouds.presets.clouds01)
clouds.presets.clouds02.layers[1].coverage = 0.34

clouds.presets.clouds03 = deepcopy(clouds.presets.clouds02)
clouds.presets.clouds03.layers[1].coverage = 0.40

clouds.presets.clouds04 = deepcopy(clouds.presets.clouds03)
clouds.presets.clouds04.layers[1].coverage = 0.48

clouds.presets.clouds05 = deepcopy(clouds.presets.clouds04)
clouds.presets.clouds05.layers[1].coverage = 0.55

clouds.presets.clouds06 = deepcopy(clouds.presets.clouds05)
clouds.presets.clouds06.layers[1].coverage = 0.60
clouds.presets.clouds06.layers[1].density = 0.5

clouds.presets.clouds07 = deepcopy(clouds.presets.clouds06)
clouds.presets.clouds07.layers[1].coverage = 0.68
clouds.presets.clouds07.layers[1].density = 0.55
clouds.presets.clouds07.layers[1].densityGrad = 0.35

clouds.presets.clouds08 = deepcopy(clouds.presets.clouds07)
clouds.presets.clouds08.layers[1].coverage = 0.75
clouds.presets.clouds08.layers[1].density = 0.60
clouds.presets.clouds08.layers[1].densityGrad = 0.4

clouds.presets.clouds09 = deepcopy(clouds.presets.clouds08)
clouds.presets.clouds09.layers[1].coverage = 0.85
clouds.presets.clouds09.layers[1].density = 0.7
clouds.presets.clouds09.layers[1].densityGrad = 0.55

clouds.presets.clouds10 = deepcopy(clouds.presets.clouds09)
clouds.presets.clouds10.layers[1].coverage = 1.1
clouds.presets.clouds10.layers[1].density = 0.85
clouds.presets.clouds10.layers[1].densityGrad = 0.65
clouds.presets.clouds10.layers[1].noiseBlur = 1.5
clouds.presets.clouds10.layers[1].shapeFactor = 0.35
--]]

