#include <openssl/ssl.h>
#include <stdio.h>

int main() {
    SSL_library_init();
    printf("App B using OpenSSL version: %s\n", OPENSSL_VERSION_TEXT);
    return 0;
}