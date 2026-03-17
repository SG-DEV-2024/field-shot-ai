//#include <malloc.h>
#include <stdlib.h>

#include "tjpgd.h"
#include "jni_jpg.h"

extern "C" {
    using namespace std;

#define MODE	0	/* Test mode: 0:Show decmpression status, 1:and output in BMP */
#define SCALE	0	/* Output scaling 0:1/1, 1:1/2, 2:1/4 or 3:1/8 */

/*---------------------------------*/
/* User defined session identifier */
/*---------------------------------*/
typedef struct {
//    HANDLE hin;			/* Handle to the input stream */
//    uint8_t *frmbuf;	/* Pointer to the frame buffer */
    uint32_t wbyte;		/* Number of bytes a line in the frame buffer */
    uint8_t* pimage;
    uint32_t offset;
} IODEV;


/*-----------------------------*/
/* User defined input function */
/*-----------------------------*/

__attribute__((visibility("default"))) __attribute__((used))
size_t input_func (	/* Returns number of bytes read (zero on error) */
        JDEC* jd,		/* Decompression object */
        uint8_t* buff,	/* Pointer to the read buffer (null to remove data) */
        size_t ndata	/* Number of bytes to read/skip */
)
{
//    DWORD rb;
    IODEV *dev = (IODEV*)jd->device;

    if (buff) {	/* Read bytes from input stream */
//        ReadFile(dev->hin, buff, ndata, &rb, 0);
//        return (size_t)rb;
        memcpy(buff, dev->pimage + dev->offset, ndata);
    } else {	/* Remove bytes from input stream */
//        rb = SetFilePointer(dev->hin, ndata, 0, FILE_CURRENT);
//        return rb == 0xFFFFFFFF ? 0 : ndata;
    }
    dev->offset += ndata;
    return (size_t)ndata;
}

// Export the function for use with Flutter FFI
__attribute__((visibility("default"))) __attribute__((used))
int nativeCheckJpg(uint8_t* pbuf, size_t len) {
    const size_t sz_work = 32768;  // Size of working buffer for TJpgDec module
    void* jdwork;                  // Pointer to TJpgDec work area
    JDEC jd;                       // TJpgDec decompression object
    IODEV iodev;                   // Identifier of the decompression session
    JRESULT rc;
    uint32_t xb, xs, ys;

    // Initialize IODEV structure
    iodev.pimage = pbuf;
    iodev.offset = 0;

    // Allocate work area for TJpgDec
    jdwork = malloc(sz_work);
    if (!jdwork) {
        return -1;  // Memory allocation failed
    }

    // Prepare to decompress the JPEG image
    rc = jd_prepare(&jd, input_func, jdwork, sz_work, &iodev);

    if (rc == JDR_OK) {
        // Initialize frame buffer
        xs = jd.width >> SCALE;     // Image width after scaling
        ys = jd.height >> SCALE;    // Image height after scaling
        xb = (xs * 3 + 3) & ~3;     // Byte width of the frame buffer
        iodev.wbyte = xb;

        // Start JPEG decompression
        rc = jd_decomp(&jd, nullptr, SCALE);
    }

    // Free the work area
    free(jdwork);

    return static_cast<int>(rc);
}
}