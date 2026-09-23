#include <stdio.h>
#include <stdlib.h>
#include "../include/mystrfunctions.h"
#include "../include/myfilefunctions.h"

int main() {
    printf("--- Testing String Functions ---\n");
    char buffer[100] = "Hello";
    printf("Length of 'Hello': %d\n", mystrlen(buffer));
    mystrcat(buffer, " World");
    printf("Concatenated: %s\n", buffer);

    printf("\n--- Testing File Functions ---\n");
    FILE* temp = fopen("sample.txt", "w+");
    if (temp) {
        fputs("Hello Operating Systems\nThis is a testing file.\nHello world!", temp);
        rewind(temp);

        int l, w, c;
        wordCount(temp, &l, &w, &c);
        printf("Lines: %d, Words: %d, Chars: %d\n", l, w, c);

        rewind(temp);
        char** matches = NULL;
        int count = mygrep(temp, "Hello", &matches);
        printf("Matches for 'Hello': %d\n", count);
        for (int i = 0; i < count; i++) {
            printf("  Matched line: %s", matches[i]);
            free(matches[i]);
        }
        free(matches);
        fclose(temp);
        remove("sample.txt");
    }
    return 0;
}
