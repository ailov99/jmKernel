#if !defined(__cplusplus)
#include <stdbool.h>
#endif
#include <stddef.h>
#include <stdint.h>

// check environment
#if defined(__linux__)
#error "you should use a cross-compiler!"
#endif

// only works on 32-bit x86
#if !defined(__i386__)
#error "32-bit x86 required!"
#endif

// HW text-mode colour const
enum vga_color
{
  COLOR_BLACK = 0,
  COLOR_BLUE = 1,
  COLOR_GREEN = 2,
  COLOR_CYAN = 3,
  COLOR_RED = 4,
  COLOR_MAGENTA = 5,
  COLOR_BROWN = 6,
  COLOR_LIGHT_GREY = 7,
  COLOR_DARK_GREY = 8,
  COLOR_LIGHT_BLUE = 9,
  COLOR_LIGHT_GREEN = 10,
  COLOR_LIGHT_CYAN = 11,
  COLOR_LIGHT_RED = 12,
  COLOR_LIGHT_MAGENTA = 13,
  COLOR_LIGHT_BROWN = 14,
  COLOR_WHITE = 15,
};

// MS=bg / LS=fg
uint8_t make_color(enum vga_color fg, enum vga_color bg)
{
  return fg | bg << 4;
}

// MS=color16 / LS=c
uint16_t make_vgaentry(char c, uint8_t color)
{
  uint16_t c16 = c;
  uint16_t color16 = color;
  return c16 | color16 << 8;
}

size_t strlen(const char* str)
{
  size_t ret = 0;
  while (str[ret])  ret++;
  return ret;
}

// hard code these
static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

// track current row/column
size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;

void terminal_setcolor(uint8_t color)
{
  terminal_color = color;
}

// Put a vga entry to the buffer by coordinates
void terminal_putentryat(char c, uint8_t color, size_t x, size_t y)
{
  const size_t index = y * VGA_WIDTH + x;  // translate the coords to single dimension
  terminal_buffer[index] = make_vgaentry(c, color);
}

// write a single char to the terminal
// use default set color and current coordinates
void terminal_putchar(char c)
{
  terminal_putentryat(c, terminal_color, terminal_column, terminal_row);

  // Handle wrap-arounds
  if (++terminal_column == VGA_WIDTH) {
	// reset x-coord
	terminal_column = 0;
	if (++terminal_row == VGA_HEIGHT)
	  // reset y-coord
	  // TODO: implement scrolling
	  terminal_row = 0;
  }

}

// Write a whole string
// (will wrap around properly)
void terminal_writestring(const char* data)
{
  size_t datalen = strlen(data);
  for (size_t i = 0; i < datalen; i++)
	terminal_putchar(data[i]);
}

// Initialize our terminal with light_grey on a black bg
void terminal_initialize()
{
  terminal_row = 0;
  terminal_column = 0;
  terminal_color = make_color(COLOR_LIGHT_GREY, COLOR_BLACK);
  terminal_buffer = (uint16_t*) 0xB8000;
  
  for (size_t y = 0; y < VGA_HEIGHT; y++) {
	for (size_t x = 0; x < VGA_WIDTH; x++) {
	  // set up buffer with empty entries
	  // 80-25 map
	  const size_t index = y * VGA_WIDTH + x;
	  terminal_buffer[index] = make_vgaentry(' ', terminal_color);
	}
  }
}


#if defined(__cplusplus)
extern "C"  // use C linkage for kernel_main
#endif
void kernel_main()
{
  // Initialize terminal interface
  terminal_initialize();

  // TODO: implement a proper \n
  terminal_writestring("This is in the terminal!\n");
}
