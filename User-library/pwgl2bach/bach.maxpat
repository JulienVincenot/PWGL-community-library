{
	"patcher" : 	{
		"fileversion" : 1,
		"rect" : [ 376.0, 77.0, 898.0, 658.0 ],
		"bglocked" : 0,
		"defrect" : [ 376.0, 77.0, 898.0, 658.0 ],
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
		"enablehscroll" : 1,
		"enablevscroll" : 1,
		"devicewidth" : 0.0,
		"boxes" : [ 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "exportpwgl",
					"patching_rect" : [ 67.0, 366.0, 69.0, 18.0 ],
					"id" : "obj-38",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 12.0,
					"numoutlets" : 1,
					"presentation_rect" : [ 90.0, 356.0, 0.0, 0.0 ],
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "exportpwgl",
					"patching_rect" : [ 211.0, 75.0, 69.0, 18.0 ],
					"id" : "obj-32",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 12.0,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "route text",
					"patching_rect" : [ 609.0, 357.0, 61.0, 20.0 ],
					"id" : "obj-22",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 12.0,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "textedit",
					"patching_rect" : [ 609.0, 301.0, 100.0, 50.0 ],
					"id" : "obj-30",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 12.0,
					"numoutlets" : 4,
					"outlettype" : [ "", "int", "", "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "route text",
					"patching_rect" : [ 126.0, 66.0, 61.0, 20.0 ],
					"id" : "obj-21",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 12.0,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "textedit",
					"patching_rect" : [ 126.0, 10.0, 100.0, 50.0 ],
					"id" : "obj-20",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 12.0,
					"numoutlets" : 4,
					"outlettype" : [ "", "int", "", "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "Spacing parameter:",
					"patching_rect" : [ 716.0, 252.0, 112.0, 20.0 ],
					"id" : "obj-93",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 0
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "loadmess 95",
					"hidden" : 1,
					"patching_rect" : [ 798.0, 247.0, 76.0, 20.0 ],
					"id" : "obj-90",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "flonum",
					"patching_rect" : [ 762.0, 292.0, 50.0, 20.0 ],
					"id" : "obj-67",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 12.0,
					"numoutlets" : 2,
					"outlettype" : [ "float", "bang" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "/ 127.",
					"patching_rect" : [ 718.0, 291.0, 41.0, 20.0 ],
					"id" : "obj-68",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 12.0,
					"numoutlets" : 1,
					"outlettype" : [ "float" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "slider",
					"patching_rect" : [ 718.0, 271.0, 150.0, 18.0 ],
					"id" : "obj-76",
					"numinlets" : 1,
					"size" : 127.0,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "spacingparameter $1",
					"patching_rect" : [ 718.0, 317.0, 121.0, 18.0 ],
					"id" : "obj-83",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 12.0,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "loadmess 1",
					"hidden" : 1,
					"patching_rect" : [ 696.0, 666.0, 70.0, 20.0 ],
					"id" : "obj-69",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "umenu",
					"patching_rect" : [ 656.0, 684.0, 135.0, 20.0 ],
					"types" : [  ],
					"id" : "obj-70",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 3,
					"items" : [ "None", ",", "Classical", ",", "Fraction", ",", "UnreducedFraction", ",", "Cents" ],
					"outlettype" : [ "int", "", "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "Accidentals graphic:",
					"patching_rect" : [ 654.0, 666.0, 137.0, 20.0 ],
					"id" : "obj-71",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 0
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "accidentalsgraphic $1",
					"patching_rect" : [ 656.0, 709.0, 123.0, 18.0 ],
					"id" : "obj-72",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "-th tone",
					"patching_rect" : [ 749.0, 536.0, 50.0, 20.0 ],
					"id" : "obj-66",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 0
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "number",
					"patching_rect" : [ 713.0, 535.0, 38.0, 20.0 ],
					"id" : "obj-64",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 2,
					"outlettype" : [ "int", "bang" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "8",
					"hidden" : 1,
					"patching_rect" : [ 666.0, 559.0, 32.5, 18.0 ],
					"id" : "obj-60",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "4",
					"hidden" : 1,
					"patching_rect" : [ 649.0, 538.0, 32.5, 18.0 ],
					"id" : "obj-59",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "2",
					"hidden" : 1,
					"patching_rect" : [ 635.0, 520.0, 32.5, 18.0 ],
					"id" : "obj-54",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "sel 0 1 2",
					"hidden" : 1,
					"patching_rect" : [ 634.0, 492.0, 59.5, 20.0 ],
					"id" : "obj-49",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 4,
					"outlettype" : [ "bang", "bang", "bang", "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "%",
					"patching_rect" : [ 728.0, 458.0, 21.0, 20.0 ],
					"id" : "obj-14",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 0
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "flonum",
					"patching_rect" : [ 679.0, 458.0, 50.0, 20.0 ],
					"id" : "obj-7",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 2,
					"outlettype" : [ "float", "bang" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "loadmess 0",
					"hidden" : 1,
					"patching_rect" : [ 725.0, 602.0, 70.0, 20.0 ],
					"id" : "obj-62",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "loadmess 29",
					"hidden" : 1,
					"patching_rect" : [ 675.0, 393.0, 76.0, 20.0 ],
					"id" : "obj-61",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "umenu",
					"patching_rect" : [ 644.0, 607.0, 111.0, 20.0 ],
					"types" : [  ],
					"id" : "obj-43",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 3,
					"items" : [ "Auto", ",", "Sharps", ",", "Flats" ],
					"outlettype" : [ "int", "", "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "Accidentals preferences:",
					"patching_rect" : [ 642.0, 589.0, 137.0, 20.0 ],
					"id" : "obj-44",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 0
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "Duration line width:",
					"patching_rect" : [ 643.0, 63.0, 109.0, 20.0 ],
					"id" : "obj-41",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 0
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "loadmess 2.",
					"hidden" : 1,
					"patching_rect" : [ 645.0, 63.0, 73.0, 20.0 ],
					"id" : "obj-40",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "flonum",
					"patching_rect" : [ 647.0, 81.0, 50.0, 20.0 ],
					"id" : "obj-39",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 2,
					"outlettype" : [ "float", "bang" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "loadmess 1",
					"hidden" : 1,
					"patching_rect" : [ 748.0, 493.0, 70.0, 20.0 ],
					"id" : "obj-36",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "umenu",
					"patching_rect" : [ 713.0, 511.0, 111.0, 20.0 ],
					"types" : [  ],
					"id" : "obj-8",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 3,
					"items" : [ "Semitones", ",", "Quartertones", ",", "Eighthtones" ],
					"outlettype" : [ "int", "", "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "Tone division:",
					"patching_rect" : [ 711.0, 493.0, 81.0, 20.0 ],
					"id" : "obj-35",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 0
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "Zoom:",
					"patching_rect" : [ 619.0, 393.0, 81.0, 20.0 ],
					"id" : "obj-9",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 0
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "scale 0. 127. 10 400",
					"patching_rect" : [ 623.0, 434.0, 115.0, 20.0 ],
					"id" : "obj-29",
					"fontname" : "Arial",
					"numinlets" : 6,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "slider",
					"patching_rect" : [ 623.0, 412.0, 179.0, 18.0 ],
					"id" : "obj-28",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "loadmess 0",
					"hidden" : 1,
					"patching_rect" : [ 728.0, 125.0, 70.0, 20.0 ],
					"id" : "obj-23",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "umenu",
					"patching_rect" : [ 646.0, 148.0, 180.0, 20.0 ],
					"types" : [  ],
					"id" : "obj-24",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 3,
					"items" : [ "None", ",", "Gradient", ",", "Color", "spectrum", ",", "Alpha", "channel" ],
					"outlettype" : [ "int", "", "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "Show velocity with:",
					"patching_rect" : [ 642.0, 130.0, 108.0, 20.0 ],
					"id" : "obj-25",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 0
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "velocityhandling $1",
					"patching_rect" : [ 646.0, 173.0, 109.0, 18.0 ],
					"id" : "obj-26",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "loadmess 2",
					"hidden" : 1,
					"patching_rect" : [ 730.0, 193.0, 70.0, 20.0 ],
					"id" : "obj-18",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "newobj",
					"text" : "loadmess 0",
					"hidden" : 1,
					"patching_rect" : [ 774.0, 40.0, 70.0, 20.0 ],
					"id" : "obj-17",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "toggle",
					"patching_rect" : [ 646.0, 38.0, 20.0, 20.0 ],
					"id" : "obj-15",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "Hide/show durations:",
					"patching_rect" : [ 642.0, 20.0, 128.0, 20.0 ],
					"id" : "obj-10",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 0
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "umenu",
					"patching_rect" : [ 646.0, 216.0, 180.0, 20.0 ],
					"types" : [  ],
					"id" : "obj-11",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 3,
					"items" : [ "Never", ",", "On", "note-click", ",", "On", "note-click", "or", "mousemove" ],
					"outlettype" : [ "int", "", "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "comment",
					"text" : "Show legend:",
					"patching_rect" : [ 642.0, 198.0, 81.0, 20.0 ],
					"id" : "obj-12",
					"fontname" : "Arial",
					"numinlets" : 1,
					"fontsize" : 11.595187,
					"numoutlets" : 0
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "legend $1",
					"patching_rect" : [ 646.0, 241.0, 61.0, 18.0 ],
					"id" : "obj-16",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "showdurations $1",
					"patching_rect" : [ 671.0, 40.0, 99.0, 18.0 ],
					"id" : "obj-19",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "zoom $1",
					"patching_rect" : [ 623.0, 459.0, 53.0, 18.0 ],
					"id" : "obj-27",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "tonedivision $1",
					"patching_rect" : [ 713.0, 559.0, 86.0, 18.0 ],
					"id" : "obj-33",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "durationslinewidth $1",
					"patching_rect" : [ 647.0, 106.0, 117.0, 18.0 ],
					"id" : "obj-37",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "accidentalspreferences $1",
					"patching_rect" : [ 644.0, 632.0, 144.0, 18.0 ],
					"id" : "obj-42",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 11.595187,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "writetxt",
					"patching_rect" : [ 16.0, 341.0, 49.0, 18.0 ],
					"id" : "obj-3",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 12.0,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "write",
					"patching_rect" : [ 16.0, 320.0, 36.0, 18.0 ],
					"id" : "obj-4",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 12.0,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "read",
					"patching_rect" : [ 16.0, 362.0, 35.0, 18.0 ],
					"id" : "obj-6",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 12.0,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "writetxt",
					"patching_rect" : [ 16.0, 50.0, 49.0, 18.0 ],
					"id" : "obj-34",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 12.0,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "write",
					"patching_rect" : [ 16.0, 29.0, 36.0, 18.0 ],
					"id" : "obj-31",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 12.0,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "message",
					"text" : "read",
					"patching_rect" : [ 16.0, 71.0, 35.0, 18.0 ],
					"id" : "obj-13",
					"fontname" : "Arial",
					"numinlets" : 2,
					"fontsize" : 12.0,
					"numoutlets" : 1,
					"outlettype" : [ "" ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "bach.roll",
					"patching_rect" : [ 16.0, 394.0, 586.0, 143.0 ],
					"id" : "obj-5",
					"zoom" : 99.055115,
					"voicespacing" : [ 0.0, 17.0 ],
					"numinlets" : 6,
					"tonedivision" : 4,
					"vzoom" : 141.584152,
					"numoutlets" : 8,
					"showdurations" : 0,
					"outlettype" : [ "llll.connect", "llll.connect", "llll.connect", "llll.connect", "llll.connect", "llll.connect", "llll.connect", "bang" ],
					"whole_roll_data_0000000000" : [ "roll", "(", "slotinfo", "(", 1, "`amplitude envelope", "function", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1080016896, 97, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 2, "`slot function", "function", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 113, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 3, "`slot longlist", "intlist", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1080016896, 119, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 4, "`slot floatlist", "floatlist", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 101, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 5, "`slot long", "int", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1080016896, 114, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 6, "`slot float", "float", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 116, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 7, "`slot text", "text", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 121, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 8, "filelist", "filelist", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 117, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 9, "spat", "spat", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1076101120, 105, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 10, "`slot 10", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 11, "`slot 11", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 12, "`slot 12", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 13, "`slot 13", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 14, "`slot 14", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 15, "`slot 15", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 16, "`slot 16", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 17, "`slot 17", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 18, "`slot 18", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 19, "`slot 19", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 20, "`slot 20", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 21, "`slot 21", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 22, "`slot 22", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 23, "`slot 23", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 24, "`slot 24", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 25, "`slot 25", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 26, "`slot 26", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 27, "`slot 27", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 28, "`slot 28", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 29, "`slot 29", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 30, "`slot 30", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", ")", "(", "commands", "(", 1, "notecmd", "chordcmd", 0, ")", "(", 2, "notecmd", "chordcmd", 0, ")", "(", 3, "notecmd", "chordcmd", 0, ")", "(", 4, "notecmd", "chordcmd", 0, ")", "(", 5, "notecmd", "chordcmd", 0, ")", ")", "(", "midichannels", 1, ")", "(", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1083348992, "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086325760, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1083265024, 100, 0, ")", 0, ")", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1084963328, "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086109184, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1083265024, 100, 0, ")", 0, ")", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085588224, "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085917184, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1083265024, 100, 0, ")", 0, ")", ")" ],
					"whole_roll_data_count" : [ 1 ]
				}

			}
, 			{
				"box" : 				{
					"maxclass" : "bach.score",
					"patching_rect" : [ 16.0, 101.0, 602.0, 176.333328 ],
					"showaccidentalspreferences" : 1,
					"id" : "obj-1",
					"spacingparameter" : 0.748031,
					"clefs" : [ "G", "F" ],
					"voicespacing" : [ 0.0, 26.0, 26.0 ],
					"numinlets" : 7,
					"autoretranscribe" : 0,
					"tonedivision" : 4,
					"hidevoices" : [ 0, 0 ],
					"vzoom" : 99.063667,
					"numoutlets" : 9,
					"restswithinbeaming" : 1,
					"outlettype" : [ "llll.connect", "llll.connect", "llll.connect", "llll.connect", "llll.connect", "llll.connect", "llll.connect", "llll.connect", "bang" ],
					"whole_score_data_0000000000" : [ "score", "(", "slotinfo", "(", 1, "`amplitude envelope", "function", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1080016896, 97, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 2, "`slot function", "function", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 113, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 3, "`slot longlist", "intlist", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1080016896, 119, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 4, "`slot floatlist", "floatlist", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 101, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 5, "`slot long", "int", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1080016896, 114, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 6, "`slot float", "float", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 116, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 7, "`slot text", "text", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 121, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 8, "filelist", "filelist", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 117, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 9, "`slot 9", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 10, "`slot 10", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 11, "`slot 11", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 12, "`slot 12", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 13, "`slot 13", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 14, "`slot 14", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 15, "`slot 15", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", "(", ")", ")", ")", "(", 16, "`slot 16", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 17, "`slot 17", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 18, "`slot 18", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 19, "`slot 19", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 20, "`slot 20", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 21, "`slot 21", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 22, "`slot 22", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 23, "`slot 23", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 24, "`slot 24", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 25, "`slot 25", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 26, "`slot 26", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 27, "`slot 27", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 28, "`slot 28", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 29, "`slot 29", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", "(", 30, "`slot 30", "none", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1072693248, 0, "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 0, "(", ")", ")", ")", "(", "commands", "(", 1, "notecmd", "chordcmd", 0, ")", "(", 2, "notecmd", "chordcmd", 0, ")", "(", 3, "notecmd", "chordcmd", 0, ")", "(", 4, "notecmd", "chordcmd", 0, ")", "(", 5, "notecmd", "chordcmd", 0, ")", ")", "(", "midichannels", 2, 2, ")", "(", "(", "(", "(", 4, 4, ")", "(", "(", "1/4", 60, ")", ")", ")", "(", "1/4", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085770898, 127, 0, 0, ")", 0, ")", "(", "1/8", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085957412, 127, 0, 0, ")", 0, ")", "(", "1/8", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086067126, 127, 0, 0, ")", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086217069, 127, 0, 1, ")", 0, ")", "(", "1/4", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086206098, 127, 0, 0, ")", 0, ")", "(", "1/32", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085653869, 127, 0, 0, ")", 0, ")", "(", "1/32", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085672155, 127, 0, 0, ")", 0, ")", "(", "-1/8", 0, ")", "(", "1/16", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085928155, 127, 0, 0, ")", 0, ")", 0, ")", "(", "(", "(", 4, 4, ")", "(", ")", ")", "(", "1/4", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086067126, 127, 0, 0, ")", 0, ")", "(", "-1/8", 0, ")", "(", "-3/32", 0, ")", "(", "1/32", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085942784, 127, 0, 0, ")", 0, ")", "(", "1/4", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086067126, 127, 0, 0, ")", 0, ")", "(", "1/24", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085906212, 127, 0, 0, ")", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085997641, 127, 0, 0, ")", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086221641, 127, 0, 0, ")", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086364160, 127, 0, 0, ")", 0, ")", "(", "1/24", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085997641, 127, 0, 0, ")", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086364160, 127, 0, 0, ")", 0, ")", "(", "1/24", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085939126, 127, 0, 0, ")", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086221641, 127, 0, 0, ")", 0, ")", "(", "1/8", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086354102, 127, 1, 1, ")", 0, ")", 0, ")", "(", "(", "(", 4, 4, ")", "(", ")", ")", "(", "1/8", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086353188, 127, 0, 0, ")", 0, ")", "(", "1/4", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086189641, 127, 0, 0, ")", 0, ")", "(", "1/8", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086142098, 127, 1, 1, ")", 0, ")", "(", "1/2", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1086142098, 127, 0, 0, ")", 0, ")", 0, ")", ")", "(", "(", "(", "(", 2, 4, ")", "(", "(", "1/4", 60, ")", ")", ")", "(", "1/2", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085491126, 127, 1, 1, ")", 0, ")", 0, ")", "(", "(", "(", 3, 4, ")", "(", ")", ")", "(", "3/20", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085492955, 127, 0, 0, ")", 0, ")", "(", "3/20", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085555126, 127, 0, 0, ")", 0, ")", "(", "3/20", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085514898, 127, 0, 0, ")", 0, ")", "(", "3/20", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085609984, 127, 0, 0, ")", 0, ")", "(", "3/20", "(", "ˇˇˇˇ_float64_ˇˇˇˇ", 0, 1085657526, 127, 0, 0, ")", 0, ")", 0, ")", ")" ],
					"whole_score_data_count" : [ 1 ]
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"source" : [ "obj-38", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-32", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-13", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-34", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-31", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-6", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-3", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-4", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-90", 0 ],
					"destination" : [ "obj-76", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-23", 0 ],
					"destination" : [ "obj-24", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-64", 0 ],
					"destination" : [ "obj-33", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-60", 0 ],
					"destination" : [ "obj-64", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-59", 0 ],
					"destination" : [ "obj-64", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-54", 0 ],
					"destination" : [ "obj-64", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-49", 2 ],
					"destination" : [ "obj-60", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-49", 1 ],
					"destination" : [ "obj-59", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-49", 0 ],
					"destination" : [ "obj-54", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-8", 0 ],
					"destination" : [ "obj-49", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-11", 0 ],
					"destination" : [ "obj-16", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-15", 0 ],
					"destination" : [ "obj-19", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-18", 0 ],
					"destination" : [ "obj-11", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-24", 0 ],
					"destination" : [ "obj-26", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-28", 0 ],
					"destination" : [ "obj-29", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-29", 0 ],
					"destination" : [ "obj-27", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-40", 0 ],
					"destination" : [ "obj-39", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-39", 0 ],
					"destination" : [ "obj-37", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-43", 0 ],
					"destination" : [ "obj-42", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-62", 0 ],
					"destination" : [ "obj-43", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-29", 0 ],
					"destination" : [ "obj-7", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-36", 0 ],
					"destination" : [ "obj-8", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-70", 0 ],
					"destination" : [ "obj-72", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-69", 0 ],
					"destination" : [ "obj-70", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-17", 0 ],
					"destination" : [ "obj-15", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-76", 0 ],
					"destination" : [ "obj-68", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-68", 0 ],
					"destination" : [ "obj-83", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-68", 0 ],
					"destination" : [ "obj-67", 0 ],
					"hidden" : 0,
					"midpoints" : [ 727.5, 312.0, 759.0, 312.0, 759.0, 291.0, 771.5, 291.0 ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-61", 0 ],
					"destination" : [ "obj-28", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-33", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-33", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-42", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-42", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-72", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-72", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-83", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-27", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-37", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-37", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-26", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-26", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-16", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-16", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-19", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-19", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 1,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-20", 0 ],
					"destination" : [ "obj-21", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-21", 0 ],
					"destination" : [ "obj-1", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-30", 0 ],
					"destination" : [ "obj-22", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
, 			{
				"patchline" : 				{
					"source" : [ "obj-22", 0 ],
					"destination" : [ "obj-5", 0 ],
					"hidden" : 0,
					"midpoints" : [  ]
				}

			}
 ]
	}

}
