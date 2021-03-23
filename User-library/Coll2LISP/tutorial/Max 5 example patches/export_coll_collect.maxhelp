{
	"patcher" : 	{
		"fileversion" : 1,
		"rect" : [ 141.0, 265.0, 781.0, 197.0 ],
		"bglocked" : 0,
		"defrect" : [ 141.0, 265.0, 781.0, 197.0 ],
		"openrect" : [ 0.0, 0.0, 0.0, 0.0 ],
		"openinpresentation" : 0,
		"default_fontsize" : 12.0,
		"default_fontface" : 0,
		"default_fontname" : "Arial",
		"gridonopen" : 0,
		"gridsize" : [ 15.0, 15.0 ],
		"gridsnaponopen" : 0,
		"toolbarvisible" : 1,
		"boxanimatetime" : 200,
		"imprint" : 0,
		"boxes" : [ 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "lire le coll",
					"numoutlets" : 0,
					"fontsize" : 12.0,
					"presentation_rect" : [ 612.0, 51.0, 0.0, 0.0 ],
					"id" : "obj-2",
					"fontname" : "Copperplate",
					"patching_rect" : [ 683.0, 42.0, 81.0, 19.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "button",
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"presentation_rect" : [ 716.0, 71.0, 0.0, 0.0 ],
					"id" : "obj-16",
					"patching_rect" : [ 718.0, 65.0, 20.0, 20.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "button",
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"id" : "obj-17",
					"patching_rect" : [ 262.0, 67.0, 38.0, 38.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "bang2binary",
					"numoutlets" : 1,
					"fontsize" : 12.0,
					"outlettype" : [ "" ],
					"id" : "obj-4",
					"fontname" : "Copperplate",
					"patching_rect" : [ 234.0, 121.0, 88.0, 19.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "durée/échantillon",
					"numoutlets" : 0,
					"fontsize" : 12.0,
					"id" : "obj-15",
					"fontname" : "Copperplate",
					"patching_rect" : [ 108.0, 63.0, 130.0, 19.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "flonum",
					"numoutlets" : 2,
					"fontsize" : 12.0,
					"outlettype" : [ "float", "bang" ],
					"id" : "obj-9",
					"fontname" : "Copperplate",
					"patching_rect" : [ 418.0, 103.0, 50.0, 19.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "toggle",
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"id" : "obj-5",
					"patching_rect" : [ 48.0, 51.0, 20.0, 20.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "number",
					"numoutlets" : 2,
					"fontsize" : 12.0,
					"outlettype" : [ "int", "bang" ],
					"id" : "obj-3",
					"fontname" : "Copperplate",
					"patching_rect" : [ 142.0, 88.0, 53.0, 19.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "vider le coll",
					"numoutlets" : 0,
					"fontsize" : 12.0,
					"id" : "obj-14",
					"fontname" : "Copperplate",
					"patching_rect" : [ 536.0, 62.0, 92.0, 19.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "button",
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"id" : "obj-13",
					"patching_rect" : [ 562.0, 84.0, 20.0, 20.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "formate le coll en fichier txt",
					"numoutlets" : 0,
					"fontsize" : 12.0,
					"id" : "obj-12",
					"fontname" : "Copperplate",
					"patching_rect" : [ 518.0, 14.0, 203.0, 19.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "déclencher l'échantillonnage",
					"linecount" : 2,
					"numoutlets" : 0,
					"fontsize" : 12.0,
					"id" : "obj-11",
					"fontname" : "Copperplate",
					"patching_rect" : [ 35.0, 15.0, 186.0, 31.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "les différents paramètres évoluant au fil du temps",
					"linecount" : 2,
					"numoutlets" : 0,
					"fontsize" : 12.0,
					"id" : "obj-10",
					"fontname" : "Copperplate",
					"patching_rect" : [ 280.0, 29.0, 183.0, 31.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "flonum",
					"numoutlets" : 2,
					"fontsize" : 12.0,
					"outlettype" : [ "float", "bang" ],
					"id" : "obj-8",
					"fontname" : "Copperplate",
					"patching_rect" : [ 380.0, 75.0, 50.0, 19.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "flonum",
					"numoutlets" : 2,
					"fontsize" : 12.0,
					"outlettype" : [ "float", "bang" ],
					"id" : "obj-7",
					"fontname" : "Copperplate",
					"patching_rect" : [ 323.0, 97.0, 50.0, 19.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "button",
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"id" : "obj-6",
					"patching_rect" : [ 622.0, 34.0, 20.0, 20.0 ],
					"numinlets" : 1
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "export_coll_collect",
					"numoutlets" : 0,
					"fontsize" : 12.0,
					"id" : "obj-1",
					"fontname" : "Copperplate",
					"patching_rect" : [ 170.0, 162.0, 587.0, 19.0 ],
					"numinlets" : 35
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"source" : [ "obj-16", 0 ],
					"destination" : [ "obj-1", 34 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-6", 0 ],
					"destination" : [ "obj-1", 33 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-17", 0 ],
					"destination" : [ "obj-4", 0 ],
					"hidden" : 0,
					"midpoints" : [ 271.5, 114.0, 243.5, 114.0 ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-8", 0 ],
					"destination" : [ "obj-1", 11 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-5", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 0,
					"midpoints" : [ 57.5, 151.0, 179.5, 151.0 ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-3", 0 ],
					"destination" : [ "obj-1", 1 ],
					"hidden" : 0,
					"midpoints" : [ 151.5, 120.0, 196.205887, 120.0 ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-9", 0 ],
					"destination" : [ "obj-1", 12 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-7", 0 ],
					"destination" : [ "obj-1", 9 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-13", 0 ],
					"destination" : [ "obj-1", 32 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-4", 0 ],
					"destination" : [ "obj-1", 7 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
 ]
	}

}
