#include <stdint.h>

#define COPY_BUFFER_SIZE 256
uint8_t COPY_BUFFER_ARR[COPY_BUFFER_SIZE];

void * get_copy_buffer() { return COPY_BUFFER_ARR; }
int copy_buffer_size() { return COPY_BUFFER_SIZE; }
