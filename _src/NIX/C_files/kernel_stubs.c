// schrod/_src/NIX/kernel_stubs.c
// me rendi a ele
// maldito nim imprestável
#include <stdint.h>

// escrever essas coisas em C é como estar em uma terça
uint8_t nimInErrorMode = 0;
uint8_t nimInErrorMode__OOZOOZOOZOOZOOZOOZOOZOOZusrZlibZnimZsystem_u2213 = 0;

void __stack_chk_fail_local(void) {
    __asm__ volatile (
        "cli\n"
        "hlt\n"
        "jmp ."
    );
}

// nossa, o quanto eu copiei o Linux nessa parte aqui não tá escrito
// (tá escrito sim, nesse código. abafa o caso)
void *memcpy(void *dest, const void *src, unsigned int n) {
    unsigned char *d = (unsigned char *)dest;
    const unsigned char *s = (const unsigned char *)src;

    while (n--) {
        *d++ = *s++;
    }

    return dest;
}

void *memset(void *dest, int val, unsigned int n) {
    unsigned char *d = (unsigned char *)dest;
    unsigned char v = (unsigned char)val;

    while (n--) {
        *d++ = v;
    }

    return dest;
}

unsigned int strlen(const char *s) {
    unsigned int len = 0;

    while (s[len] != 0) {
        len++;
    }

    return len;
}