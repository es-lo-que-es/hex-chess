cmake_minimum_required(VERSION 3.10)

project(sdl2_exports)


SET(CMAKE_C_COMPILER "emcc")

file(COPY ../../pics DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

set(USE_FLAGS "-sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS='[\"png\"]'")
set(PRELOAD_FILES "--preload-file=pics --use-preload-plugins")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${USE_FLAGS}")


# SDL exports
set(
   EXPORTED_FUNCTIONS 
   "_PollEvent,_RenderCopy,_SetTextureColorMod,_SetRenderTarget,_RenderClear,_CreateTexture,_GetError,_DestroyTexture,_Init,_CreateWindow,_CreateRenderer,_SetRenderDrawColor,_RenderSetLogicalSize,_DestroyRenderer,_DestroyWindow,_Quit,_RenderPresent,_Delay,_RenderCopyEx,_CreateTextureFromSurface,_FreeSurface,_GetRenderDrawColor,_RenderDrawRect,_RenderFillRect"
)

# SDL_Image exports
set(
   EXPORTED_FUNCTIONS 
   "${EXPORTED_FUNCTIONS},_Image_Init,_Image_Quit,_Image_Load"
)

# copy buffer
set(
   EXPORTED_FUNCTIONS 
   "${EXPORTED_FUNCTIONS},_get_copy_buffer,_copy_buffer_size"
)


set(LINKER_FLAGS "-sEXPORTED_RUNTIME_METHODS=ccall,cwrap -sEXPORTED_FUNCTIONS=${EXPORTED_FUNCTIONS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${USE_FLAGS} ${LINKER_FLAGS} ${PRELOAD_FILES}")
set(CMAKE_EXECUTABLE_SUFFIX .js)


add_executable(mycexports sdl2_exports.c sdl2_image_exports.c copy_buffer.c)
