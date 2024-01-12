#include "SDL2/SDL_image.h"


int Image_Init(int flags)
{
   return IMG_Init(flags);
}


SDL_Surface * Image_Load(const char *file)
{
   return IMG_Load(file);
}


void FreeSurface(SDL_Surface * surface)
{
   SDL_FreeSurface(surface);
}


void Image_Quit(void)
{
   IMG_Quit();
}
