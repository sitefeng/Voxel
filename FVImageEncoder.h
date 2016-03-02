//
//  FVImageEncoder.h
//  Voxel
//
//  Created by Si Te Feng on 2/15/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

#ifndef FVImageEncoder_h
#define FVImageEncoder_h

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

char *base64_encode(const unsigned char *data,
                    size_t input_length,
                    size_t *output_length);

unsigned char *base64_decode(const char *data,
                             size_t input_length,
                             size_t *output_length);


#endif /* FVImageEncoder_h */
