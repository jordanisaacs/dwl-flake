/* appearance */
static const int sloppyfocus        = 1;  /* focus follows mouse */
static const unsigned int borderpx  = 1;  /* border pixel of windows */
static const float rootcolor[]      = {0.3, 0.3, 0.3, 1.0};
static const float bordercolor[]    = {0.5, 0.5, 0.5, 1.0};
static const float focuscolor[]     = {1.0, 0.0, 0.0, 1.0};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* app_id     title       tags mask     isfloating   monitor */
	/* examples:
	{ "Gimp",     NULL,       0,            1,           -1 },
	{ "firefox",  NULL,       1 << 8,       0,           -1 },
	*/
};

/* layout(s) */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* monitors
 * The order in which monitors are defined determines their position.
 * Non-configured monitors are always added to the left. */
static const MonitorRule monrules[] = {
	/* name       mfact nmaster scale layout       rotate/reflect x y */
	/* example of a HiDPI laptop monitor:
	{ "eDP-1",    0.5,  1,      2,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL, 0, 0 },
	*/
	/* defaults */
	{ NULL,       0.55, 1,      1,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL, 0, 0 },
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
	/* can specify fields: rules, model, layout, variant, options */
	/* example:
	.options = "ctrl:nocaps",
	*/
};

static const int repeat_rate = 25;
static const int repeat_delay = 600;

/* Trackpad */
static const int tap_to_click = 1;
static const int natural_scrolling = 0;

#define MODKEY WLR_MODIFIER_ALT
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                    KEY,            view,            {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL,  KEY,            toggleview,      {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_SHIFT, KEY,            tag,             {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT,KEY,toggletag,  {.ui = 1 << TAG} }

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *termcmd[] = { "alacritty", NULL };
static const char *menucmd[] = { "bemenu-run", NULL };

static const Key keys[] = {
	/* modifier                  key          function        argument */
	{ MODKEY,                    33,          spawn,          {.v = menucmd} }, /* p */
	{ MODKEY|WLR_MODIFIER_SHIFT, 36,          spawn,          {.v = termcmd} }, /* Return */
	{ MODKEY,                    44,          focusstack,     {.i = +1} },      /* j */
	{ MODKEY,                    45,          focusstack,     {.i = -1} },      /* k */
	{ MODKEY,                    31,          incnmaster,     {.i = +1} },      /* i */
	{ MODKEY,                    40,          incnmaster,     {.i = -1} },      /* d */
	{ MODKEY,                    43,          setmfact,       {.f = -0.05} },   /* h */
	{ MODKEY,                    46,          setmfact,       {.f = +0.05} },   /* l */
	{ MODKEY,                    36,          zoom,           {0} },            /* Return */
	{ MODKEY,                    23,          view,           {0} },            /* Tab */
	{ MODKEY|WLR_MODIFIER_SHIFT, 54,          killclient,     {0} },            /* c */
	{ MODKEY,                    28,          setlayout,      {.v = &layouts[0]} }, /* t */
	{ MODKEY,                    41,          setlayout,      {.v = &layouts[1]} }, /* f */
	{ MODKEY,                    58,          setlayout,      {.v = &layouts[2]} }, /* m */
	{ MODKEY,                    65,          setlayout,      {0} },            /* Space */
	{ MODKEY|WLR_MODIFIER_SHIFT, 65,          togglefloating, {0} },            /* Space */
	{ MODKEY,                    26,          togglefullscreen, {0} },          /* e */
	{ MODKEY,                    19,          view,           {.ui = ~0} },     /* 0 */
	{ MODKEY|WLR_MODIFIER_SHIFT, 16,          tag,            {.ui = ~0} },     /* 0 */
	{ MODKEY,                    59,          focusmon,       {.i = WLR_DIRECTION_LEFT} },  /* comma */
	{ MODKEY,                    60,          focusmon,       {.i = WLR_DIRECTION_RIGHT} }, /* period */
	{ MODKEY|WLR_MODIFIER_SHIFT, 59,          tagmon,         {.i = WLR_DIRECTION_LEFT} },  /* comma */
	{ MODKEY|WLR_MODIFIER_SHIFT, 60,          tagmon,         {.i = WLR_DIRECTION_RIGHT} }, /* period */
	TAGKEYS(                     10,                          0),               /* 1 */
	TAGKEYS(                     11,                          1),               /* 2 */
	TAGKEYS(                     12,                          2),               /* 3 */
	TAGKEYS(                     13,                          3),               /* 4 */
	TAGKEYS(                     14,                          4),               /* 5 */
	TAGKEYS(                     15,                          5),               /* 6 */
	TAGKEYS(                     16,                          6),               /* 7 */
	TAGKEYS(                     17,                          7),               /* 8 */
	TAGKEYS(                     18,                          8),               /* 9 */
	{ MODKEY|WLR_MODIFIER_SHIFT, 24,          quit,           {0} },            /* q */

	/* Ctrl-Alt-Backspace and Ctrl-Alt-Fx used to be handled by X server */
	{ WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT, 22, quit,           {0} },
#define CHVT(KEY,n) { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT, KEY, chvt, {.ui = (n)} }
	CHVT(67, 1), CHVT(68, 2), CHVT(69, 3), CHVT(70, 4),  CHVT(71, 5),  CHVT(72, 6),
	CHVT(73, 7), CHVT(74, 8), CHVT(75, 9), CHVT(76, 10), CHVT(95, 11), CHVT(96, 12),
};

static const Button buttons[] = {
	{ MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
	{ MODKEY, BTN_MIDDLE, togglefloating, {0} },
	{ MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
};
