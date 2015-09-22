//
//  ELC_Types_AS.h
//  LibAnswerSheet
//
//  Created by huanghao on 15-2-4.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#ifndef LibAnswerSheetDataStruct_ELC_Types_AS_h
#define LibAnswerSheetDataStruct_ELC_Types_AS_h

#include <stdbool.h>

#define Elc_FALSE   (false)
#define Elc_TRUE    (true)


typedef unsigned char               Elc_U8;
typedef unsigned short              Elc_U16;
typedef unsigned int                    Elc_U32;
typedef unsigned long long          Elc_U64;

typedef char                    Elc_S8;
typedef short                   Elc_S16;
typedef int                     Elc_S32;
typedef long long               Elc_S64;

typedef bool                    Elc_BOOL;

typedef void *                      Elc_LPVOID;
typedef const void *            Elc_LPCVOID;

typedef long                            Elc_LONG;
typedef unsigned long           Elc_ULONG;

typedef unsigned short      UTF16;

typedef int         WPARAM;
typedef long        LPARAM;


struct _CPoint {
    short               v;
    short               h;
};
typedef struct _CPoint                    CPoint;


//#define INFINITE	(Elc_U32)(-1)

#ifndef MAKETAG
#define MAKETAG(a, b, c, d)                     \
(((long)(unsigned char)(d) << 0) |      \
 ((long)(unsigned char)(c) << 8) |      \
 ((long)(unsigned char)(b) << 16) |     \
 ((long)(unsigned char)(a) << 24))
#endif

//
#ifndef	SAFE_DELETE
#define SAFE_DELETE(x)	\
if (NULL != x){delete x; x = NULL;}
#endif

#ifndef SAFE_DELETE_ARRAY
#define SAFE_DELETE_ARRAY(x)	\
if (NULL != x){delete[] x; x = NULL;}
#endif

#ifndef SAFE_DESTROY_WINDOW
#define SAFE_DESTROY_WINDOW(x)	\
if (NULL != x){x->DestroyWindow(); delete x; x = NULL;}
#endif

#ifndef SAFE_CLOSE_HANDLE
#define SAFE_CLOSE_HANDLE(x)	\
if (NULL != x){::CloseHandle(x); x = NULL;}
#endif

#ifndef	SAFE_INVOKE
#define SAFE_INVOKE(object_ptr, method)	\
if (NULL != object_ptr){object_ptr->method;}
#endif

#ifndef DISABLE_COPY
#define DISABLE_COPY(x)	\
private:	\
const x& operator=(const x& other);	\
x(const x& other);
#endif


//#ifndef Override
//#define Override
//#endif
//
//#ifndef Throwable
//#define Throwable
//#endif
//
//#ifndef deleteable
//#define deleteable
//#endif

////
//#ifndef __in
//#define __in
//#endif



#endif
