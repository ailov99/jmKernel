// Defines the C-code entry point and calls initialisation routines
//
// Calling conventions (gcc on x86):
// - all params to func passed on stack
// - params pushed right-to-left
// - return value is returned in EAX

int main(struct multiboot *mboot_ptr)
{
  // all init calls go here
  return 0xDEADBABA;
}

