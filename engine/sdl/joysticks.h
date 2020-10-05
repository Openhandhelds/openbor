/*
 * OpenBOR - http://www.chronocrash.com
 * -----------------------------------------------------------------------
 * All rights reserved, see LICENSE in OpenBOR root for details.
 *
 * Copyright (c) 2004 - 2014 OpenBOR Team
 */

#ifndef	JOYSTICKS_H
#define	JOYSTICKS_H

#define JOY_UNKNOWN_NAME "UNKNOWN"

#define JOY_TYPE_DEFAULT   0
#define JOY_TYPE_GAMEPARK  1
#define JOY_AXIS_X         0
#define JOY_AXIS_Y         1
#define JOY_MAX_INPUTS     64
#define	JOY_LIST_FIRST     600
#define JOY_LIST_TOTAL     4
#define	JOY_LIST_LAST      JOY_LIST_FIRST + JOY_MAX_INPUTS * JOY_LIST_TOTAL
#define JOY_NAME_SIZE      1 + 1 + JOY_MAX_INPUTS * JOY_LIST_TOTAL

#ifdef OPENDINGUX
#define OPENDINGUX_BUTTON_UP     SDLK_UP
#define OPENDINGUX_BUTTON_DOWN   SDLK_DOWN
#define OPENDINGUX_BUTTON_RIGHT  SDLK_RIGHT
#define OPENDINGUX_BUTTON_LEFT   SDLK_LEFT
#define OPENDINGUX_BUTTON_R      SDLK_BACKSPACE
#define OPENDINGUX_BUTTON_L      SDLK_TAB
#define OPENDINGUX_BUTTON_A      SDLK_LCTRL
#define OPENDINGUX_BUTTON_B      SDLK_LALT
#define OPENDINGUX_BUTTON_X      SDLK_SPACE
#define OPENDINGUX_BUTTON_Y      SDLK_LSHIFT
#define OPENDINGUX_BUTTON_SELECT SDLK_ESCAPE
#define OPENDINGUX_BUTTON_START  SDLK_RETURN
#endif

#ifdef PANDORA
#ifdef SDL2
#define PANDORA_BUTTON_UP      SDL_SCANCODE_UP
#define PANDORA_BUTTON_DOWN    SDL_SCANCODE_DOWN
#define PANDORA_BUTTON_RIGHT   SDL_SCANCODE_RIGHT
#define PANDORA_BUTTON_LEFT    SDL_SCANCODE_LEFT
#define PANDORA_BUTTON_R1      SDL_SCANCODE_RCTRL
#define PANDORA_BUTTON_L1      SDL_SCANCODE_RSHIFT
#define PANDORA_BUTTON_A       SDL_SCANCODE_HOME
#define PANDORA_BUTTON_B       SDL_SCANCODE_END
#define PANDORA_BUTTON_X       SDL_SCANCODE_PAGEDOWN
#define PANDORA_BUTTON_Y       SDL_SCANCODE_PAGEUP
#define PANDORA_BUTTON_SELECT  SDL_SCANCODE_LCTRL
#define PANDORA_BUTTON_START   SDL_SCANCODE_LALT
#else
#define PANDORA_BUTTON_UP      SDLK_UP
#define PANDORA_BUTTON_DOWN    SDLK_DOWN
#define PANDORA_BUTTON_RIGHT   SDLK_RIGHT
#define PANDORA_BUTTON_LEFT    SDLK_LEFT
#define PANDORA_BUTTON_R1      SDLK_RCTRL
#define PANDORA_BUTTON_L1      SDLK_RSHIFT
#define PANDORA_BUTTON_A       SDLK_HOME
#define PANDORA_BUTTON_B       SDLK_END
#define PANDORA_BUTTON_X       SDLK_PAGEDOWN
#define PANDORA_BUTTON_Y       SDLK_PAGEUP
#define PANDORA_BUTTON_SELECT  SDLK_LCTRL
#define PANDORA_BUTTON_START   SDLK_LALT
#endif
#endif

/* Real-Time Joystick Data */
typedef struct{
	char Name[MAX_BUFFER_LEN];
	char KeyName[JOY_MAX_INPUTS + 1][MAX_BUFFER_LEN];
	int Type;
	int NumHats;
	int NumAxes;
	int NumButtons;
	u32 Hats;
	u32 Axes;
	u32 Buttons;
	u64 Data;
}s_joysticks;
extern s_joysticks joysticks[JOY_LIST_TOTAL];


extern const char *JoystickKeyName[JOY_NAME_SIZE];
extern const char *GameparkKeyName[JOY_NAME_SIZE];
extern const u64 JoystickBits[JOY_MAX_INPUTS + 1];

const char* PC_GetJoystickKeyName(int portnum, int keynum);
char* JOY_GetKeyName(int keycode);


#endif
