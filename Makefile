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
# - support concurrent targets (include OBJSPACE_ARGS)
# - fix different archs (lib_pypy/*cache*)
# - fix jit on non x86 archs

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
TRANSLATE_ARGS+=	--gcrootfinder=shadowstack

.include <bsd.port.pre.mk>

PYPY?=		${LOCALBASE}/bin/pypy
.if exists(${PYPY}) # Use pypy if it is installed, else use python
PY=		${PYPY}
.else
USE_PYTHON_BUILD=	2.5+
PY=		${PYTHON_CMD}
.endif

.if exists(${PREFIX}/bin/pypy)
PLIST_SUB+=	PYPY="@comment "
.else
PLIST_SUB+=	PYPY=""
.endif

do-build:
	${RM} -rf ${WRKDIR}/pypy-c
	${MKDIR} ${WRKDIR}/pypy-c
	(cd ${WRKSRC}/pypy/translator/goal; ${SETENV} ${MAKE_ENV} TMPDIR=${WRKDIR}/pypy-c ${PY} translate.py ${TRANSLATE_ARGS} -Ojit)

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
.if !exists(${PREFIX}/bin/pypy)
	-${LN} -s ${PYPYPREFIX}/bin/pypy ${PREFIX}/bin/pypy
.endif
	${PYPYPREFIX}/bin/pypy -m compileall

.include <bsd.port.post.mk>
