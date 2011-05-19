# New ports collection makefile for:	pypy
# Date created:				2011/05/17
# Whom:					David Naylor <naylor.b.david@gmail.com>
#
# $FreeBSD$
#

# TODO:
# - use clang when possible (uses less memory on compile)
# - warn about long compile times and high memory requirements
# - XXX's below
# - support multiple targets (stackless, sandbox)
# - fix different archs (lib_pypy/*cache*)
# - fix jit on non x86 archs
# - add test target
# - support -O1 (gc)

PORTNAME=	pypy
DISTVERSION=	1.5
CATEGORIES=	lang python
MASTER_SITES=	http://pypy.org/download/
DISTNAME=	${PORTNAME}-${DISTVERSION}-src

MAINTAINER=	naylor.b.david@gmail.com
COMMENT=	PyPy is a fast, compliant implementation of the Python language

LIB_DEPENDS=	expat:${PORTSDIR}/textproc/expat2 \
		ffi:${PORTSDIR}/devel/libffi

# XXX: fixup licenses (LGPL21, others)
LICENSE=	MIT PSFL
LICENSE_COMB=	multi
# XXX: not unsafe, just uses only one job
MAKE_JOBS_UNSAFE=	yes
USE_BZIP2=	yes
USE_ICONV=	yes
USE_GETTEXT=	yes

PYPYDIRS=	include lib-python lib_pypy site-packages
PYPYPREFIX?=	${PREFIX}/${PORTNAME}-${DISTVERSION}
PLIST_SUB+=	PYPYPREFIX="${PYPYPREFIX:S|^${PREFIX}/||g}" \
		DISTVERSION="${DISTVERSION}"
# See http://readthedocs.org/docs/pypy/latest/config/index.html for a list of
# options available.  --gcrootfinder=asmgcc does not work under FreeBSD/amd64.
TRANSLATE_ARGS+=	--gcrootfinder=shadowstack -Ojit

.include <bsd.port.pre.mk>

# Use pypy if it is installed, else use python (to translate)
PYPY?=		${LOCALBASE}/bin/pypy
.if exists(${PYPY})
PY=		${PYPY}
.else
USE_PYTHON_BUILD=	2.5+
PY=		${PYTHON_CMD}
.endif

# Translate FreeBSD ARCH types to PyPy ARCH types
# Pypy officially only supports i386 and amd64, the other platforms are
# untested (and do not have jit support).
.if ${ARCH} == "i386"
PYPY_ARCH=	"x86_32"
PYPY_JITTABLE=	YES
.elif ${ARCH} == "amd64"
PYPY_ARCH=	"x86_64"
PYPY_JITTABLE=	YES
.elif ${ARCH} == "powerpc"
PYPY_ARCH=	"ppc_32"
.elif ${ARCH} == "powerpc64"
PYPY_ARCH=	"ppc_64"
.else
PYPY_ARCH=	${ARCH}
.endif
PLIST_SUB+=	PYPY_ARCH="${PYPY_ARCH}"

do-build:
	${RM} -rf ${WRKDIR}/pypy-c
	${MKDIR} ${WRKDIR}/pypy-c
	(cd ${WRKSRC}/pypy/translator/goal; ${SETENV} ${MAKE_ENV} TMPDIR=${WRKDIR}/pypy-c ${PY} translate.py ${TRANSLATE_ARGS})

do-install:
	${MKDIR} ${PYPYPREFIX} ${PYPYPREFIX}/bin
.for dir in ${PYPYDIRS}
	${CP} -r ${WRKSRC}/${dir} ${PYPYPREFIX}/
.endfor
.for file in LICENSE README
	${INSTALL_DATA} ${WRKSRC}/${file} ${PYPYPREFIX}/${file}
.endfor
	${INSTALL_PROGRAM} ${WRKDIR}/pypy-c/usession-unknown-0/testing_1/pypy-c ${PYPYPREFIX}/bin/pypy
	${LN} -fs ${PYPYPREFIX}/bin/pypy ${PREFIX}/bin/pypy${DISTVERSION}
	${LN} -s ${PYPYPREFIX}/bin/pypy ${PREFIX}/bin/pypy
	${PYPYPREFIX}/bin/pypy -m compileall

.include <bsd.port.post.mk>
