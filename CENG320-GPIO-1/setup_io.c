#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#define PAGE_SIZE (4*1024)
#define BLOCK_SIZE (4*1024)
// #define BCM2708_PERI_BASE        0xFE000000
#define BCM2708_PERI_BASE 0x3F000000
#define GPIO_BASE                (BCM2708_PERI_BASE + 0x200000) /* GPIO controller */

volatile unsigned * setup_io();

volatile unsigned * setup_io()
{
  int mem_fd;
  void* gpio_map;
  /* open /dev/mem */
  if ((mem_fd = open("/dev/mem", O_RDWR|O_SYNC) ) < 0) {
    printf("can't open /dev/mem \n");
    exit(-1);
  }

  /* mmap GPIO */
  gpio_map = mmap(
                  NULL,             //Any adddress in our space will do
                  BLOCK_SIZE,       //Map length
                  PROT_READ|PROT_WRITE,// Enable reading & writting to mapped memory
                  MAP_SHARED,       //Shared with other processes
                  mem_fd,           //File to map
                  GPIO_BASE         //Offset to GPIO peripheral
                  );

  close(mem_fd); //No need to keep mem_fd open after mmap

  if (gpio_map == MAP_FAILED) {
    printf("mmap error %d\n", (long long int)gpio_map);//errno also set!
    exit(-1);
  }

  // Always use volatile pointer!
  return (volatile unsigned *)gpio_map;


} // setup_io
