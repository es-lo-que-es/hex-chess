#include "SDL2/SDL.h"


int PollEvent(SDL_Event * event)
{
   return SDL_PollEvent(event);
}


int RenderCopy(SDL_Renderer * renderer, SDL_Texture * texture, const SDL_Rect * srcrect, const SDL_Rect * dstrect)
{
   return SDL_RenderCopy(renderer, texture, srcrect, dstrect);
}


int SetTextureColorMod(SDL_Texture * texture, Uint8 r, Uint8 g, Uint8 b)
{
   return SDL_SetTextureColorMod(texture, r, g, b);
}


int SetRenderTarget(SDL_Renderer *renderer, SDL_Texture *texture)
{
   return SDL_SetRenderTarget(renderer, texture);
}

int Init(uint32_t flags) 
{ 
   return SDL_Init(flags);
}


void Quit(void) { SDL_Quit(); }


SDL_Window * CreateWindow(const char *title, int x, int y, int w, int h, Uint32 flags)
{ 
   return SDL_CreateWindow(title, x, y, w, h, flags);
}


void DestroyWindow(SDL_Window * window) { SDL_DestroyWindow(window); }


SDL_Renderer * CreateRenderer(SDL_Window * window, int index, Uint32 flags)
{ 
   return SDL_CreateRenderer(window, index, flags);
}


void DestroyTexture(SDL_Texture * texture)
{
   SDL_DestroyTexture(texture);
}


void DestroyRenderer(SDL_Renderer * renderer)
{
   SDL_DestroyRenderer(renderer);
}


int RenderFillRect(SDL_Renderer * renderer, const SDL_Rect * rect)
{
   return SDL_RenderFillRect(renderer, rect);
}


int SetRenderDrawColor(SDL_Renderer * renderer, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
{ 
   return SDL_SetRenderDrawColor(renderer, r, g, b, a);
}


void RenderPresent(SDL_Renderer * renderer) 
{ 
   SDL_RenderPresent(renderer);
}


int RenderClear(SDL_Renderer * renderer) 
{ 
   return SDL_RenderClear(renderer);
}


SDL_Texture * CreateTexture(SDL_Renderer * renderer, Uint32 format, int access, int w, int h)
{
   return SDL_CreateTexture(renderer, format, access, w, h);
}


int RenderSetLogicalSize(SDL_Renderer * renderer, int w, int h)
{
   return SDL_RenderSetLogicalSize(renderer, w, h);
}


void Delay(Uint32 ms)
{
   SDL_Delay(ms);
}


const char* GetError(void)
{
   return SDL_GetError();
}


int RenderCopyEx(SDL_Renderer * renderer, SDL_Texture * texture, const SDL_Rect * srcrect, const SDL_Rect * dstrect,
                     const double angle, const SDL_Point *center, const SDL_RendererFlip flip)
{                    // why would u make parameter of type double const? its passed by copy anyway ._.
   return SDL_RenderCopyEx(renderer, texture, srcrect, dstrect, angle, center, flip);
}


SDL_Texture * CreateTextureFromSurface(SDL_Renderer * renderer, SDL_Surface * surface)
{
   return SDL_CreateTextureFromSurface(renderer, surface);
}


int RenderDrawRect(SDL_Renderer * renderer, const SDL_Rect * rect)
{
   return SDL_RenderDrawRect(renderer, rect);
}


int GetRenderDrawColor(SDL_Renderer * renderer, Uint8 * r, Uint8 * g, Uint8 * b, Uint8 * a)
{
   return SDL_GetRenderDrawColor(renderer, r, g, b, a);
}
