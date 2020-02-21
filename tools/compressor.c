//
// Created by andgel on 13/02/2020
//

#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>

bool compress(char *path)
{
    struct stat s;
    FILE *stream = fopen(path, "r");
    char *buffer;

    if (stat(path, &s) == -1 || !stream)
        return perror(path), false;
    if (s.st_size % 2 == 1)
        return fprintf(stderr, "%s: %s\n", path, "File size mush be even"), fclose(stream), false;
    buffer = malloc(s.st_size);
    fread(buffer, 1, s.st_size, stream);
    fclose(stream);

    for (int i = 0; i < s.st_size / 2; i++)
        buffer[i] = buffer[i * 2];

    stream = fopen(path, "w");
    if (!stream)
        return perror(path), free(buffer), false;
    fwrite(buffer, 1, s.st_size / 2, stream);
    fclose(stream);

    free(buffer);
    return true;
}

int main(int argc, char **argv)
{
    for (int i = 1; i < argc; i++)
        if (!compress(argv[i]))
            return EXIT_FAILURE;
    return EXIT_SUCCESS;
}